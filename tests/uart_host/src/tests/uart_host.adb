--  SPDX-License-Identifier: Apache-2.0
--  Chapter 15 on the host: baud-rate divisors for both chips against
--  values worked by hand, the ring in order and full and empty, the
--  ring between two tasks, the line discipline and the words, NMEA
--  sentences, AT replies, and log lines and the sink that drops
--  them whole.
with Ada.Text_IO;          use Ada.Text_IO;
with Ada.Command_Line;
with System.Machine_Code;
with Char_Rings;           use Char_Rings;
with Keel.AT_Replies;      use Keel.AT_Replies;
with Keel.Bus.UART;        use Keel.Bus.UART;
with Keel.Bus.UART.Chip_Limits; use Keel.Bus.UART.Chip_Limits;
with Keel.CLI;             use Keel.CLI;
with Keel.CLI.Lines;       use Keel.CLI.Lines;
with Keel.CLI.Words;       use Keel.CLI.Words;
with Keel.Log;             use Keel.Log;
with Keel.Log.UART_Sink;
with Keel.NMEA;
with SPSC_Rings;

procedure UART_Host is
   Failures : Natural := 0;

   procedure Check (Name : String; OK : Boolean) is
   begin
      Put_Line ((if OK then "ok: " else "FAIL: ") & Name);
      if not OK then
         Failures := Failures + 1;
      end if;
   end Check;

   function Image (N : Long_Long_Integer) return String is
      S : constant String := N'Image;
   begin
      return (if N < 0 then S else S (S'First + 1 .. S'Last));
   end Image;

   ------------------------------------------------------------------
   --  Divisors
   ------------------------------------------------------------------

   --  S in a field of Width, on the right, or on the left
   function Pad (S : String; Width : Positive; Left : Boolean := False)
     return String
   is (if S'Length >= Width then S
       elsif Left then S & [1 .. Width - S'Length => ' ']
       else [1 .. Width - S'Length => ' '] & S);

   --  One row of the table: the divisor, the rate it makes, the error
   procedure Row
     (Chip : String; L : Divider_Limits; Clock : Clock_Hz;
      Baud : Baud_Rate)
   is
      D     : Divisor;
      Found : Boolean;
   begin
      Solve (L, Clock, Baud, D, Found);
      Put (Pad (Chip, 7, Left => True)
           & Pad (Image (Long_Long_Integer (Clock / 1_000_000)), 4)
           & " MHz" & Pad (Image (Long_Long_Integer (Baud)), 10));
      if not Found then
         Put_Line ("  out of range");
         return;
      end if;
      declare
         Div : constant String :=
           (if L.Scale = 4
            then Image (Long_Long_Integer (D / 64)) & "+"
                 & Image (Long_Long_Integer (D mod 64)) & "/64"
            else Image (Long_Long_Integer (D)));
         Made : constant String := Image (Actual (L, Clock, D));
         PPM  : constant String :=
           Image (Error_PPM (L, Clock, Baud, D));
      begin
         Put_Line (Pad (Div, 12) & Pad (Made, 10) & Pad (PPM, 6));
      end;
   end Row;

   procedure Expect
     (Name : String; L : Divider_Limits; Clock : Clock_Hz;
      Baud : Baud_Rate; Want : Divisor)
   is
      D     : Divisor;
      Found : Boolean;
   begin
      Solve (L, Clock, Baud, D, Found);
      Check (Name, Found and then D = Want);
   end Expect;

   procedure Divisors is
      Rates : constant array (1 .. 5) of Baud_Rate :=
        [9_600, 115_200, 921_600, 3_000_000, 10_000_000];
   begin
      Put_Line
        ("chip    clock        baud     divisor      made   ppm");
      for B of Rates loop
         Row ("PL011", RP2350_PL011, 150_000_000, B);
      end loop;
      for B of Rates loop
         Row ("PL011", RP2350_PL011, 48_000_000, B);
      end loop;
      for B of Rates loop
         Row ("LPUART", STM32G4_LPUART, 16_000_000, B);
      end loop;
      --  The datasheet's example (12.1.3.2.1): 67 + 52/64
      Expect ("PL011 at 125 MHz, 115200: 67 + 52/64", RP2350_PL011,
              125_000_000, 115_200, 67 * 64 + 52);
      Expect ("PL011 at 150 MHz, 115200: 81 + 24/64", RP2350_PL011,
              150_000_000, 115_200, 81 * 64 + 24);
      --  256 * 16 000 000 / 115 200 = 35 555.6
      Expect ("LPUART at 16 MHz, 115200: 35556", STM32G4_LPUART,
              16_000_000, 115_200, 35_556);
   end Divisors;

   ------------------------------------------------------------------
   --  The ring, one side after the other
   ------------------------------------------------------------------

   procedure In_Order is
      R  : Bytes.Ring;
      C  : Character;
      OK : Boolean := True;
   begin
      for I in 1 .. Bytes.Capacity loop
         Bytes.Push (R, Character'Val (I - 1));
      end loop;
      Check ("256 pushes fill the ring", Bytes.Is_Full (R));
      for I in 1 .. Bytes.Capacity loop
         Bytes.Pop (R, C);
         OK := OK and then C = Character'Val (I - 1);
      end loop;
      Check ("256 pops give them back in order, and empty it",
             OK and then Bytes.Is_Empty (R));
      --  Round and round: a million through a ring of 4
      declare
         W : Char_Rings.Words.Ring;
         N : Integer;
      begin
         OK := True;
         for I in 1 .. 1_000_000 loop
            Char_Rings.Words.Push (W, I);
            if Char_Rings.Words.Length (W) = Char_Rings.Words.Capacity
            then
               for J in reverse 0 .. Char_Rings.Words.Capacity - 1 loop
                  Char_Rings.Words.Pop (W, N);
                  OK := OK and then N = I - J;
               end loop;
            end if;
         end loop;
         Check ("a million through a ring of 4, in order", OK);
      end;
   end In_Order;

   ------------------------------------------------------------------
   --  The ring between two tasks
   ------------------------------------------------------------------

   --  A full barrier on x86-64: neither the compiler nor the CPU
   --  moves a memory access across it. The board's DMB does this.
   procedure Fence is
   begin
      System.Machine_Code.Asm
        ("mfence", Volatile => True, Clobber => "memory");
   end Fence;

   procedure Two_Tasks is
      Total : constant := 2_000_000;
      Shared : SPSC_Rings.Ring;
      Wrong  : Natural := 0;

      task Producer;
      --  The loop below waits for the other task to change Shared
      pragma Warnings (Off, "variable ""Shared"" is not modified*");
      pragma Warnings (Off, "possible infinite loop");
      task body Producer is
      begin
         for I in 1 .. Total loop
            loop
               Fence;
               exit when not SPSC_Rings.Is_Full (Shared);
            end loop;
            SPSC_Rings.Push (Shared, I);
            Fence;
         end loop;
      end Producer;

      Expected : Integer := 1;
      N        : Integer;
   begin
      while Expected <= Total loop
         Fence;
         if not SPSC_Rings.Is_Empty (Shared) then
            SPSC_Rings.Pop (Shared, N);
            Fence;
            if N /= Expected then
               Wrong := Wrong + 1;
            end if;
            Expected := Expected + 1;
         end if;
      end loop;
      Check ("two tasks, 2000000 through a ring of 16: none out of "
             & "order", Wrong = 0);
   end Two_Tasks;

   ------------------------------------------------------------------
   --  The line discipline and the words
   ------------------------------------------------------------------

   function Show (A : Action) return String is
     (case A is
         when Nothing  => "",
         when Echo     => "e",
         when Rub_Out  => "<",
         when Line_End => "|",
         when Cancel   => "^",
         when Ring     => "!");

   --  Feed Keys; the actions as a string, and the line
   procedure Type_In
     (Keys : String; Acts : out String; Last : out Natural;
      Line : out String; Line_Last : out Natural)
   is
      Ed  : Editor;
      Act : Action;
   begin
      Last := 0;
      Line_Last := 0;
      for K of Keys loop
         Feed (Ed, K, Act);
         declare
            S : constant String := Show (Act);
         begin
            Acts (Last + 1 .. Last + S'Length) := S;
            Last := Last + S'Length;
         end;
         if Act = Line_End then
            Line (Line'First .. Line'First + Length (Ed) - 1) :=
              Text (Ed);
            Line_Last := Length (Ed);
            Clear (Ed);
         end if;
      end loop;
   end Type_In;

   procedure Typing
     (Name : String; Keys : String; Want_Acts : String;
      Want_Line : String)
   is
      Acts : String (1 .. 200);
      Line : String (1 .. Max_Line);
      Last, Line_Last : Natural;
   begin
      Type_In (Keys, Acts, Last, Line, Line_Last);
      Check (Name & ": "
             & (if Last <= 20
                then Acts (1 .. Last) & " gives """
                     & Line (1 .. Line_Last) & """"
                else Acts (Last - 1 .. Last) & " at the end, and"
                     & Line_Last'Image & " characters"),
             Acts (1 .. Last) = Want_Acts
             and then Line (1 .. Line_Last) = Want_Line);
   end Typing;

   procedure Discipline is
      Long : constant String (1 .. Max_Line + 1) := [others => 'x'];
   begin
      Typing ("CR ends a line", "led" & CR, "eee|", "led");
      Typing ("LF ends a line", "led" & LF, "eee|", "led");
      Typing ("CR LF ends it once", "a" & CR & LF & "b" & CR,
              "e|e|", "b");
      Typing ("Backspace rubs out", "lex" & BS & "d" & CR,
              "eee<e|", "led");
      Typing ("Delete rubs out", "lex" & DEL & "d" & CR,
              "eee<e|", "led");
      Typing ("rubbing out nothing does nothing", BS & "a" & CR,
              "e|", "a");
      Typing ("Ctrl-C throws the line away", "ab" & Ctrl_C & "c" & CR,
              "ee^e|", "c");
      Typing ("arrow keys are swallowed",
              "a" & ESC & "[A" & ESC & "[1;5C" & "b" & CR, "ee|", "ab");
      Typing ("a 97th character rings the bell", Long & CR,
              [1 .. Max_Line => 'e'] & "!|", Long (1 .. Max_Line));
   end Discipline;

   procedure Splitting is
      A  : Arguments;
      N  : Number;
      OK : Boolean;
   begin
      Split ("  pwm   14 50 ", A);
      Check ("""  pwm   14 50 "": 3 words",
             Keel.CLI.Words.Count (A) = 3 and then Word (A, 1) = "pwm"
             and then Word (A, 2) = "14" and then Word (A, 3) = "50");
      Split ("", A);
      Check (""""": no words", Keel.CLI.Words.Count (A) = 0);
      Split ("a b c d e f g h i", A);
      Check ("9 words: 8 kept, and Too_Many",
             Keel.CLI.Words.Count (A) = 8 and then Too_Many (A));
      To_Number ("-12", N, OK);
      Check ("""-12"" is -12", OK and then N = -12);
      To_Number ("999999999", N, OK);
      Check ("""999999999"" is 999999999", OK and then N = 999_999_999);
      To_Number ("1000000000", N, OK);
      Check ("""1000000000"" is too long", not OK);
      To_Number ("12a", N, OK);
      Check ("""12a"" is not a number", not OK);
      To_Number ("", N, OK);
      Check (""""" is not a number", not OK);
      To_Number ("-", N, OK);
      Check ("""-"" is not a number", not OK);
   end Splitting;

   ------------------------------------------------------------------
   --  NMEA
   ------------------------------------------------------------------

   procedure Sentences is
      use Keel.NMEA;
      GGA : constant String :=
        "$GPGGA,123519,4807.038,N,01131.000,E,1,08,0.9,545.4,M,"
        & "46.9,M,,*47";
      RMC : constant String :=
        "$GPRMC,123519,A,4807.038,N,01131.000,E,022.4,084.4,230394,"
        & "003.1,W*6A";
      First, Last : Natural;
      Found       : Boolean;
      Bad         : String := GGA;
   begin
      Check ("GGA sentence: valid", Check (GGA) = Valid);
      Check ("RMC sentence: valid", Check (RMC) = Valid);
      Keel.NMEA.Field (GGA, 0, First, Last, Found);
      Check ("GGA field 0 is GPGGA",
             Found and then GGA (First .. Last) = "GPGGA");
      Keel.NMEA.Field (GGA, 9, First, Last, Found);
      Check ("GGA field 9, altitude, is 545.4",
             Found and then GGA (First .. Last) = "545.4");
      Keel.NMEA.Field (GGA, 13, First, Last, Found);
      Check ("GGA field 13 is empty", Found and then Last = First - 1);
      Keel.NMEA.Field (GGA, 15, First, Last, Found);
      Check ("GGA has no field 15", not Found);
      Bad (10) := '6';
      Check ("one digit changed: mismatch", Check (Bad) = Mismatch);
      Check ("no $: no_dollar", Check ("GPGGA,1*00") = No_Dollar);
      Check ("no *: no_star", Check ("$GPGGA,1") = No_Star);
      Check ("*4G: bad_hex", Check ("$GPGGA,1*4G") = Bad_Hex);
      Check ("83 characters: too_long",
             Check ("$" & [1 .. 79 => 'A'] & "*00") = Too_Long);
   end Sentences;

   ------------------------------------------------------------------
   --  AT replies
   ------------------------------------------------------------------

   procedure Replies is
      N     : Natural;
      Found : Boolean;
   begin
      Check ("OK: ok", Classify ("OK", "+CSQ") = Ok);
      Check ("ERROR: error", Classify ("ERROR", "+CSQ") = Error);
      Check ("+CME ERROR: 10: error_code",
             Classify ("+CME ERROR: 10", "+CPIN") = Error_Code);
      Error_Number ("+CME ERROR: 10", N, Found);
      Check ("+CME ERROR: 10: number 10", Found and then N = 10);
      Check ("+CSQ: 21,99 during +CSQ: information",
             Classify ("+CSQ: 21,99", "+CSQ") = Information);
      Check ("+CREG: 1 during +CSQ: unsolicited",
             Classify ("+CREG: 1", "+CSQ") = Unsolicited);
      Check ("AT+CSQ: echo", Classify ("AT+CSQ", "+CSQ") = Echo);
      Check (">: prompt", Classify (">", "+CIPSEND") = Prompt);
      Check (""""": blank", Classify ("", "") = Blank);
      Check ("WIFI GOT IP: text", Classify ("WIFI GOT IP", "") = Text);
      Check ("OK and errors are final, information isn't",
             Is_Final (Ok) and then Is_Final (Error_Code)
             and then not Is_Final (Information));
   end Replies;

   ------------------------------------------------------------------
   --  Log lines and the sink
   ------------------------------------------------------------------

   Room  : Natural := 0;
   Shown : String (1 .. 400);
   Used  : Natural := 0;

   procedure Fake_Write (Text : String) is
   begin
      Shown (Used + 1 .. Used + Text'Length) := Text;
      Used := Used + Text'Length;
      Room := Room - Text'Length;
   end Fake_Write;

   procedure Fake_Read (C : out Character; Got : out Boolean) is
   begin
      C := ' ';
      Got := False;
   end Fake_Read;

   function Fake_Space return Natural is (Room);

   package Fake is new Text_Signature
     (Fake_Write, Fake_Read, Fake_Space);
   package Sink is new Keel.Log.UART_Sink (Fake);

   procedure Logging is
      L : constant String := Line (12_345, Info, "adc 0: 1650 mV");
   begin
      Check ("a log line: " & L (1 .. L'Last - 2),
             L = "[     12.345] INFO  adc 0: 1650 mV" & CR & LF);
      Check ("the last stamp, after 24.8 days, still fits",
             Stamp (Natural'Last) = "[2147483.647]");
      Room := 40;
      Sink.Write (Line (1, Warn, "fits"));
      Sink.Write (Line (2, Warn, "does not fit"));
      Check ("the sink writes a line that fits, drops one that "
             & "doesn't",
             Shown (1 .. Used) = Line (1, Warn, "fits")
             and then Sink.Dropped = 1);
   end Logging;

begin
   Divisors;
   In_Order;
   Two_Tasks;
   Discipline;
   Splitting;
   Sentences;
   Replies;
   Logging;
   if Failures > 0 then
      Put_Line (Failures'Image & " FAILED");
      Ada.Command_Line.Set_Exit_Status (Ada.Command_Line.Failure);
   else
      Put_Line ("all passed");
   end if;
end UART_Host;
