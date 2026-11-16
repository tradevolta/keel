--  SPDX-License-Identifier: Apache-2.0
--  Keel.Power: the ways a chip can wait, and the policy that picks
--  one. The deeper a mode, the less power it draws and the longer
--  it takes to enter and leave. A policy names the deepest mode the
--  program allows and what each mode costs; Choose picks the deepest
--  one the time left pays for, and GNATprove proves it does. Idle
--  wraps a chip's modes and a policy into a Wait_Until that fits
--  the Keel.Time seam, so every driver that waits through the seam
--  waits in the right mode.
with Keel.Time; use Keel.Time;

package Keel.Power
  with Pure, SPARK_Mode, No_Elaboration_Code_All
is
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

   --  A wait in the chip's modes under a policy
   generic
      with function Clock return Keel.Time.Time;
      --  Wait in mode M, until Deadline at the latest; an interrupt
      --  may end the wait sooner. Run returns at once; Power_Down
      --  does not return.
      with procedure Enter
        (M : Mode; Deadline : Keel.Time.Time);
      --  The policy now: a program may change it as it runs
      with function Current return Policy;
   package Idle is
      --  Return at or after Deadline, waiting in the deepest mode
      --  the policy allows each time round. Fits
      --  Keel.Time.Clock_Signature.
      procedure Wait_Until (Deadline : Keel.Time.Time)
        with Pre => Deadline <= Max_Clock;
   end Idle;
end Keel.Power;
