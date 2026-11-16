--  SPDX-License-Identifier: Apache-2.0
--  Keel.Drivers.INA219: the Texas Instruments INA219 current and
--  power monitor (SBOS448G). It measures the voltage across a shunt
--  resistor, which gives the current, and the voltage on the bus,
--  in 16-bit registers behind an I2C address. This is the stub
--  Chapter 14's meter needs: the configuration word, the shunt and
--  bus readings, and the current through a known shunt. Chapter 17
--  adds the calibration register, power and the interrupt-driven
--  I2C transport.
generic
   type Bus (<>) is limited private;
   --  Read or write one 16-bit register, most significant byte
   --  first, at the part's 7-bit I2C address
   with procedure Read_Register
     (B : in out Bus; Address : Natural; Register : Natural;
      Value : out Natural; Stat : out Keel.Status);
   with procedure Write_Register
     (B : in out Bus; Address : Natural; Register : Natural;
      Value : Natural; Stat : out Keel.Status);
package Keel.Drivers.INA219
  with SPARK_Mode
is
   subtype Word is Natural range 0 .. 2**16 - 1;

   --  A0 and A1 to ground: 1000000b (Table 1)
   Default_Address : constant := 16#40#;

   --  The register map (Table 2)
   Configuration : constant := 16#00#;
   Shunt_Voltage : constant := 16#01#;
   Bus_Voltage   : constant := 16#02#;

   --  The configuration register (Figure 19)
   type Bus_Range is (Range_16V, Range_32V);
   type Shunt_Gain is
     (Div_1_40mV, Div_2_80mV, Div_4_160mV, Div_8_320mV);
   --  ADC resolution or averaging, Table 5: 2#0011# is one 12-bit
   --  sample in 532 us; 2#1000# + N averages 2**N samples
   subtype ADC_Setting is Natural range 0 .. 15;
   One_12_Bit  : constant ADC_Setting := 2#0011#;
   Average_128 : constant ADC_Setting := 2#1111#;
   --  Table 6: 2#101# measures the shunt continuously, 2#111# the
   --  shunt and the bus
   subtype Mode_Setting is Natural range 0 .. 7;
   Power_Down       : constant Mode_Setting := 2#000#;
   Continuous_Shunt : constant Mode_Setting := 2#101#;
   Continuous_SB    : constant Mode_Setting := 2#111#;

   type Config is record
      Bus_V   : Bus_Range    := Range_32V;
      Gain    : Shunt_Gain   := Div_8_320mV;
      Bus_ADC : ADC_Setting  := One_12_Bit;
      Sh_ADC  : ADC_Setting  := One_12_Bit;
      Mode    : Mode_Setting := Continuous_SB;
   end record;

   function Encode (C : Config) return Word is
     (Bus_Range'Pos (C.Bus_V) * 2**13
      + Shunt_Gain'Pos (C.Gain) * 2**11
      + C.Bus_ADC * 2**7 + C.Sh_ADC * 2**3 + C.Mode);

   --  The defaults are the reset value, 399Fh
   pragma Assert (Encode ((others => <>)) = 16#399F#);

   --  The shunt voltage register is two's complement, 10 uV per
   --  count at every gain (8.6.3.1)
   function Shunt_uV (Raw : Word) return Integer is
     ((if Raw >= 2**15 then Raw - 2**16 else Raw) * 10)
     with Post => Shunt_uV'Result in -327_680 .. 327_670;

   --  The bus voltage register: 4 mV per count in bits 15 to 3;
   --  bit 1, CNVR, says a conversion is ready; bit 0, OVF, that the
   --  power or current overflowed (8.6.3.2)
   function Bus_mV (Raw : Word) return Natural is ((Raw / 8) * 4);
   function Ready (Raw : Word) return Boolean is (Raw / 2 mod 2 = 1);
   function Overflow (Raw : Word) return Boolean is (Raw mod 2 = 1);

   --  The current through a shunt of Milliohms, from its voltage
   subtype Shunt_Milliohms is Positive range 1 .. 10_000;
   function Current_uA
     (Shunt : Integer; Milliohms : Shunt_Milliohms) return Integer
   is (Shunt * 1_000 / Milliohms)
     with Pre => Shunt in -327_680 .. 327_670;

   procedure Configure
     (B : in out Bus; C : Config; Stat : out Keel.Status;
      Address : Natural := Default_Address);

   --  The shunt voltage, in microvolts
   procedure Read_Shunt
     (B : in out Bus; Microvolts : out Integer; Stat : out Keel.Status;
      Address : Natural := Default_Address)
     with Post => Microvolts in -327_680 .. 327_670;

   --  The bus voltage, in millivolts, and whether it is new
   procedure Read_Bus
     (B : in out Bus; Millivolts : out Natural; Fresh : out Boolean;
      Stat : out Keel.Status; Address : Natural := Default_Address);
end Keel.Drivers.INA219;
