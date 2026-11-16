--  SPDX-License-Identifier: Apache-2.0
package body Keel.Power
  with SPARK_Mode
is
   function Choose (P : Policy; Budget : Time_Span) return Mode is
   begin
      for M in reverse Mode'Succ (Run) .. P.Deepest loop
         if P.Wake (M) <= Budget then
            return M;
         end if;
         pragma Loop_Invariant
           (for all N in M .. P.Deepest => P.Wake (N) > Budget);
      end loop;
      return Run;
   end Choose;

   package body Idle is
      procedure Wait_Until (Deadline : Keel.Time.Time) is
         Now : Keel.Time.Time;
      begin
         loop
            Now := Keel.Time.Time'Min (Clock, Max_Clock);
            exit when Now >= Deadline;
            Enter (Choose (Current, Deadline - Now), Deadline);
         end loop;
      end Wait_Until;
   end Idle;
end Keel.Power;
