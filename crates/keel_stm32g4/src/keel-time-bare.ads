--  SPDX-License-Identifier: Apache-2.0
--  Keel.Time.Bare: the time base on bare metal. On the STM32G474 it
--  is SysTick: it interrupts once a millisecond, its handler counts
--  milliseconds, and Clock adds the microseconds since the last
--  tick from SysTick's counter. The handler is keel_systick, which
--  Keel's vector table calls (Startup = "keel"). Every tick ends a
--  WFI, so Wake_At has nothing to do.
with Keel.Clock; use type Keel.Clock.Frequency;

package Keel.Time.Bare
  with Preelaborate
is
   --  Tick once a millisecond from the core clock, which runs at
   --  Reference. Start again after a clock switch. SysTick takes
   --  the least urgent priority, 15.
   procedure Start (Reference : Keel.Clock.Frequency)
     with Pre  => Reference mod 1_000_000 = 0
                  and then Reference in 1_000_000 .. 170_000_000,
          Post => Is_Started;
   function Is_Started return Boolean;

   --  Microseconds since Start; never more than Max_Clock
   function Clock return Time
     with Pre  => Is_Started,
          Post => Clock'Result <= Max_Clock;

   --  Sleep until Deadline: WFI until the last millisecond, which
   --  it spins. From the program, never a handler.
   procedure Wait_Until (Deadline : Time)
     with Pre => Is_Started;

   --  For Keel.Sync.Bare: the next tick, at most 1 ms away, ends
   --  any WFI, so there is nothing to arm
   procedure Wake_At (Deadline : Time)
     with Pre => Is_Started;
end Keel.Time.Bare;
