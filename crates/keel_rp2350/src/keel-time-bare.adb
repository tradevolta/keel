--  SPDX-License-Identifier: Apache-2.0
with Interfaces;         use Interfaces;
with RP2350_SVD;         use RP2350_SVD;
with Keel.Cortex_M;      use Keel.Cortex_M;
with Keel.Interrupts;    use Keel.Interrupts;
with RP2350_SVD.Atomic;
with RP2350_SVD.RESETS;  use RP2350_SVD.RESETS;
with RP2350_SVD.TICKS;   use RP2350_SVD.TICKS;
with RP2350_SVD.TIMER0;  use RP2350_SVD.TIMER0;

package body Keel.Time.Bare is

   Started : Boolean := False;

   function Is_Started return Boolean is (Started);

   TIMER0_IRQ_3 : constant IRQ := 3;

   package Reset_Bits is new RP2350_SVD.Atomic (RESET_Register);

   procedure Start (Reference : Keel.Clock.Frequency) is
      Timer0_Only : constant RESET_TIMER_Field :=
        (As_Array => True, Arr => [0 => True, 1 => False]);
   begin
      Reset_Bits.Clear
        (RESETS_Periph.RESET,
         (Reset_Bits.No_Bits with delta TIMER => Timer0_Only));
      loop
         exit when RESETS_Periph.RESET_DONE.TIMER.Arr (0);
      end loop;
      --  Datasheet 8.5.1: stop the generator, set the count, start
      TICKS_Periph.TIMER0_CTRL.ENABLE := False;
      TICKS_Periph.TIMER0_CYCLES.TIMER0_CYCLES :=
        TIMER0_CYCLES_TIMER0_CYCLES_Field (Reference / 1_000_000);
      TICKS_Periph.TIMER0_CTRL.ENABLE := True;

      TIMER0_Periph.INTE.ALARM_3 := True;
      Set_Priority (TIMER0_IRQ_3, 15);
      Clear_Pending (TIMER0_IRQ_3);
      Enable (TIMER0_IRQ_3);
      Started := True;
   end Start;

   --  Read the high word, the low word, and the high word again. If
   --  the high word moved, the low word wrapped between the reads:
   --  read both again (the SDK's time_us_64 does the same).
   function Clock return Time is
      Hi : UInt32 := TIMER0_Periph.TIMERAWH;
      Lo, Hi_Again : UInt32;
   begin
      loop
         Lo := TIMER0_Periph.TIMERAWL;
         Hi_Again := TIMER0_Periph.TIMERAWH;
         exit when Hi_Again = Hi;
         Hi := Hi_Again;
      end loop;
      return Time (Unsigned_64'Min
                     (Shift_Left (Unsigned_64 (Hi), 32)
                        or Unsigned_64 (Lo),
                      Unsigned_64 (Max_Clock)));
   end Clock;

   --  Alarm 3 has nothing to do but end the WFI: clear its latch
   procedure Alarm_3_Handler
     with Export, Convention => C, External_Name => "keel_isr_3";

   procedure Alarm_3_Handler is
   begin
      TIMER0_Periph.INTR := (ALARM_3 => True, others => <>);
   end Alarm_3_Handler;

   procedure Wake_At (Deadline : Time) is
      Now : constant Time := Clock;
      Last : constant Time := Time'Min (Deadline, Max_Clock);
      At_Time : constant Time :=
        (if Time_Span'(Last - Now) > 2**31
         then Now + Time_Span'(2**31) else Last);
   begin
      --  The alarm compares the low 32 bits for equality
      TIMER0_Periph.ALARM3 := UInt32 (At_Time mod 2**32);
      if Clock >= At_Time then
         --  Too late to match: disarm it, and pend its interrupt
         TIMER0_Periph.ARMED := (ARMED => 2#1000#, others => <>);
         Set_Pending (TIMER0_IRQ_3);
      end if;
   end Wake_At;

   --  As Keel.Sync.Bare.Wait: look and sleep with interrupts
   --  masked, so the alarm cannot fire between the look and the WFI
   procedure Wait_Until (Deadline : Time) is
   begin
      loop
         Disable_Interrupts;
         exit when Clock >= Deadline;
         Wake_At (Deadline);
         WFI;
         Enable_Interrupts;
      end loop;
      Enable_Interrupts;
   end Wait_Until;

   --  The bare backend fits the seam: this fails to compile if not
   package Fits is new Keel.Time.Clock_Signature (Clock, Wait_Until);
   pragma Unreferenced (Fits);
end Keel.Time.Bare;
