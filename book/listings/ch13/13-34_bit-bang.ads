--  SPDX-License-Identifier: Apache-2.0
--  Keel.OneWire.Bit_Bang: a 1-Wire bus driven by the processor, on
--  any open-drain pin, for chips without a PIO. The processor times
--  each slot itself, with interrupts held off while it does, so a
--  slot costs the processor its 70 us. Times from AN126, standard
--  speed. Reset and Touch provide Keel.OneWire.Bus_Signature.
with Keel.GPIO;

generic
   type Line (<>) is limited private;
   --  Low pulls the line low; High lets it go
   with procedure Set (L : in out Line; To : Keel.GPIO.Level);
   --  The level on the line
   with function Sense (L : Line) return Keel.GPIO.Level;
   --  Spin at least N microseconds
   with procedure Wait_Us (N : Positive);
   --  Hold interrupts off, and let them in again
   with procedure Hold;
   with procedure Let_Go;
package Keel.OneWire.Bit_Bang is
   --  480 us low, sample 70 us after, 410 us more
   procedure Reset
     (L : in out Line; Present : out Boolean; Stat : out Status);

   --  A 1: 6 us low, sample 9 us after, 55 us more. A 0: 60 us low,
   --  10 us to recover.
   procedure Touch
     (L : in out Line; Bit : Boolean; Got : out Boolean;
      Stat : out Status);
end Keel.OneWire.Bit_Bang;
