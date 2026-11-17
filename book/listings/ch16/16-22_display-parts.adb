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
