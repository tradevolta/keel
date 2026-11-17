--  SPDX-License-Identifier: Apache-2.0
--  A bus device, a pin and a clock that only count, so that the
--  ST7789 driver can be instantiated and proved
with Keel.Bus.SPI;
with Keel.DMA;
with Keel.GPIO.Output_Signature;
with Keel.Time;
with Keel.Drivers.ST7789;

package Stub_Panel
  with SPARK_Mode
is
   use Keel;
   use Keel.Bus.SPI;

   type Device is limited record
      Calls : Natural := 0;
   end record;
   procedure Acquire (D : in out Device; Stat : out Status);
   procedure Release (D : in out Device);
   procedure Write (D : in out Device; Data : Byte_Array);
   procedure Exchange (D : in out Device; Data : in out Byte_Array);
   procedure Start_Stream
     (D     : in out Device;
      From  : Keel.DMA.Region;
      Count : Positive;
      Stat  : out Status);
   procedure Finish_Stream (D : in out Device; Done : out DMA.Receipt);

   type Pin is limited record
      Level : GPIO.Level := GPIO.Low;
   end record;
   procedure Set (P : in out Pin; To : GPIO.Level);

   Now : Time.Time := 0;
   function Clock return Time.Time
     with Global => (Input => Now);
   procedure Wait_Until (Deadline : Time.Time)
     with Global => (In_Out => Now);

   package Link is new Device_Signature
     (Device, Acquire, Release, Write, Exchange, Start_Stream,
      Finish_Stream);
   package Pins is new GPIO.Output_Signature (Pin);
   package Timer is new Time.Clock_Signature (Clock, Wait_Until);
   package Panel is new Drivers.ST7789 (Link, Pins, Timer);
end Stub_Panel;
