--  SPDX-License-Identifier: Apache-2.0
--  Keel.ADC: an analog-to-digital converter's results as numbers. A
--  converter of Bits bits turns a voltage from 0 up to its reference
--  into a code from 0 to 2**Bits - 1. Adding 4**K codes and dividing
--  the sum by 2**K oversamples: the result has K more bits, if the
--  noise moves the input over a few codes. To_Volts scales a code,
--  through any divider in front of the pin, to Keel.Units.Volts, and
--  Temperature turns a diode sensor's voltage into Celsius.
with Keel.Units; use Keel.Units;

package Keel.ADC
  with Pure, SPARK_Mode
is
   --  A converter's resolution, and the bits oversampling adds
   subtype Resolution is Positive range 8 .. 16;
   subtype Extra_Bits is Natural range 0 .. 4;

   --  A result: a raw code, or an oversampled one with extra bits
   subtype Code is Natural range 0 .. 2**20 - 1;

   --  How one input becomes volts. Reference: the voltage that code
   --  2**Bits would stand for. Divider: the input is the pin's
   --  voltage times this (3 for a divide-by-3 in front of the pin).
   type Scale is record
      Bits      : Resolution := 12;
      Reference : Volts := 3.3;
      Divider   : Positive range 1 .. 16 := 1;
   end record;

   function Valid (S : Scale) return Boolean is
     (S.Reference in 0.5 .. 5.0);

   --  2**N, from a table: the prover reads a table more easily
   --  than a power with a variable exponent
   subtype Power is Positive range 1 .. 2**20;
   function Two_To (N : Natural) return Power
     with Pre => N <= 20;

   --  The largest raw code
   function Top (S : Scale) return Code is (Two_To (S.Bits) - 1);

   --  The samples to add up for K extra bits: 4**K
   subtype Sample_Count is Positive range 1 .. 256;
   function Samples_For (K : Extra_Bits) return Sample_Count is
     (Two_To (2 * K));

   --  The largest code with K extra bits
   function Top (S : Scale; K : Extra_Bits) return Code is
     (Two_To (S.Bits + K) - 1);

   --  A sum of Samples_For (K) raw codes as one code with K extra
   --  bits: the sum divided by 2**K, rounded down, and never above
   --  Top (S, K)
   function Oversample (S : Scale; Total : Natural; K : Extra_Bits)
     return Code
     with Post => Oversample'Result <= Top (S, K);

   --  The mean of N codes that add up to Total, to the nearest code,
   --  and never above Top (S)
   function Mean (S : Scale; Total : Natural; N : Sample_Count)
     return Code
     with Post => Mean'Result <= Top (S);

   --  The voltage at the input for Value, a code with K extra bits:
   --  Value * Reference * Divider / 2**(Bits + K), to 1 mV
   function To_Volts (S : Scale; Value : Code; K : Extra_Bits := 0)
     return Volts
     with Pre => Valid (S);

   --  A diode sensor: At_Ref volts at T_Ref degrees, changing by
   --  Slope microvolts per degree (negative: the voltage falls as
   --  the temperature rises)
   type Diode_Sensor is record
      At_Ref : Volts := 0.7;
      T_Ref  : Integer range -40 .. 125 := 25;
      Slope  : Integer range -5_000 .. -100 := -2_000;
   end record;

   function Valid (D : Diode_Sensor) return Boolean is
     (D.At_Ref in 0.1 .. 2.0);

   --  The temperature for the sensor's voltage V, to 0.01 degrees,
   --  held inside Celsius's range
   function Temperature (D : Diode_Sensor; V : Volts) return Celsius
     with Pre => Valid (D) and then V in 0.0 .. 5.0;
end Keel.ADC;
