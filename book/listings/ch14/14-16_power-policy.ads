--  From the lightest to the deepest:
--  Run: keep running; the wait is a busy loop.
--  Sleep: the processor and the clocks it doesn't need stop;
--  an interrupt wakes it.
--  Dormant: every clock and oscillator stops; a timer that runs
--  on its own restarts them, and the program carries on.
--  Power_Down: the core loses power. Waking up is a reboot, and
--  only retained state survives.
type Mode is (Run, Sleep, Dormant, Power_Down);

--  What a mode costs, in microseconds of entering and leaving
subtype Cost is Time_Span range 0 .. Time_Span'Last;
type Costs is array (Mode) of Cost;

type Policy is record
   Deepest : Mode  := Sleep;
   Wake    : Costs := [others => 0];
end record;

--  The deepest mode, down to P.Deepest, whose cost Budget covers;
--  Run if none does
function Choose (P : Policy; Budget : Time_Span) return Mode
  with Post =>
    Choose'Result <= P.Deepest
    and then (Choose'Result = Run
              or else P.Wake (Choose'Result) <= Budget)
    and then (for all M in Mode =>
                (if M > Choose'Result and then M <= P.Deepest
                 then P.Wake (M) > Budget));
