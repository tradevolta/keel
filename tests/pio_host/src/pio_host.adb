--  SPDX-License-Identifier: Apache-2.0
--  Chapter 13 on the host: the assembler's words against pioasm's
--  (pioasm/*.pio, assembled by Adafruit's adafruit_pioasm 1.3.8),
--  relocation and dividers, CRC-8, the ROM search and a DS18B20 read
--  on the fake bus, the datasheet's temperature table, WS2812 bits,
--  and the thermo-strip's colours.
with Ada.Text_IO;      use Ada.Text_IO;
with Ada.Command_Line;
with Keel.PIO;         use Keel.PIO;
with Keel.PIO.WS2812_Program;
with Keel.PIO.OneWire_Program;
with Keel.OneWire;     use Keel.OneWire;
with Keel.OneWire.Fake;
with Keel.OneWire.Protocol;
with Keel.Drivers.DS18B20;
with Keel.Drivers.WS2812; use Keel.Drivers.WS2812;
with Keel.Units;       use Keel.Units;
with Thermo;
with Sim_PIO;          use Sim_PIO;

procedure PIO_Host is
   Failures : Natural := 0;

   procedure Check (Name : String; OK : Boolean) is
   begin
      Put_Line ((if OK then "ok:   " else "FAIL: ") & Name);
      if not OK then
         Failures := Failures + 1;
      end if;
   end Check;

   Hex_Digits : constant String := "0123456789ABCDEF";

   function Hex (V : Natural; Width : Positive) return String is
      S : String (1 .. Width);
      N : Natural := V;
   begin
      for I in reverse S'Range loop
         S (I) := Hex_Digits (N mod 16 + 1);
         N := N / 16;
      end loop;
      return S;
   end Hex;

   function Same (P : Program; Words : Instruction_Array)
     return Boolean is
   begin
      for I in P.Code'Range loop
         if P.Code (I) /= Words (I) then
            Put_Line ("  slot" & I'Image & ": "
                      & Hex (Natural (P.Code (I)), 4) & ", pioasm "
                      & Hex (Natural (Words (I)), 4));
            return False;
         end if;
      end loop;
      return P.Last = Words'Last;
   end Same;

   procedure Put_Program (Name : String; P : Program) is
   begin
      Put (Name & ":");
      for I of P.Code loop
         Put (" " & Hex (Natural (I), 4));
      end loop;
      New_Line;
   end Put_Program;

   --  From pioasm, for pioasm/ws2812.pio and pioasm/onewire.pio
   WS2812_Words : constant Instruction_Array :=
     [16#6321#, 16#1223#, 16#1200#, 16#A242#];
   OneWire_Words : constant Instruction_Array :=
     [16#6021#, 16#E481#, 16#0026#, 16#E880#, 16#5F01#, 16#1500#,
      16#5F61#, 16#B542#, 16#E880#, 16#E081#, 16#E03D#, 16#0F4B#,
      16#FF80#, 16#BF42#, 16#A542#, 16#4001#, 16#E038#, 16#0F51#,
      16#0700#];

   package Bus_Of is new Bus_Signature
     (Keel.OneWire.Fake.Bus, Keel.OneWire.Fake.Reset,
      Keel.OneWire.Fake.Touch);
   package Protocol is new Keel.OneWire.Protocol (Bus_Of);
   package Sensor is new Keel.Drivers.DS18B20 (Bus_Of);
   use type Sensor.Raw_Temperature;

   function ROM_Image (R : ROM_Code) return String is
      S : String (1 .. 23);
   begin
      for I in R'Range loop
         S (I * 3 - 2 .. I * 3 - 1) := Hex (Natural (R (I)), 2);
         if I < 8 then
            S (I * 3) := ' ';
         end if;
      end loop;
      return S (1 .. 23);
   end ROM_Image;

   function With_CRC (R : Byte_Array) return ROM_Code is
     (R & CRC8 (R));
begin
   --  The assembler, against pioasm
   Put_Program ("ws2812 ", Keel.PIO.WS2812_Program.Code);
   Check ("ws2812: 4 words, as pioasm",
          Same (Keel.PIO.WS2812_Program.Code, WS2812_Words));
   Put_Program ("onewire", Keel.PIO.OneWire_Program.Code);
   Check ("onewire: 19 words, as pioasm",
          Same (Keel.PIO.OneWire_Program.Code, OneWire_Words));
   Check ("both programs well formed",
          Well_Formed (Keel.PIO.WS2812_Program.Code)
          and then Well_Formed (Keel.PIO.OneWire_Program.Code));
   Put_Line ("  one block: 4 + 19 ="
             & Natural'(Natural (Keel.PIO.WS2812_Program.Code.Last) + 1
                        + Natural (Keel.PIO.OneWire_Program.Code.Last)
                        + 1)'Image & " of 32 slots");

   --  Relocation: the 1-Wire program after the WS2812 one, at 4
   Check ("jmp !x 6 at offset 4: 002A",
          Relocated (16#0026#, 4) = 16#002A#);
   Check ("jmp x-- 17 [15] at offset 4: 0F55",
          Relocated (16#0F51#, 4) = 16#0F55#);
   Check ("set pindirs, 1 [4] stays E481",
          Relocated (16#E481#, 4) = 16#E481#);

   --  The programs' timing, from their own words, simulated cycle
   --  by cycle (Sim_PIO). 1-Wire: a cycle is 1 us.
   declare
      OW : Program renames Keel.PIO.OneWire_Program.Code;

      function At_Kind
        (E : Event_Array; K : Event_Kind; N : Positive := 1)
        return Natural
      is
         Seen : Natural := 0;
      begin
         for V of E loop
            if V.Kind = K then
               Seen := Seen + 1;
               if Seen = N then
                  return V.Cycle;
               end if;
            end if;
         end loop;
         return 0;
      end At_Kind;

      function Sampled (E : Event_Array) return Boolean is
      begin
         for V of E loop
            if V.Kind = Sample then
               return V.Value;
            end if;
         end loop;
         return False;
      end Sampled;

      One  : constant Event_Array :=
        Run (OW, 0, [1], 1, True, []);
      Fall : constant Natural := At_Kind (One, Pin_Low);
      Zero : constant Event_Array :=
        Run (OW, 0, [0], 1, True, []);
      Read : constant Event_Array :=
        Run (OW, 0, [1], 1, True, [(Fall, Fall + 30)]);
      Rst  : constant Event_Array :=
        Run (OW, Keel.PIO.OneWire_Program.Reset, [], 1, True,
             [(482 + 30, 482 + 150)]);
      Gone : constant Natural := At_Kind (Rst, Pin_High);
   begin
      Put_Line ("  write 1: low" & Natural'Image
                  (At_Kind (One, Pin_High) - Fall)
                & " us, sample at" & Natural'Image
                  (At_Kind (One, Sample) - Fall)
                & " us, slot" & Natural'Image
                  (At_Kind (One, Stall) + 1 - Fall) & " us");
      Check ("write 1: low 6 us, sample at 15, slot 70",
             At_Kind (One, Pin_High) - Fall = 6
             and then At_Kind (One, Sample) - Fall = 15
             and then At_Kind (One, Stall) + 1 - Fall = 70);
      Put_Line ("  write 0: low" & Natural'Image
                  (At_Kind (Zero, Pin_High) - Fall)
                & " us, slot" & Natural'Image
                  (At_Kind (Zero, Stall) + 1 - Fall) & " us");
      Check ("write 0: low 60 us, slot 70",
             At_Kind (Zero, Pin_High) - Fall = 60
             and then At_Kind (Zero, Stall) + 1 - Fall = 70);
      Check ("a 1 written, a device holding the line: reads 0",
             not Sampled (Read) and then Sampled (One));
      Put_Line ("  reset: low" & Gone'Image & " us, sample"
                & Natural'Image (At_Kind (Rst, Sample) - Gone)
                & " us after, then" & Natural'Image
                  (At_Kind (Rst, Stall) - At_Kind (Rst, Sample))
                & " us; total" & At_Kind (Rst, Stall)'Image & " us");
      Check ("reset: low 482 us, sample 70 us after, 410 more",
             Gone = 482
             and then At_Kind (Rst, Sample) - Gone = 70
             and then At_Kind (Rst, Stall) - At_Kind (Rst, Sample)
                      = 410);
      Check ("presence: the sample reads the device's low",
             not Sampled (Rst));
   end;

   --  WS2812 at 8 MHz: a cycle is 125 ns. One pixel, a 1 then 0s.
   declare
      E : constant Event_Array :=
        Run (Keel.PIO.WS2812_Program.Code, 0, [16#8000_0000#], 24,
             False, []);
      High_1 : constant Natural := E (2).Cycle - E (1).Cycle;
      Bit    : constant Natural := E (3).Cycle - E (1).Cycle;
      High_0 : constant Natural := E (4).Cycle - E (3).Cycle;
   begin
      Put_Line ("  ws2812: a 1 high" & Natural'Image (High_1 * 125)
                & " ns, a 0 high" & Natural'Image (High_0 * 125)
                & " ns, a bit" & Natural'Image (Bit * 125) & " ns");
      Check ("ws2812: 1 high 750 ns, 0 high 375 ns, bit 1250 ns",
             E (1).Kind = Pin_High and then High_1 = 6
             and then High_0 = 3 and then Bit = 10);
   end;

   --  Dividers at 150 MHz
   declare
      D8 : constant Divider := Divider_For (150_000_000, 8_000_000);
      D1 : constant Divider := Divider_For (150_000_000, 1_000_000);
   begin
      Check ("8 MHz from 150 MHz: 18 + 192/256 (18.75)",
             D8.Int = 18 and then D8.Frac = 192);
      Check ("1 MHz from 150 MHz: 150 + 0/256",
             D1.Int = 150 and then D1.Frac = 0);
   end;

   --  CRC-8/MAXIM's check value
   Check ("CRC8 (""123456789"") = A1",
          CRC8 ([16#31#, 16#32#, 16#33#, 16#34#, 16#35#, 16#36#,
                 16#37#, 16#38#, 16#39#]) = 16#A1#);
   Check ("CRC8 of a code and its CRC = 0",
          CRC8 (With_CRC ([16#28#, 16#FF#, 16#4C#, 16#1A#, 16#33#,
                           16#16#, 16#04#])) = 0);

   --  The search, on a fake bus with three devices
   declare
      Bus   : Keel.OneWire.Fake.Bus;
      A     : constant ROM_Code :=
        With_CRC ([16#28#, 16#AA#, 16#0F#, 16#73#, 16#05#, 16#00#,
                   16#00#]);
      B     : constant ROM_Code :=
        With_CRC ([16#28#, 16#61#, 16#64#, 16#12#, 16#3C#, 16#7E#,
                   16#00#]);
      C     : constant ROM_Code :=
        With_CRC ([16#28#, 16#AA#, 16#0F#, 16#73#, 16#05#, 16#00#,
                   16#80#]);
      State : Protocol.Search_State := Protocol.Fresh_Search;
      ROM   : ROM_Code;
      Found : Boolean;
      Stat  : Status;
      Seen  : Natural := 0;
      Raw   : Sensor.Raw_Temperature;
      Mask  : Natural := 0;
   begin
      Keel.OneWire.Fake.Attach (Bus, A, 16#0191#);
      Keel.OneWire.Fake.Attach (Bus, B, -162);
      Keel.OneWire.Fake.Attach (Bus, C, 16#0008#);
      loop
         Protocol.Next (Bus, State, ROM, Found, Stat);
         exit when not Found;
         Seen := Seen + 1;
         Put_Line ("  found " & ROM_Image (ROM));
         Mask := Mask + (if ROM = A then 1 elsif ROM = B then 2
                         elsif ROM = C then 4 else 8);
      end loop;
      Check ("search finds all 3 codes, once each",
             Seen = 3 and then Mask = 7 and then Stat = Ok);
      Put_Line ("  slots:" & Keel.OneWire.Fake.Slots (Bus)'Image
                & ", resets:" & Keel.OneWire.Fake.Resets (Bus)'Image);

      --  Before a conversion: the power-on +85
      Sensor.Read (Bus, A, Raw, Stat);
      Check ("before Convert T: 0550 (+85 C)",
             Stat = Ok and then Raw = Sensor.Power_On_Value);
      Sensor.Start_Conversion (Bus, Stat);
      Check ("Convert T to all (Skip ROM)", Stat = Ok);
      Sensor.Read (Bus, A, Raw, Stat);
      Check ("A: 0191 = 25.06 C", Stat = Ok and then Raw = 16#0191#
             and then Sensor.To_Celsius (Raw) = 25.06);
      Sensor.Read (Bus, B, Raw, Stat);
      Check ("B: FF5E = -10.13 C", Stat = Ok and then Raw = -162
             and then Sensor.To_Celsius (Raw) = -10.13);
      Keel.OneWire.Fake.Corrupt_Next_Byte (Bus);
      Sensor.Read (Bus, C, Raw, Stat);
      Check ("a damaged byte: CRC_Error", Stat = CRC_Error);
      Sensor.Read (Bus, C, Raw, Stat);
      Check ("C again: 0008 = 0.50 C", Stat = Ok and then Raw = 8);
   end;

   declare
      Empty : Keel.OneWire.Fake.Bus;
      Stat  : Status;
      Raw   : Sensor.Raw_Temperature;
   begin
      Sensor.Read (Empty, [others => 0], Raw, Stat);
      Check ("no device: No_Device", Stat = No_Device);
   end;

   --  The datasheet's temperature table (Table 1)
   declare
      type Row is record
         Raw : Sensor.Rated;
         T   : Celsius;
      end record;
      Table : constant array (1 .. 10) of Row :=
        [(16#07D0#, 125.0), (16#0550#, 85.0), (16#0191#, 25.06),
         (16#00A2#, 10.13), (16#0008#, 0.5), (0, 0.0),
         (-16#0008#, -0.5), (-16#00A2#, -10.13), (-16#0191#, -25.06),
         (-16#0370#, -55.0)];
      OK : Boolean := True;
   begin
      for R of Table loop
         Put_Line ("  " & Hex (Integer (R.Raw) mod 2**16, 4) & "  "
                   & Sensor.To_Celsius (R.Raw)'Image);
         OK := OK and then Sensor.To_Celsius (R.Raw) = R.T;
      end loop;
      Check ("datasheet table, to the hundredth", OK);
   end;

   --  WS2812
   Check ("GRB of (R 10, G 20, B 30) = 140A1E",
          GRB ((Red => 16#0A#, Green => 16#14#, Blue => 16#1E#))
          = 16#140A1E#);
   Check ("Dimmed (255, 128, 1) at 32 = (32, 16, 0)",
          Dimmed ((255, 128, 1), 32) = (32, 16, 0));
   Check ("Blend black to white, 3 of 7 = 109",
          Blend (Black, (255, 255, 255), 3, 7) = (109, 109, 109));

   --  The thermo-strip
   declare
      procedure Show (A, B : Celsius) is
         S : constant Thermo.Strip_Colours := Thermo.Strip_For (A, B);
      begin
         Put ("  " & A'Image & B'Image & ":");
         for C of S loop
            Put (" " & Hex (Natural (GRB (C)), 6));
         end loop;
         New_Line;
      end Show;
   begin
      Check ("15 C blue, 25 C green, 35 C red",
             Thermo.Colour_For (15.0) = Thermo.Blue
             and then Thermo.Colour_For (25.0) = Thermo.Green
             and then Thermo.Colour_For (35.0) = Thermo.Red);
      Check ("20 C half way: (0, 127, 128)",
             Thermo.Colour_For (20.0) = (0, 127, 128));
      Put_Line ("  strip (GRB, LED 1 to 8):");
      Show (21.5, 21.5);
      Show (19.0, 31.0);
      Show (5.0, 40.0);
   end;

   if Failures = 0 then
      Put_Line ("all PIO host tests passed");
   else
      Put_Line (Failures'Image & " PIO host test(s) failed");
      Ada.Command_Line.Set_Exit_Status (Ada.Command_Line.Failure);
   end if;
end PIO_Host;
