--  SPDX-License-Identifier: Apache-2.0
--  Keel.Quadrature: a rotary encoder's two contacts, A and B, as a
--  position. The pair goes through four phases in Gray code order,
--  00, 01, 11, 10 one way and back the other, so each change of one
--  contact is a step of one count. A change of both at once has no
--  direction: it is counted as invalid and moves nothing.
package Keel.Quadrature
  with Pure, SPARK_Mode
is
   --  A is bit 0, B is bit 1
   type Phase is range 0 .. 3;

   function Phase_Of (A, B : Boolean) return Phase is
     ((if A then 1 else 0) + (if B then 2 else 0));

   subtype Step is Integer range -1 .. 1;

   --  One transition: +1 forward (00 01 11 10), -1 back, 0 for no
   --  change or an invalid jump
   Steps : constant array (Phase, Phase) of Step :=
     [0 => [0 => 0, 1 => 1, 3 => 0, 2 => -1],
      1 => [0 => -1, 1 => 0, 3 => 1, 2 => 0],
      3 => [0 => 0, 1 => -1, 3 => 0, 2 => 1],
      2 => [0 => 1, 1 => 0, 3 => -1, 2 => 0]];

   --  Both contacts changed: the decoder missed a phase
   function Invalid (Old, Now : Phase) return Boolean is
     (Old /= Now and then Steps (Old, Now) = 0);

   Limit : constant := 2**20;
   subtype Count is Integer range -Limit .. Limit;

   --  Position stays in Low .. High: a knob that stops at its ends
   type Decoder (Low, High : Count) is record
      Last : Phase := 0;
      Position : Count := 0;
      Misses : Natural := 0;
   end record
     with Dynamic_Predicate =>
       Low <= High and then Position in Low .. High;

   function Clamp (D : Decoder; P : Integer) return Count is
     (if P < D.Low then D.Low elsif P > D.High then D.High else P)
     with Pre => P in -Limit - 1 .. Limit + 1;

   --  Feed the contacts' new phase; from the interrupt handler
   procedure Update (D : in out Decoder; Now : Phase)
     with
       Post =>
         D.Last = Now
         and then D.Position
                    = Clamp (D'Old,
                             D.Position'Old + Steps (D.Last'Old, Now))
         and then D.Misses
                    = (if Invalid (D.Last'Old, Now)
                         and then D.Misses'Old < Natural'Last
                       then D.Misses'Old + 1 else D.Misses'Old);
end Keel.Quadrature;
