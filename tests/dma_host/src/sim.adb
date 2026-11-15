--  SPDX-License-Identifier: Apache-2.0
with Ada.Numerics.Elementary_Functions;
with Interfaces; use Interfaces;
use Ada.Numerics.Elementary_Functions;

package body Sim is

   Supply : constant Float := 3.3;
   Tau    : constant Float := 1.0E-3;      --  10 kohm * 100 nF
   Half_T : constant Float := 1.0E-3;      --  high, then low, 1 ms
   --  The settled swing: from Low to Supply - Low and back
   Low    : constant Float := Supply / (1.0 + Exp (Half_T / Tau));

   --  The same noise every run, -6 .. +6 codes: Knuth's
   --  multiplicative hash of N
   function Noise (N : Natural) return Integer is
      X : constant Unsigned_32 := Unsigned_32 (N) * 2_654_435_761;
   begin
      return Integer (Shift_Right (X, 16) mod 13) - 6;
   end Noise;

   function Code (N : Natural) return Sample is
      T : constant Float := Float (N mod Period) / Float (Rate);
      V : Float;
      C : Integer;
   begin
      if T < Half_T then
         V := Supply - (Supply - Low) * Exp (-T / Tau);
      else
         V := (Supply - Low) * Exp (-(T - Half_T) / Tau);
      end if;
      C := Integer (V / Supply * 4_096.0) + Noise (N);
      return Sample (Integer'Max (0, Integer'Min (4_095, C)));
   end Code;
end Sim;
