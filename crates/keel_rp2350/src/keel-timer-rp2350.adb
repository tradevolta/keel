--  SPDX-License-Identifier: Apache-2.0
with Interfaces;         use Interfaces;
with Keel.Time.Bare;
with RP2350_SVD;         use RP2350_SVD;
with RP2350_SVD.Atomic;
with RP2350_SVD.TIMER0;  use RP2350_SVD.TIMER0;

package body Keel.Timer.RP2350 is

   --  ALARM0 to ALARM3 are four words from offset 0x10
   type Alarm_Words is array (0 .. 3) of Unsigned_32
     with Volatile_Components;
   Alarms : Alarm_Words
     with Import, Address => TIMER0_Periph.ALARM0'Address;

   Taken : array (Alarm_Id) of Boolean := [others => False];

   package Enable_Bits is new RP2350_SVD.Atomic (INTE_Register);

   --  The alarm's bit in INTE, INTR and ARMED
   function Mask (Id : Alarm_Id) return UInt4 is (2**Natural (Id));

   function Enable_Bit (Id : Alarm_Id) return INTE_Register is
     (case Id is
         when 0 => (ALARM_0 => True, others => <>),
         when 1 => (ALARM_1 => True, others => <>),
         when 2 => (ALARM_2 => True, others => <>));

   procedure Claim (A : in out Alarm; Stat : out Status) is
   begin
      if Taken (A.Id) then
         Stat := In_Use;
         return;
      end if;
      Taken (A.Id) := True;
      A.Claimed := True;
      Cancel (A);
      Acknowledge (A);
      Enable_Bits.Set (TIMER0_Periph.INTE, Enable_Bit (A.Id));
      Stat := Ok;
   end Claim;

   procedure Set (A : in out Alarm; At_Time : Keel.Time.Time) is
   begin
      --  Writing the alarm word arms it; it fires when the low 32
      --  bits of the counter equal it
      Alarms (Natural (A.Id)) := Unsigned_32 (At_Time mod 2**32);
      if Keel.Time.Bare.Clock >= At_Time and then Is_Armed (A) then
         --  Written too late to match: fire it by hand
         Cancel (A);
         Keel.Interrupts.Set_Pending (IRQ_Of (A.Id));
      end if;
   end Set;

   procedure Cancel (A : in out Alarm) is
   begin
      --  ARMED: write 1 to disarm
      TIMER0_Periph.ARMED := (ARMED => Mask (A.Id), others => <>);
   end Cancel;

   function Is_Armed (A : Alarm) return Boolean is
     ((TIMER0_Periph.ARMED.ARMED and Mask (A.Id)) /= 0);

   procedure Acknowledge (A : in out Alarm) is
   begin
      --  INTR: write 1 to clear; the zeros change nothing
      TIMER0_Periph.INTR :=
        (case A.Id is
            when 0 => (ALARM_0 => True, others => <>),
            when 1 => (ALARM_1 => True, others => <>),
            when 2 => (ALARM_2 => True, others => <>));
   end Acknowledge;

   --  Alarms fit the signature: this fails to compile if not
   package Fits is new Keel.Timer.Alarm_Signature
     (Alarm, Set, Cancel, Is_Armed, Acknowledge);
   pragma Unreferenced (Fits);
end Keel.Timer.RP2350;
