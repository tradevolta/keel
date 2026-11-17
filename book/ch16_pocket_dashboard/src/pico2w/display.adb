--  SPDX-License-Identifier: Apache-2.0
--  The display on the Pico 2 W: Adafruit's 1.3-inch 240 x 240 ST7789
--  board on SPI1. Its 3-5V pin goes to 3V3(OUT) (pin 36) and Gnd
--  to pin 13; SCK to GP10 (pin 14), SI to GP11 (pin 15, SPI1 TX),
--  TCS to GP13 (pin 17), D/C to GP9 (pin 12) and RST to GP8 (pin
--  11). GP12 (pin 16, SPI1 RX) goes to SO, for the microSD card on
--  the same board in Chapter 23; CCS, 3V3 and Lite stay unconnected,
--  and the backlight on. Two frames of 240 x 240 RGB565, 115 200
--  bytes each, take turns: the program draws one while the DMA sends
--  the other.
with Keel.Bus.SPI;          use Keel.Bus.SPI;
with Keel.Bus.SPI.RP2350;
with Keel.DMA;
with Keel.DMA.Buffers;
with Keel.Drivers.ST7789;
with Keel.GPIO;             use Keel.GPIO;
with Keel.GPIO.Output_Signature;
with Keel.GPIO.RP2350;      use Keel.GPIO.RP2350;
with Keel.Time;             use Keel.Time;
with Keel.Time.Bare;
with Keel.UI;               use Keel.UI;
with Keel.UI.Canvas;
with Dashboard.Painter;

package body Display is
   package SPI renames Keel.Bus.SPI.RP2350;

   TFT : SPI.Device (SPI.SPI1, CS => 13);
   DC  : Output_Pin (9);
   RST : Output_Pin (8);

   package Link is new Device_Signature
     (SPI.Device, SPI.Acquire, SPI.Release, SPI.Write, SPI.Exchange,
      SPI.Start_Stream, SPI.Finish_Stream);
   package Pins is new Keel.GPIO.Output_Signature (Output_Pin, Set);
   package Timer is new Keel.Time.Clock_Signature
     (Keel.Time.Bare.Clock, Keel.Time.Bare.Wait_Until);
   package ST7789 is new Keel.Drivers.ST7789 (Link, Pins, Timer);

   package Pixels is new Keel.DMA.Buffers (Color, 240 * 240);
   package Frames is new Keel.UI.Canvas (240, Pixels);
   package Paint is new Dashboard.Painter (Frames);

   Panel  : ST7789.Panel;
   Frame  : array (0 .. 1) of Frames.Canvas;
   Next   : Natural range 0 .. 1 := 0;
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
           & ", two frames by DMA");

   procedure Initialize (Stat : out Status) is
   begin
      SPI.Open (SPI.SPI1, SCK => 10, TX => 11, RX => 12, Stat => Stat);
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

   procedure Show (R : Dashboard.Readings) is
      Other   : constant Natural := 1 - Next;
      Start   : constant Keel.Time.Time := Keel.Time.Bare.Clock;
      Drawn   : Keel.Time.Time;
      Area    : Keel.DMA.Region;
      Done    : Keel.DMA.Receipt;
      Stat    : Status;
   begin
      --  Draw into the frame the program holds ...
      Paint.Paint (Frame (Next), R);
      Drawn := Keel.Time.Bare.Clock;

      --  ... wait for the other to finish sending, and take it back
      if ST7789.Streaming (Panel) then
         ST7789.Finish_Window (Panel, TFT, Done);
         Pixels.Reclaim (Frame (Other).Store, Done);
      end if;

      --  ... and send the new one while the next is drawn
      Stats :=
        (Frames    => Stats.Frames + 1,
         Draw_Us   => Micros (Start, Drawn),
         Wait_Us   => Micros (Drawn, Keel.Time.Bare.Clock),
         Period_Us => Micros (Before, Keel.Time.Bare.Clock));
      Before := Keel.Time.Bare.Clock;
      Pixels.Lend (Frame (Next).Store, Area);
      ST7789.Start_Window (Panel, TFT, DC, (others => <>), Area, Stat);
      if Stat /= Ok then
         --  The frame stays lent, with no transfer to give it back:
         --  only a bus another device holds can do this, and nothing
         --  else is on this one. Stop showing frames.
         Ready := False;
         return;
      end if;
      Next := Other;
   end Show;
end Display;
