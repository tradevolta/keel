--  SPDX-License-Identifier: Apache-2.0
--  Chapter 16 on the host: the clock dividers for both chips, three
--  devices taking turns on one bus, the ST7789 driver's commands on a
--  model of the controller, the dashboard sent as one frame and as
--  ten strips, and keel_ui's font and clipping. With "--svg FILE" it
--  also writes the frame it sent, in gray, as an SVG for the book.
with Ada.Command_Line;     use Ada.Command_Line;
with Ada.Text_IO;          use Ada.Text_IO;
with Interfaces;           use Interfaces;
with Dashboard;            use Dashboard;
with Dashboard.Painter;
with Host_Clock;
with Keel;                 use Keel;
with Keel.Bus.SPI;         use Keel.Bus.SPI;
with Keel.Bus.SPI.Fake;
with Keel.DMA;
with Keel.DMA.Buffers;
with Keel.Drivers.ST7789;
with Keel.GPIO;            use type Keel.GPIO.Level;
with Keel.GPIO.Fake;
with Keel.GPIO.Output_Signature;
with Keel.UI;              use Keel.UI;
with Keel.UI.Canvas;
with Keel.UI.Fonts;
with Panel_Model;

procedure SPI_Host is
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

   function Image (N : Integer) return String is
     (Image (Long_Long_Integer (N)));

   function Pad (S : String; Width : Positive; Left : Boolean := False)
     return String
   is (if S'Length >= Width then S
       elsif Left then S & [1 .. Width - S'Length => ' ']
       else [1 .. Width - S'Length => ' '] & S);

   --  N in three digits, with leading zeros
   function Three (N : Natural) return String is
     [Character'Val (48 + N / 100 mod 10),
      Character'Val (48 + N / 10 mod 10),
      Character'Val (48 + N mod 10)];

   --  "25.000 MHz", "398.936 kHz"
   function Hz (N : Natural) return String is
     (if N >= 1_000_000
      then Image (N / 1_000_000) & "." & Three (N / 1_000) & " MHz"
      else Image (N / 1_000) & "." & Three (N) & " kHz");

   ------------------------------------------------------------------
   --  Dividers
   ------------------------------------------------------------------

   procedure PL022_Row (Clock : Clock_Hz; Max : Bit_Rate) is
      D     : Prescaled;
      Found : Boolean;
   begin
      Solve_Prescaled (Clock, Max, D, Found);
      Put ("PL022 " & Pad (Image (Clock / 1_000_000), 4) & " MHz"
           & Pad (Hz (Max), 13));
      if Found then
         Put_Line (Pad (Image (D.Prescale) & " x "
                        & Image (D.Serial_Rate + 1), 10)
                   & Pad (Hz (Rate (Clock, Divisor (D))), 13));
      else
         Put_Line ("  out of range");
      end if;
   end PL022_Row;

   procedure G4_Row (Clock : Clock_Hz; Max : Bit_Rate) is
      BR    : Baud_Shift;
      Found : Boolean;
   begin
      Solve_Power_Of_Two (Clock, Max, BR, Found);
      Put ("SPI1  " & Pad (Image (Clock / 1_000_000), 4) & " MHz"
           & Pad (Hz (Max), 13));
      if Found then
         Put_Line (Pad ("/" & Image (Divisor (BR)), 10)
                   & Pad (Hz (Rate (Clock, Divisor (BR))), 13));
      else
         Put_Line ("  out of range");
      end if;
   end G4_Row;

   procedure Dividers is
      Asks : constant array (1 .. 4) of Bit_Rate :=
        [32_000_000, 25_000_000, 7_000_000, 400_000];
   begin
      Put_Line ("chip     clock      at most   divisor         rate");
      for Max of Asks loop
         PL022_Row (150_000_000, Max);
      end loop;
      for Max of Asks loop
         G4_Row (150_000_000, Max);
      end loop;
      for Max of Asks loop
         G4_Row (16_000_000, Max);
      end loop;
      declare
         D     : Prescaled;
         Found : Boolean;
      begin
         Solve_Prescaled (150_000_000, 1_000, D, Found);
         Check ("PL022 at 150 MHz can't go down to 1 kHz", not Found);
      end;
   end Dividers;

   ------------------------------------------------------------------
   --  Three devices on one bus
   ------------------------------------------------------------------

   package Bus renames Keel.Bus.SPI.Fake;

   Panel_Settings_Here : constant Settings :=
     (Mode => 0, Max_Rate => 32_000_000);

   TFT  : Bus.Device (CS => 13);
   Card : Bus.Device (CS => 22);
   IMU  : Bus.Device (CS => 17);

   procedure Arbitration is
      Stat : Status;
      Data : Byte_Array (1 .. 2) := [16#80#, 0];

      procedure Turn (D : in out Bus.Device; Name : String) is
         Before : constant Natural := Bus.Statistics.Reconfigurations;
      begin
         Bus.Acquire (D, Stat);
         Bus.Write (D, [16#00#]);
         Bus.Release (D);
         Put_Line (Pad (Name, 8, Left => True)
                   & Pad (Hz (Bus.Rate_Of (D)), 12)
                   & (if Bus.Statistics.Reconfigurations > Before
                      then "  set up again" else "  as it was"));
      end Turn;
   begin
      Bus.Attach (TFT, Panel_Settings_Here, Stat);
      Bus.Attach (Card, (Mode => 0, Max_Rate => 25_000_000), Stat);
      Bus.Attach (IMU, (Mode => 3, Max_Rate => 7_000_000), Stat);
      Turn (TFT, "display");
      Turn (TFT, "display");
      Turn (Card, "card");
      Turn (IMU, "imu");
      Turn (IMU, "imu");
      Turn (TFT, "display");

      Bus.Acquire (TFT, Stat);
      Bus.Acquire (Card, Stat);
      Check ("the card can't take the bus while the display holds it",
             Stat = In_Use);
      Check ("and its chip select stays high",
             Keel.GPIO.Fake.Lamp (22) = Keel.GPIO.High);
      Bus.Release (TFT);
      Bus.Acquire (IMU, Stat);
      Bus.Exchange (IMU, Data);
      Bus.Release (IMU);
      Check ("released, the bus goes to the next to ask", Stat = Ok);
      Put_Line ("reconfigurations:"
                & Bus.Statistics.Reconfigurations'Image
                & " in" & Bus.Statistics.Acquisitions'Image
                & " acquisitions");
   end Arbitration;

   ------------------------------------------------------------------
   --  The ST7789 driver on the model
   ------------------------------------------------------------------

   DC_Id  : constant := 9;
   RST_Id : constant := 8;

   package Link is new Device_Signature
     (Bus.Device, Bus.Acquire, Bus.Release, Bus.Write, Bus.Exchange,
      Bus.Start_Stream, Bus.Finish_Stream);
   package Pins is new Keel.GPIO.Output_Signature
     (Keel.GPIO.Fake.Output_Pin, Keel.GPIO.Fake.Set);
   package ST7789 is new Keel.Drivers.ST7789
     (Link, Pins, Host_Clock.Fits);

   Panel : ST7789.Panel;
   DC    : Keel.GPIO.Fake.Output_Pin (DC_Id);
   RST   : Keel.GPIO.Fake.Output_Pin (RST_Id);

   package Frame_Pixels is new Keel.DMA.Buffers (Color, 240 * 240);
   package Frames is new Keel.UI.Canvas (240, Frame_Pixels);
   package Paint_Frame is new Dashboard.Painter (Frames);

   package Strip_Pixels is new Keel.DMA.Buffers (Color, 240 * 24);
   package Strips is new Keel.UI.Canvas (240, Strip_Pixels);
   package Paint_Strip is new Dashboard.Painter (Strips);

   use type Strip_Pixels.Holder;

   Frame : Frames.Canvas;
   Strip : array (0 .. 1) of Strips.Canvas;

   --  The readings the figure shows: set here, not measured
   function Sample return Readings is
      R : Readings;
   begin
      R.Seconds := 10 * 3_600 + 42 * 60 + 7;
      R.Has_Temp := True;
      R.Centi_C := 2_741;
      R.Source := Light;
      for I in 1 .. History_Length loop
         Record_Reading
           (R, 300 + 330 * I / History_Length
               + (if I mod 6 < 3 then 40 else 0));
      end loop;
      R.Needle := R.Reading;
      return R;
   end Sample;

   Snapshot : array (0 .. 239, 0 .. 239) of Unsigned_16;

   procedure Driver is
      Stat : Status;
      R    : constant Readings := Sample;
      Area : Keel.DMA.Region;
      Done : Keel.DMA.Receipt;
      Same : Boolean := True;
      Bits_Before : Long_Long_Integer;
      Busy_Before : Long_Long_Integer;
   begin
      Keel.GPIO.Fake.Claim (DC, (Initial => Keel.GPIO.High,
                                 others => <>), Stat);
      Keel.GPIO.Fake.Claim (RST, (Initial => Keel.GPIO.High,
                                  others => <>), Stat);
      Panel_Model.Connect (Bus.Number_Of (TFT), DC_Id);
      Bus.Listen (Panel_Model.Hear'Access);

      Host_Clock.Reset;
      ST7789.Reset (RST);
      Put_Line ("reset: RST low and high again, then"
                & Host_Clock.Waited'Image & " us of waiting");
      Host_Clock.Reset;
      Panel_Model.Clear_Log;
      ST7789.Initialize (Panel, TFT, DC, 0, Stat);
      Put (Panel_Model.Log);
      Put_Line ("initialize: " & Stat'Image & ","
                & Host_Clock.Waited'Image & " us of pauses");

      --  The whole frame, by the DMA
      Paint_Frame.Paint (Frame, R);
      Panel_Model.Clear_Log;
      Bits_Before := Bus.Statistics.Bits;
      Busy_Before := Bus.Statistics.Busy_ns;
      Frame_Pixels.Lend (Frame.Store, Area);
      ST7789.Start_Window (Panel, TFT, DC, (others => <>), Area, Stat);
      ST7789.Finish_Window (Panel, TFT, Done);
      Frame_Pixels.Reclaim (Frame.Store, Done);
      Put (Panel_Model.Log);
      Put_Line ("one frame: "
                & Image (Bus.Statistics.Bits - Bits_Before) & " bits, "
                & Image ((Bus.Statistics.Busy_ns - Busy_Before) / 1_000)
                & " us at " & Hz (Bus.Rate_Of (TFT)) & " (computed)");
      Check ("57 600 pixels written, none outside the panel's rows",
             Panel_Model.Pixels_Written = 57_600
             and then Panel_Model.Hidden = 0
             and then Panel_Model.Outside = 0);
      for Y in 0 .. 239 loop
         for X in 0 .. 239 loop
            Snapshot (X, Y) := Panel_Model.View
              (X, Y, ST7789.Column_Offset (0), ST7789.Row_Offset (0));
            Same := Same and then Snapshot (X, Y) =
              Unsigned_16 (Frame_Pixels.Get (Frame.Store, Y * 240 + X));
         end loop;
      end loop;
      Check ("the panel holds the frame as drawn", Same);

      --  Ten strips of 24 rows, two buffers taking turns
      ST7789.Fill (Panel, TFT, DC, (others => <>), 0, Stat);
      Check ("Fill: the panel black", Panel_Model.View (17, 33,
             ST7789.Column_Offset (0), ST7789.Row_Offset (0)) = 0);
      for K in 0 .. 9 loop
         declare
            B : Strips.Canvas renames Strip (K mod 2);
         begin
            if Strip_Pixels.Owner (B.Store) = Strip_Pixels.Engine then
               ST7789.Finish_Window (Panel, TFT, Done);
               Strip_Pixels.Reclaim (B.Store, Done);
            end if;
            Strips.Move_To (B, 0, K * 24);
            Paint_Strip.Paint (B, R);
            if ST7789.Streaming (Panel) then
               ST7789.Finish_Window (Panel, TFT, Done);
               Strip_Pixels.Reclaim (Strip (1 - K mod 2).Store, Done);
            end if;
            Strip_Pixels.Lend (B.Store, Area);
            ST7789.Start_Window
              (Panel, TFT, DC, (X => 0, Y => K * 24, Across => 240,
                                Down => 24), Area, Stat);
         end;
      end loop;
      ST7789.Finish_Window (Panel, TFT, Done);
      Strip_Pixels.Reclaim (Strip (1).Store, Done);
      Same := True;
      for Y in 0 .. 239 loop
         for X in 0 .. 239 loop
            Same := Same and then Snapshot (X, Y) = Panel_Model.View
              (X, Y, ST7789.Column_Offset (0), ST7789.Row_Offset (0));
         end loop;
      end loop;
      Check ("ten strips of 24 rows give the same pixels", Same);
   end Driver;

   ------------------------------------------------------------------
   --  keel_ui: a glyph and clipping
   ------------------------------------------------------------------

   procedure Font_And_Clipping is
      G : constant Keel.UI.Fonts.Glyph := Keel.UI.Fonts.Glyph_Of ('K');
      Ink : constant Color := White;
   begin
      for Row in Keel.UI.Fonts.Glyph_Index loop
         declare
            Line : String (1 .. 8);
         begin
            for Col in Keel.UI.Fonts.Glyph_Index loop
               Line (Col + 1) :=
                 (if Keel.UI.Fonts.Is_Set (G, Row, Col) then '#'
                  else '.');
            end loop;
            Put_Line ("  " & Line);
         end;
      end loop;
      Strips.Move_To (Strip (0), 0, 100);
      Strips.Clear (Strip (0), Black);
      Strips.Line (Strip (0), -30_000, 90, 30_000, 140, Ink, 5);
      Strips.Text (Strip (0), 200, 95, "clipped", Ink, 4);
      Strips.Disc (Strip (0), 0, 0, 2_000, Ink);
      Check ("a line, text and a disc far off a strip's edges",
             Strip_Pixels.Get (Strip (0).Store, 0) = Ink);
      Check ("RGB (200, 64, 26) is 16#CA03#, the rust",
             RGB (16#C8#, 16#40#, 16#1A#) = Rust);
   end Font_And_Clipping;

   ------------------------------------------------------------------
   --  The figure
   ------------------------------------------------------------------

   --  Each pixel as gray, (R*299 + G*587 + B*114) / 1000; runs of
   --  one gray in a row are one rectangle
   procedure Write_SVG (Name : String) is
      F : File_Type;

      function Gray (C : Unsigned_16) return Natural is
         R : constant Natural :=
           Natural (Shift_Right (C, 11)) * 255 / 31;
         G : constant Natural :=
           Natural (Shift_Right (C, 5) and 63) * 255 / 63;
         B : constant Natural := Natural (C and 31) * 255 / 31;
      begin
         return (R * 299 + G * 587 + B * 114) / 1_000;
      end Gray;

      function Hex (N : Natural) return String is
         D : constant String := "0123456789abcdef";
      begin
         return [D (N / 16 + 1), D (N mod 16 + 1)];
      end Hex;
   begin
      Create (F, Out_File, Name);
      Put_Line (F, "<?xml version=""1.0"" encoding=""UTF-8""?>");
      Put_Line (F, "<svg xmlns=""http://www.w3.org/2000/svg"" "
                & "viewBox=""0 0 240 240"" width=""480"" height=""480"""
                & " shape-rendering=""crispEdges"" role=""img"""
                & " aria-labelledby=""t d"">");
      Put_Line (F, "<title id=""t"">The pocket dashboard as the panel "
                & "model received it, in gray</title>");
      Put_Line (F, "<desc id=""d"">The 240 by 240 pixels spi_host "
                & "sent to its model of the ST7789, one rectangle "
                & "per run of "
                & "one gray in a row, from the sample readings in "
                & "spi_host.adb: the time 10:42:07, the light gauge at "
                & "67%, 27.4 C, a history of 48 readings and no frame "
                & "rate yet.</desc>");
      for Y in 0 .. 239 loop
         declare
            X : Natural := 0;
         begin
            while X < 240 loop
               declare
                  V   : constant Natural := Gray (Snapshot (X, Y));
                  Run : Natural := 1;
               begin
                  while X + Run < 240
                    and then Gray (Snapshot (X + Run, Y)) = V
                  loop
                     Run := Run + 1;
                  end loop;
                  Put_Line (F, "<rect x=""" & Image (X) & """ y="""
                            & Image (Y) & """ width=""" & Image (Run)
                            & """ height=""1"" fill=""#" & Hex (V)
                            & Hex (V) & Hex (V) & """/>");
                  X := X + Run;
               end;
            end loop;
         end;
      end loop;
      Put_Line (F, "</svg>");
      Close (F);
   end Write_SVG;
begin
   Dividers;
   Arbitration;
   Driver;
   Font_And_Clipping;
   if Argument_Count = 2 and then Argument (1) = "--svg" then
      Write_SVG (Argument (2));
   end if;
   if Failures > 0 then
      Put_Line (Failures'Image & " FAILED");
      Set_Exit_Status (Failure);
   end if;
end SPI_Host;
