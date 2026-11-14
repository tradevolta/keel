--  SPDX-License-Identifier: Apache-2.0
--  Hand-written (not generated): the general-purpose timers TIM2,
--  TIM3 and TIM4 as one typed layout. svd2ada makes most of their
--  fields enumerations of a few named codes (B_0x0, B_0x1 ...) and
--  splits OCxM, SMS and TS across two fields, so the PWM driver
--  would spell every mode as bits. RM0440 Rev 9, 29.6 (TIM2 to TIM5
--  registers), gives the layout used here. TIM2's CNT and ARR are
--  32 bits wide, TIM3's and TIM4's 16.
with System;

package STM32G4_SVD.Timer_Fields
  with Preelaborate
is
   type CR1_Register is record
      CEN  : Boolean := False;  --  count
      ARPE : Boolean := False;  --  ARR takes effect at the update
   end record
     with Volatile_Full_Access, Object_Size => 32,
          Bit_Order => System.Low_Order_First;
   for CR1_Register use record
      CEN  at 0 range 0 .. 0;
      ARPE at 0 range 7 .. 7;
   end record;

   --  SMS = 7 with TS = TI1FP1 (5): external clock mode 1, the
   --  counter counts edges on channel 1's pin
   type Slave_Mode is (Off, External_Clock_1) with Size => 3;
   for Slave_Mode use (Off => 0, External_Clock_1 => 7);
   type Trigger is (ITR0, TI1FP1) with Size => 3;
   for Trigger use (ITR0 => 0, TI1FP1 => 5);

   type SMCR_Register is record
      SMS : Slave_Mode := Off;
      TS  : Trigger := ITR0;
   end record
     with Volatile_Full_Access, Object_Size => 32,
          Bit_Order => System.Low_Order_First;
   for SMCR_Register use record
      SMS at 0 range 0 .. 2;
      TS  at 0 range 4 .. 6;
   end record;

   type SR_Register is record
      UIF : Boolean := False;  --  the counter overflowed
   end record
     with Volatile_Full_Access, Object_Size => 32,
          Bit_Order => System.Low_Order_First;
   for SR_Register use record
      UIF at 0 range 0 .. 0;
   end record;

   type EGR_Register is record
      UG : Boolean := False;  --  load PSC, ARR and CCRs now
   end record
     with Volatile_Full_Access, Object_Size => 32,
          Bit_Order => System.Low_Order_First;
   for EGR_Register use record
      UG at 0 range 0 .. 0;
   end record;

   --  CCxS: what a channel does, compare (an output) or capture.
   --  OCxM: PWM mode 1 is high while CNT < CCRx. OCxM's fourth bit
   --  is elsewhere in the register and stays 0.
   type Channel_Use is (Compare, Input_TI1) with Size => 2;
   for Channel_Use use (Compare => 0, Input_TI1 => 1);
   type Compare_Mode is (Frozen, PWM_1) with Size => 3;
   for Compare_Mode use (Frozen => 0, PWM_1 => 6);

   type Channel_Mode is record
      CCS  : Channel_Use := Compare;
      OCPE : Boolean := False;  --  CCRx takes effect at the update
      OCM  : Compare_Mode := Frozen;
   end record
     with Size => 8, Bit_Order => System.Low_Order_First;
   for Channel_Mode use record
      CCS  at 0 range 0 .. 1;
      OCPE at 0 range 3 .. 3;
      OCM  at 0 range 4 .. 6;
   end record;

   --  CCMR1 holds channels 1 and 2, CCMR2 channels 3 and 4
   type CCMR_Register is record
      First, Second : Channel_Mode;
   end record
     with Volatile_Full_Access, Object_Size => 32,
          Bit_Order => System.Low_Order_First;
   for CCMR_Register use record
      First  at 0 range 0 .. 7;
      Second at 0 range 8 .. 15;
   end record;

   --  CCxE: the channel drives its pin; CCxP: inverted (or, for an
   --  input, falling edges)
   type Channel_Enable is record
      CCE : Boolean := False;
      CCP : Boolean := False;
   end record
     with Size => 4, Bit_Order => System.Low_Order_First;
   for Channel_Enable use record
      CCE at 0 range 0 .. 0;
      CCP at 0 range 1 .. 1;
   end record;

   type Channel_Enables is array (1 .. 4) of Channel_Enable
     with Component_Size => 4, Size => 16;

   type CCER_Register is record
      CC : Channel_Enables;
   end record
     with Volatile_Full_Access, Object_Size => 32,
          Bit_Order => System.Low_Order_First;
   for CCER_Register use record
      CC at 0 range 0 .. 15;
   end record;

   type Compare_Values is array (1 .. 4) of UInt32
     with Volatile_Components;

   type Timer_Registers is record
      CR1   : CR1_Register;
      SMCR  : SMCR_Register;
      SR    : SR_Register;
      EGR   : EGR_Register;
      CCMR1 : CCMR_Register;
      CCMR2 : CCMR_Register;
      CCER  : CCER_Register;
      CNT   : UInt32 with Volatile;
      PSC   : UInt32 with Volatile;
      ARR   : UInt32 with Volatile;
      CCR   : Compare_Values;
   end record;
   for Timer_Registers use record
      CR1   at 16#00# range 0 .. 31;
      SMCR  at 16#08# range 0 .. 31;
      SR    at 16#10# range 0 .. 31;
      EGR   at 16#14# range 0 .. 31;
      CCMR1 at 16#18# range 0 .. 31;
      CCMR2 at 16#1C# range 0 .. 31;
      CCER  at 16#20# range 0 .. 31;
      CNT   at 16#24# range 0 .. 31;
      PSC   at 16#28# range 0 .. 31;
      ARR   at 16#2C# range 0 .. 31;
      CCR   at 16#34# range 0 .. 127;
   end record;

   TIM2 : aliased Timer_Registers
     with Import, Address => TIM2_Base;
   TIM3 : aliased Timer_Registers
     with Import, Address => TIM3_Base;
   TIM4 : aliased Timer_Registers
     with Import, Address => TIM4_Base;
end STM32G4_SVD.Timer_Fields;
