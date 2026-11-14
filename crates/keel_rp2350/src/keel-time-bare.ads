--  SPDX-License-Identifier: Apache-2.0
--  Keel.Time.Bare: the time base on bare metal. On the RP2350 it is
--  TIMER0's 64-bit counter, one count per microsecond from the tick
--  generator, and alarm 3 wakes the core from WFI. Alarms 0 to 2
--  are free for Keel.Timer.RP2350.
with Keel.Clock; use type Keel.Clock.Frequency;

package Keel.Time.Bare
  with Preelaborate
is
   --  Take TIMER0 out of reset and tick it once per microsecond
   --  from clk_ref, which runs at Reference. Enables TIMER0_IRQ_3
   --  at the least urgent priority, 15.
   procedure Start (Reference : Keel.Clock.Frequency)
     with Pre  => Reference mod 1_000_000 = 0
                  and then Reference in 1_000_000 .. 511_000_000,
          Post => Is_Started;
   function Is_Started return Boolean;

   --  Microseconds since Start; never more than Max_Clock
   function Clock return Time
     with Pre  => Is_Started,
          Post => Clock'Result <= Max_Clock;

   --  Sleep until Deadline. From the program, never a handler.
   procedure Wait_Until (Deadline : Time)
     with Pre => Is_Started;

   --  Arm alarm 3 so that a WFI ends by Deadline, or sooner: at
   --  most 2**31 us ahead. If Deadline has passed, the alarm's
   --  interrupt is made pending at once. For Keel.Sync.Bare.
   procedure Wake_At (Deadline : Time)
     with Pre => Is_Started;
end Keel.Time.Bare;
