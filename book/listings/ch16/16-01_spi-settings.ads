--  The four clock modes. CPOL, the clock's level between frames,
--  is high in modes 2 and 3; CPHA, which edge samples the data,
--  is the second edge of each bit in modes 1 and 3.
type Clock_Mode is range 0 .. 3;
function Idles_High (M : Clock_Mode) return Boolean is (M >= 2);
function Samples_Second_Edge (M : Clock_Mode) return Boolean is
  (M mod 2 = 1);

subtype Bit_Rate is Positive range 1_000 .. 100_000_000;
subtype Clock_Hz is Positive range 1_000_000 .. 500_000_000;

--  What a device asks of the bus: its clock mode, and the fastest
--  clock it takes. A driver runs the bus at that rate or slower,
--  never faster.
type Settings is record
   Mode     : Clock_Mode := 0;
   Max_Rate : Bit_Rate   := 1_000_000;
end record;
