--  Dividers count in sixteenths of a clock cycle: 16 is 1.0
subtype Sixteenths is Positive range 16 .. 2**20;
--  Counts and levels: Top + 1 must still fit in 16 bits
subtype Count is Natural range 0 .. 2**16 - 1;

--  One counter's rules, from its chip's reference manual.
--  Div_Step is 1 for a fractional divider, 16 for a whole one.
--  Top_Max leaves room for the 100 % level, Top + 1.
type Counter_Limits is record
   Div_Min : Sixteenths := 16;
   Div_Max : Sixteenths := 16;
   Div_Step : Positive range 1 .. 16 := 1;
   Top_Max : Count := 1;
   --  The counter can count back down
   Phase_Correct : Boolean := False;
end record;

function Valid (L : Counter_Limits) return Boolean is
  (L.Div_Min <= L.Div_Max
   and then L.Div_Min mod L.Div_Step = 0
   and then L.Div_Max mod L.Div_Step = 0
   and then L.Top_Max in 1 .. 2**16 - 2);

type Shape is (Trailing_Edge, Phase_Correct);

--  Wide enough for any product here
type Wide is range -(2**63 - 1) .. 2**63 - 1;

function Factor (M : Shape) return Wide is
  (if M = Phase_Correct then 2 else 1);

--  A setting of one counter, always inside its limits
type Setting is private;

function Limits (S : Setting) return Counter_Limits;
function Clock (S : Setting) return Hertz;
function Div (S : Setting) return Sixteenths;
function Top (S : Setting) return Count;
function Mode (S : Setting) return Shape;

--  Input clock cycles in one period, times 16
function Period_16 (S : Setting) return Wide is
  (Wide (Div (S)) * Wide (Top (S) + 1) * Factor (Mode (S)));
