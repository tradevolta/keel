--  SPDX-License-Identifier: Apache-2.0
--  New types, subtypes, a modular type, an enumeration and a
--  fixed-point type: the kinds of scalar Keel uses everywhere.
package Units
  with Pure
is
   type Milli_Volts is range 0 .. 3_300;  --  a new integer type
   type Milli_Amps  is range 0 .. 500;  --  another, distinct one

   subtype Low_Volts is Milli_Volts range 0 .. 1_000;  --  a constraint

   type Byte is mod 2**8;  --  wraps: 255 + 1 = 0

   type Channel is (AIN0, AIN1, AIN2, AIN3, Temp_Sensor);

   type GPIO_Number is range 0 .. 29;  --  RP2350A has GPIO0..29
   subtype Header_Pin is GPIO_Number  --  pins on the Pico 2 W
     with Static_Predicate => Header_Pin in 0 .. 22 | 26 .. 28;

   type Celsius is delta 0.01 range -40.0 .. 125.0
     with Small => 0.01;  --  exact steps of 0.01
end Units;
