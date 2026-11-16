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
