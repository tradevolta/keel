--  SPDX-License-Identifier: Apache-2.0
--  Keel.Interrupts: the NVIC for the STM32G474's Cortex-M4.
--  A handler for interrupt N is a parameterless procedure exported
--  as "keel_isr_N"; Keel's vector table points every entry it is
--  not given at keel_default_handler.
package Keel.Interrupts
  with Preelaborate, No_Elaboration_Code_All
is
   --  The STM32G474's 102 interrupts (its SVD file numbers 0 .. 101)
   type IRQ is range 0 .. 101;

   EXTI0 : constant IRQ := 6;
   EXTI1 : constant IRQ := 7;
   EXTI4 : constant IRQ := 10;

   --  4 priority bits (the device's SVD file, nvicPrioBits): 16
   --  levels, 0 the most urgent, in the top 4 bits of each byte.
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
