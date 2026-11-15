--  SPDX-License-Identifier: Apache-2.0
--  Keel.Drivers.DS18B20: the Analog Devices (Maxim) DS18B20 1-Wire
--  thermometer, on any bus with Keel.OneWire.Bus_Signature. It reads
--  -55 to +125 degrees C as a 16-bit two's complement number of
--  sixteenths of a degree, after a conversion of up to 750 ms at the
--  power-on resolution, 12 bits.
with Keel.OneWire; use Keel.OneWire;
with Keel.Time;
with Keel.Units; use type Keel.Units.Celsius;

generic
   with package Wire is new Bus_Signature (<>);
package Keel.Drivers.DS18B20
  with SPARK_Mode
is
   --  The bus's status, not Keel.Status
   subtype Status is Keel.OneWire.Status;

   --  The family code, the first byte of every DS18B20's ROM code
   Family_Code : constant Byte := 16#28#;

   --  Function commands
   Convert_T       : constant Byte := 16#44#;
   Read_Scratchpad : constant Byte := 16#BE#;

   --  The longest conversion, at 12 bits
   Conversion_Time : constant Keel.Time.Time_Span :=
     Keel.Time.Milliseconds (750);

   --  The temperature register, in sixteenths of a degree
   type Raw_Temperature is range -2**15 .. 2**15 - 1;
   --  What the part can measure: -55 to +125 degrees C
   subtype Rated is Raw_Temperature range -880 .. 2_000;
   --  What it holds from power-on until a conversion: +85 degrees C
   Power_On_Value : constant Raw_Temperature := 16#0550#;

   --  Raw in hundredths of a degree, rounded half away from zero
   function Hundredths (Raw : Rated) return Integer is
     (if Raw >= 0 then (Integer (Raw) * 25 + 2) / 4
      else -((2 - Integer (Raw) * 25) / 4))
     with Post => Hundredths'Result in -5_500 .. 12_500;

   function To_Celsius (Raw : Rated) return Keel.Units.Celsius is
     (Keel.Units.Celsius'(0.01) * Hundredths (Raw));

   --  Start a conversion in every device on the bus (Skip ROM, then
   --  Convert T). Wait Conversion_Time before reading.
   procedure Start_Conversion (B : in out Wire.Bus; Stat : out Status);

   --  Read device ROM's scratchpad and return its temperature.
   --  CRC_Error: the nine bytes failed their CRC. Bus_Low: they
   --  were all zeros, which pass the CRC but no DS18B20 sends.
   procedure Read
     (B    : in out Wire.Bus;
      ROM  : ROM_Code;
      Raw  : out Raw_Temperature;
      Stat : out Status);
end Keel.Drivers.DS18B20;
