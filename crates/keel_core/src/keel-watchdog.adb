--  SPDX-License-Identifier: Apache-2.0
package body Keel.Watchdog
  with SPARK_Mode
is
   procedure Solve
     (L : Counter_Limits; T : Timeout_Ms; S : out Setting;
      Found : out Boolean)
   is
      Need  : constant Ticks_Count := Ticks_For (L, T);
      Extra : constant Long_Long_Integer :=
        (if L.Plus_One then 1 else 0);
      Shift : Natural range 0 .. 16 := L.Min_Shift;
      D, Q  : Long_Long_Integer;
   begin
      --  Too long for the counter at its slowest
      if Ticks (L, (L.Max_Shift, L.Max_Reload)) < Need then
         S := (L.Max_Shift, L.Max_Reload);
         Found := False;
         return;
      end if;

      --  From the finest prescaler up: Q is the counts T needs at
      --  this one, rounded up; stop at the first that fits
      loop
         D := Pow2 (Shift);
         Q := (Need + D - 1) / D;
         pragma Assert (Need + D - 1 = Q * D + (Need + D - 1) mod D);
         pragma Assert (Q * D >= Need and then (Q - 1) * D < Need);
         exit when Q - Extra <= Long_Long_Integer (L.Max_Reload)
           or else Shift = L.Max_Shift;
         Shift := Shift + 1;
         pragma Loop_Invariant (Shift in L.Min_Shift .. L.Max_Shift);
         pragma Loop_Variant (Increases => Shift);
      end loop;

      S := (Shift, Natural (Q - Extra));
      Found := True;
   end Solve;
end Keel.Watchdog;
