--  SPDX-License-Identifier: Apache-2.0
--  Physical units as fixed-point types. Each type also reads a string
--  literal with its unit, so "12 MHz" is a Hertz value and "500 ms" a
--  Micro_Seconds value. Numeric literals keep working ("12.0E6").
package Keel.Units
  with Pure, SPARK_Mode
is
   --  A frequency, to 1 Hz.
   type Hertz is delta 1.0 range 0.0 .. 1.0E9
     with Small => 1.0, String_Literal => To_Hertz;

   --  A duration, to 1 us: up to 2**31 - 1 us, about 35.8 minutes.
   type Micro_Seconds is delta 1.0 range 0.0 .. 2.0**31 - 1.0
     with Small => 1.0, String_Literal => To_Micro_Seconds;

   --  A voltage, to 1 mV.
   type Volts is delta 0.001 range -100.0 .. 100.0
     with Small => 0.001, String_Literal => To_Volts;

   --  A temperature, to 0.01 degrees.
   type Celsius is delta 0.01 range -273.15 .. 1_000.0
     with Small => 0.01, String_Literal => To_Celsius;

   --  A literal is "<number> <unit>": digits with an optional fraction
   --  and "_" between digits, then one space and the unit. Hertz takes
   --  Hz, kHz, MHz and GHz; Micro_Seconds us, ms and s; Volts mV and
   --  V; Celsius C. The value must fit the type exactly: "1.5 us" is
   --  not a Micro_Seconds value.
   function Is_Hertz (S : Wide_Wide_String) return Boolean;
   function Is_Micro_Seconds (S : Wide_Wide_String) return Boolean;
   function Is_Volts (S : Wide_Wide_String) return Boolean;
   function Is_Celsius (S : Wide_Wide_String) return Boolean;

   --  The literal functions. A bad literal fails the precondition (or
   --  raises Constraint_Error with assertions off).
   function To_Hertz (S : Wide_Wide_String) return Hertz
     with Pre => Is_Hertz (S);
   function To_Micro_Seconds (S : Wide_Wide_String) return Micro_Seconds
     with Pre => Is_Micro_Seconds (S);
   function To_Volts (S : Wide_Wide_String) return Volts
     with Pre => Is_Volts (S);
   function To_Celsius (S : Wide_Wide_String) return Celsius
     with Pre => Is_Celsius (S);
end Keel.Units;
