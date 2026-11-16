--  SPDX-License-Identifier: Apache-2.0
--  Keel.Power on the STM32G4, as far as Chapter 14 takes it:
--  retained words in the backup domain (TAMP_BKP0R to TAMP_BKP7R,
--  of 32), which keep their contents through every reset but a loss
--  of power, and Sleep, the core stopped in WFI with SysTick waking
--  it each millisecond. Stop, Standby and Shutdown need the RTC or
--  LPTIM as a wake-up timer; until Keel has one, a policy that
--  allows them waits in Sleep.
with Interfaces;
with Keel.Time;

package Keel.Power.STM32G4
  with Preelaborate
is
   subtype Word is Interfaces.Unsigned_32;

   type Retained_Index is range 0 .. 7;

   --  Open the backup domain for writing: PWR's clock, PWR_CR1.DBP,
   --  and the RTC and TAMP's bus clock (RTCAPBEN)
   procedure Initialize;

   function Retained (I : Retained_Index) return Word;
   procedure Retain (I : Retained_Index; Value : Word);

   procedure Enter (M : Mode; Deadline : Keel.Time.Time);

   procedure Set_Policy (P : Policy);
   function Current return Policy;

   procedure Wait_Until (Deadline : Keel.Time.Time)
     with Pre => Keel.Time."<=" (Deadline, Keel.Time.Max_Clock);
end Keel.Power.STM32G4;
