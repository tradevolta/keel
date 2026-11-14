--  SPDX-License-Identifier: Apache-2.0
--  Keel.PWM: a PWM counter's period and duty as numbers. The counter
--  counts its input clock divided by Div, from 0 up to Top, then
--  wraps to 0 (trailing edge) or counts back down to 0 (phase
--  correct, half the frequency). An output is high while the count
--  is below its level: level 0 is always low, Top + 1 always high.
--  A chip's dividers are data, as Keel.Clock's PLL limits are, and
--  Solve finds a setting for a frequency. Frequencies and widths
--  are Keel.Units values.
with Keel.Units; use Keel.Units;

package Keel.PWM
  with Pure, SPARK_Mode
is
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

   --  N / K to the nearest whole number, halves rounded up
   function Nearest (N, K : Wide) return Wide is
     ((2 * N + K) / (2 * K))
     with Pre => N in 0 .. 2**40 and then K in 1 .. 2**60;

   --  Top + 1 is the whole number of counts nearest to the exact
   --  period, 16 * Clock / (Div * Factor * Want): the period is
   --  within half a count of 1 / Want
   function Close (S : Setting; Want : Hertz) return Boolean is
     (Want >= 1.0
      and then Wide (Top (S)) + 1
                 = Nearest (16 * Wide (Clock (S)),
                            Wide (Div (S)) * Factor (Mode (S))
                            * Wide (Want)));

   --  Find the setting with the largest Top, so the finest duty
   --  steps, that makes Want from Clock. Not_Supported: Want is
   --  out of reach, or Phase_Correct on a counter without it.
   procedure Solve
     (L : Counter_Limits; Clock : Hertz;
      Want : Hertz; Mode : Shape; S : out Setting;
      Stat : out Status)
     with
       Pre  => Valid (L),
       Post =>
         (if Stat = Ok then
            Limits (S) = L
            and then PWM.Clock (S) = Clock
            and then PWM.Mode (S) = Mode
            and then Close (S, Want));

   --  The frequency S makes, to the nearest hertz
   function Output (S : Setting) return Hertz;

   --  A fraction of the period, to 1/65536
   type Duty is delta 2.0**(-16) range 0.0 .. 1.0
     with Small => 2.0**(-16), Size => 32;

   --  The level for a duty: D * (Top + 1), to the nearest count
   function Level_For (S : Setting; D : Duty) return Count
     with Post => Level_For'Result <= Top (S) + 1;

   --  The level that keeps the output high for W in each period,
   --  to the nearest count, and Top + 1 if W is a period or more
   function Width_Level (S : Setting; W : Micro_Seconds) return Count
     with Post => Width_Level'Result <= Top (S) + 1;
private
   function Within (L : Counter_Limits; D : Sixteenths; T : Count)
     return Boolean is
     (Valid (L) and then D in L.Div_Min .. L.Div_Max
      and then D mod L.Div_Step = 0 and then T in 1 .. L.Top_Max);

   type Setting is record
      L : Counter_Limits;
      C : Hertz := 0.0;
      D : Sixteenths := 16;
      T : Count := 1;
      M : Shape := Trailing_Edge;
   end record
     with Type_Invariant => Within (L, D, T)
       and then (M = Trailing_Edge or else L.Phase_Correct);

   function Limits (S : Setting) return Counter_Limits is (S.L);
   function Clock (S : Setting) return Hertz is (S.C);
   function Div (S : Setting) return Sixteenths is (S.D);
   function Top (S : Setting) return Count is (S.T);
   function Mode (S : Setting) return Shape is (S.M);
end Keel.PWM;
