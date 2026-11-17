--  SPDX-License-Identifier: Apache-2.0
--  The display on the NUCLEO-G474RE: the same Adafruit board on SPI1
--  through the Arduino header (UM2505, 8.3). Vin to 3V3 (CN6 pin 4)
--  and GND to GND; SCK to D13 (PA5), SI to D11 (PA7), SO to D12
--  (PA6), TCS to D10 (PB6), RST to D9 (PC7) and D/C to D8 (PA9).
--  Two whole frames would take 230 400 bytes; the G474 has 128 KB
--  of SRAM. So the dashboard goes out in ten strips of 24 rows, from
--  two strip buffers of 11 520 bytes: the program draws the next
--  strip while the DMA sends the last one. Every strip draws the
--  whole scene, clipped, which costs drawing time, not memory.
with Keel.Bus.SPI;          use Keel.Bus.SPI;
with Keel.Bus.SPI.STM32G4;
with Keel.DMA;
with Keel.DMA.Buffers;
with Keel.DMA.STM32G4;
with Keel.Drivers.ST7789;
with Keel.GPIO;             use Keel.GPIO;
with Keel.GPIO.Output_Signature;
with Keel.GPIO.STM32G4;     use Keel.GPIO.STM32G4;
with Keel.Time;             use Keel.Time;
with Keel.Time.Bare;
with Keel.UI;               use Keel.UI;
with Keel.UI.Canvas;
with Dashboard.Painter;

package body Display is
   package SPI renames Keel.Bus.SPI.STM32G4;

   TFT : SPI.Device (SPI.SPI1, CS_Port => B, CS_Pin => 6);
   DC  : Output_Pin (A, 9);
   RST : Output_Pin (C, 7);

   package Link is new Device_Signature
     (SPI.Device, SPI.Acquire, SPI.Release, SPI.Write, SPI.Exchange,
      SPI.Start_Stream, SPI.Finish_Stream);
   package Pins is new Keel.GPIO.Output_Signature (Output_Pin, Set);
   package Timer is new Keel.Time.Clock_Signature
     (Keel.Time.Bare.Clock, Keel.Time.Bare.Wait_Until);
   package ST7789 is new Keel.Drivers.ST7789 (Link, Pins, Timer);

   Strip_Rows : constant := 24;
   package Pixels is new Keel.DMA.Buffers (Color, 240 * Strip_Rows);
   package Strips is new Keel.UI.Canvas (240, Pixels);
   package Paint is new Dashboard.Painter (Strips);

   Panel  : ST7789.Panel;
   Strip  : array (0 .. 1) of Strips.Canvas;
   Ready  : Boolean := False;
   Stats  : Timing;
   Before : Keel.Time.Time := 0;

   function Is_Ready return Boolean is (Ready);
   function Last return Timing is (Stats);
   function Reconfigurations return Natural is
     (SPI.Reconfigurations (SPI.SPI1));

   function Name return String is
     (if not SPI.Is_Attached (TFT) then "ST7789, not started"
      else "ST7789 240x240 on SPI1, "
           & Dashboard.MHz_Image (SPI.Rate_Of (TFT))
           & ", ten strips by DMA");

   procedure Initialize (Stat : out Status) is
   begin
      if not Keel.DMA.STM32G4.Is_Enabled then
         Keel.DMA.STM32G4.Enable;
      end if;
      SPI.Open (SPI.SPI1, Stat);
      if Stat = Ok then
         SPI.Attach (TFT, ST7789.Panel_Settings, Stat);
      end if;
      if Stat = Ok then
         Claim (DC, (Initial => High, others => <>), Stat);
      end if;
      if Stat = Ok then
         Claim (RST, (Initial => High, others => <>), Stat);
      end if;
      if Stat /= Ok then
         return;
      end if;
      ST7789.Reset (RST);
      ST7789.Initialize (Panel, TFT, DC, 0, Stat);
      Ready := Stat = Ok;
      Before := Keel.Time.Bare.Clock;
   end Initialize;

   function Micros (From, To : Keel.Time.Time) return Natural is
     (Natural (Time_Span'Min (To - From, Time_Span (Natural'Last))));

   --  Strip K into buffer K mod 2; while it is drawn, the DMA sends
   --  strip K - 1 from the other buffer
   procedure Show (R : Dashboard.Readings) is
      Start : constant Keel.Time.Time := Keel.Time.Bare.Clock;
      Draw  : Natural := 0;
      Wait  : Natural := 0;
      T     : Keel.Time.Time;
      Area  : Keel.DMA.Region;
      Done  : Keel.DMA.Receipt;
      Stat  : Status;
   begin
      for K in Natural range 0 .. 240 / Strip_Rows - 1 loop
         declare
            B : Strips.Canvas renames Strip (K mod 2);
         begin
            T := Keel.Time.Bare.Clock;
            Strips.Move_To (B, 0, K * Strip_Rows);
            Paint.Paint (B, R);
            Draw := Draw + Micros (T, Keel.Time.Bare.Clock);

            T := Keel.Time.Bare.Clock;
            if ST7789.Streaming (Panel) then
               ST7789.Finish_Window (Panel, TFT, Done);
               Pixels.Reclaim (Strip ((K + 1) mod 2).Store, Done);
            end if;
            Wait := Wait + Micros (T, Keel.Time.Bare.Clock);

            Pixels.Lend (B.Store, Area);
            ST7789.Start_Window
              (Panel, TFT, DC,
               (X => 0, Y => K * Strip_Rows, Across => 240,
                Down => Strip_Rows),
               Area, Stat);
            if Stat /= Ok then
               Ready := False;
               return;
            end if;
         end;
      end loop;
      --  The last strip goes on sending while the next frame's first
      --  strip is drawn; it comes back at the second strip
      Stats :=
        (Frames    => Stats.Frames + 1,
         Draw_Us   => Draw,
         Wait_Us   => Wait,
         Period_Us => Micros (Before, Start));
      Before := Start;
   end Show;
end Display;
