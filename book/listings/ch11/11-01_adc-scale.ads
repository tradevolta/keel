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
