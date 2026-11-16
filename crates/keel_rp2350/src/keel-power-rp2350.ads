--  SPDX-License-Identifier: Apache-2.0
--  Keel.Power on the RP2350 (datasheet chapter 6): the four modes,
--  POWMAN's retained scratch words, and a Wait_Until for the seam.
--    Sleep: deep sleep with every clock gated but TIMER0, its tick
--      and the watchdog's (6.5.1, 6.5.2); TIMER0's alarm 3 ends it.
--    Dormant: every clock and oscillator stopped (6.5.3); the
--      always-on timer's alarm restarts them.
--    Power_Down: the switched core off, P1.7 (6.2.2); the alarm or
--      a falling edge on the wake pin powers it up, and the program
--      starts again from reset.
--  The sequences follow the Pico SDK's pico_low_power library.
with Interfaces;
with Keel.GPIO.RP2350;
with Keel.Time;

package Keel.Power.RP2350
  with Preelaborate
is
   subtype Word is Interfaces.Unsigned_32;

   ------------------------------------------------------------------
   --  Retained state: POWMAN SCRATCH0 to SCRATCH7, in the always-on
   --  domain. They keep their contents through sleep, dormant,
   --  switched-core power down and watchdog resets, and lose them
   --  only at power-on, brown-out and a RUN pin reset (Table 560).
   ------------------------------------------------------------------
   type Retained_Index is range 0 .. 7;
   type Retained_Words is array (Retained_Index) of Word;

   function Retained (I : Retained_Index) return Word;
   procedure Retain (I : Retained_Index; Value : Word);

   ------------------------------------------------------------------
   --  Start-up
   ------------------------------------------------------------------

   --  What ended the last power down
   type Wake_Source is (Not_Powered_Down, Alarm, Wake_Pin, Other);

   --  Call first, with the always-on timer running. After a power
   --  down: note what woke the chip, then disarm the alarm and the
   --  wake pin. After a watchdog reset: the Pico SDK's one-time
   --  WFI that lets later deep sleeps work.
   procedure Initialize;
   function Last_Wake return Wake_Source;

   --  LAST_SWCORE_PWRUP, raw, for checking against Table 550
   function Last_Power_Up_Source return Natural;

   --  A falling edge on Pin ends a power down too (PWRUP0)
   procedure Set_Wake_Pin (Pin : Keel.GPIO.RP2350.Pin_Id);

   --  With a debug probe attached, the switched core never powers
   --  down unless POWMAN ignores the debugger's power-up request
   --  (6.2.3.3, DBG_PWRCFG.IGNORE). The Pico SDK always sets it.
   procedure Ignore_Debugger (Ignore : Boolean := True);

   ------------------------------------------------------------------
   --  The modes
   ------------------------------------------------------------------

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

   --  Keel.Power.Idle on Keel.Time.Bare's clock: fits the seam
   procedure Wait_Until (Deadline : Keel.Time.Time)
     with Pre => Keel.Time."<=" (Deadline, Keel.Time.Max_Clock);
end Keel.Power.RP2350;
