--  Wait in M until Deadline (on Keel.Time.Bare's clock) or an
--  interrupt; Run returns at once. Dormant and Power_Down round
--  up to the always-on timer's milliseconds. A Power_Down that
--  POWMAN refuses, or a deadline too close for the deeper modes,
--  waits in Sleep instead.
procedure Enter (M : Mode; Deadline : Keel.Time.Time);

--  The policy Wait_Until follows; Deepest is Sleep until set
procedure Set_Policy (P : Policy);
function Current return Policy;

--  Keel's estimates of what each mode costs to leave, in
--  microseconds: the crystal's 6 ms start-up after Dormant, a
--  boot from flash after Power_Down. Estimates, not measurements.
Default_Costs : constant Costs :=
  [Run => 0, Sleep => 0, Dormant => 20_000, Power_Down => 500_000];
