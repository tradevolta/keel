--  SPDX-License-Identifier: Apache-2.0
--  Keel.Timer on the RP2350: TIMER0's alarms 0 to 2. Alarm N raises
--  TIMER0_IRQ_N, which is IRQ N, and its handler is exported as
--  keel_isr_N. Alarm 3 belongs to Keel.Time.Bare. An alarm matches
--  the counter's low 32 bits, so At_Time must be less than 2**32 us,
--  about 71 minutes, ahead.
with Keel.Interrupts;
with Keel.Time; use type Keel.Time.Time;

package Keel.Timer.RP2350
  with Preelaborate
is
   type Alarm_Id is range 0 .. 2;

   function IRQ_Of (Id : Alarm_Id) return Keel.Interrupts.IRQ is
     (Keel.Interrupts.IRQ (Id));

   type Alarm (Id : Alarm_Id) is limited private;

   function Is_Claimed (A : Alarm) return Boolean;

   --  Take alarm Id and enable its interrupt in TIMER0 (INTE). The
   --  NVIC side, priority and enable, is the caller's. In_Use:
   --  another object owns the alarm. Needs Keel.Time.Bare started.
   procedure Claim (A : in out Alarm; Stat : out Status)
     with Pre  => not Is_Claimed (A),
          Post => Is_Claimed (A) = (Stat = Ok);

   procedure Set (A : in out Alarm; At_Time : Keel.Time.Time)
     with Pre => Is_Claimed (A)
                 and then At_Time <= Keel.Time.Max_Clock;

   procedure Cancel (A : in out Alarm)
     with Pre => Is_Claimed (A), Post => not Is_Armed (A);

   function Is_Armed (A : Alarm) return Boolean
     with Pre => Is_Claimed (A);

   procedure Acknowledge (A : in out Alarm)
     with Pre => Is_Claimed (A);
private
   type Alarm (Id : Alarm_Id) is limited record
      Claimed : Boolean := False;
   end record;

   function Is_Claimed (A : Alarm) return Boolean is (A.Claimed);
end Keel.Timer.RP2350;
