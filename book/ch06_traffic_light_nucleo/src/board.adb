--  SPDX-License-Identifier: Apache-2.0
--  The NUCLEO-G474RE board: red on PA0 (Arduino A0), amber on PA1
--  (A1), green on PA4 (A2), and TIM2 counting microseconds.
with STM32G4_SVD;           use STM32G4_SVD;
with STM32G4_SVD.GPIO;      use STM32G4_SVD.GPIO;
with STM32G4_SVD.Pin_Modes; use STM32G4_SVD.Pin_Modes;
with STM32G4_SVD.RCC;       use STM32G4_SVD.RCC;
with STM32G4_SVD.TIM;       use STM32G4_SVD.TIM;

package body Board is

   Pin_Of : constant array (Lamp) of Pin :=
     [Red => 0, Amber => 1, Green => 4];

   --  TIM2 runs from PCLK1: SYSCLK (170 MHz, see alire.toml) with the
   --  AHB and APB1 prescalers at 1.
   Timer_Clock : constant Hertz := "170 MHz";
   Tick_Rate   : constant Hertz := "1 MHz";

   procedure Initialize is
   begin
      RCC_Periph.RCC_AHB2ENR.GPIOAEN := B_0x1;    --  clock enabled
      RCC_Periph.RCC_APB1ENR1.TIM2EN := B_0x1;

      for L in Lamp loop
         Set_Mode (GPIOA_Periph, Pin_Of (L), Output);
      end loop;

      --  The prescaler divides by PSC + 1. It is buffered: the update
      --  event (UG) loads it.
      TIM2_Periph.TIM2_PSC := UInt16 (Timer_Clock / Tick_Rate) - 1;
      TIM2_Periph.TIM2_EGR := (UG => B_0x1, others => <>);
      TIM2_Periph.TIM2_CR1.CEN := B_0x1;
   end Initialize;

   procedure Show (Lamps : Lamp_Set) is
      On, Off : BSRR_BS_Field_Array := [others => False];
   begin
      for L in Lamp loop
         On (Integer (Pin_Of (L))) := Lamps (L);
         Off (Integer (Pin_Of (L))) := not Lamps (L);
      end loop;
      --  BSRR sets and clears pins in one write, like the RP2350's
      --  SIO SET and CLR registers.
      GPIOA_Periph.BSRR :=
        (BS => (As_Array => True, Arr => On),
         BR => (As_Array => True, Arr => BSRR_BR_Field_Array (Off)));
   end Show;

   --  CNT holds the low 31 bits of the 32-bit counter (bit 31 is
   --  UIFCPY_CNT in the SVD). Differences modulo 2**31 are still exact.
   type Count is mod 2**31;

   function Now return Count is (Count (TIM2_Periph.TIM2_CNT.CNT));

   procedure Wait (D : Micro_Seconds) is
      Start : constant Count := Now;
   begin
      while Now - Start < Count (D) loop
         null;
      end loop;
   end Wait;
end Board;
