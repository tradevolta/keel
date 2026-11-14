--  SPDX-License-Identifier: Apache-2.0
--  Keel.Interrupts: the NVIC for the RP2350's Cortex-M33 cores.
--  A handler for interrupt N is a parameterless procedure exported
--  as "keel_isr_N"; Keel's vector table points every entry it is
--  not given at keel_default_handler.
package Keel.Interrupts
  with Preelaborate, No_Elaboration_Code_All
is
   --  RP2350 datasheet, 3.2, Table 95: 52 interrupts per core
   type IRQ is range 0 .. 51;

   TIMER0_IRQ_0 : constant IRQ := 0;
   IO_IRQ_BANK0 : constant IRQ := 21;

   --  The M33 here has 4 priority bits (datasheet 3.7.2): 16 levels,
   --  0 the most urgent. The NVIC holds them in the top 4 bits.
   type Priority is range 0 .. 15;

   procedure Set_Priority (N : IRQ; P : Priority);
   function Priority_Of (N : IRQ) return Priority;

   procedure Enable (N : IRQ);
   procedure Disable (N : IRQ);
   function Is_Enabled (N : IRQ) return Boolean;

   procedure Set_Pending (N : IRQ);
   procedure Clear_Pending (N : IRQ);
   function Is_Pending (N : IRQ) return Boolean;
end Keel.Interrupts;
