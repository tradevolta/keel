--  SPDX-License-Identifier: Apache-2.0
with STM32G4_SVD;              use STM32G4_SVD;
with STM32G4_SVD.RCC;          use STM32G4_SVD.RCC;
with STM32G4_SVD.Timer_Fields; use STM32G4_SVD.Timer_Fields;

package body Keel.PWM.STM32G4 is

   --  What each timer is doing: how many outputs it drives, at
   --  which setting
   type Timer_State is record
      Users : Natural range 0 .. 4 := 0;
      Current : Setting;
   end record;

   State : array (Timer_Id) of Timer_State;
   Counter_Taken : Boolean := False;

   procedure Turn_On (Id : Timer_Id) is
   begin
      case Id is
         when TIM3 => RCC_Periph.RCC_APB1ENR1.TIM3EN := B_0x1;
         when TIM4 => RCC_Periph.RCC_APB1ENR1.TIM4EN := B_0x1;
      end case;
      --  The clock starts two cycles after its enable bit is set
      --  (RM0440 Rev 9, 7.2.17): read the bit back first
      declare
         Back : constant RCC_APB1ENR1_Register :=
           RCC_Periph.RCC_APB1ENR1
           with Unreferenced;
      begin
         null;
      end;
   end Turn_On;

   --  The two timers share one layout
   Regs : constant array (Timer_Id) of not null access Timer_Registers
     := [TIM3 => STM32G4_SVD.Timer_Fields.TIM3'Access,
         TIM4 => STM32G4_SVD.Timer_Fields.TIM4'Access];

   procedure Claim
     (O : in out Output; S : Setting; AF : Alternate_Function;
      Stat : out Status; Inverted : Boolean := False)
   is
      Now : Timer_State renames State (O.Timer);
      T : Timer_Registers renames Regs (O.Timer).all;

      --  The first user sets the counter: stopped, PSC and ARR, all
      --  levels 0, then UG loads them
      procedure Start_Timer is
      begin
         T.CR1 := (CEN => False, ARPE => True);
         T.PSC := UInt32 (Div (S) / 16 - 1);
         T.ARR := UInt32 (Top (S));
         T.CCR := [others => 0];
         T.EGR := (UG => True);
         T.CR1 := (CEN => True, ARPE => True);
      end Start_Timer;

      --  This channel: PWM mode 1, high while CNT < CCRx
      procedure Start_Channel is
         M : constant Channel_Mode :=
           (CCS => Compare, OCPE => True, OCM => PWM_1);
         E : CCER_Register := T.CCER;
      begin
         case O.Channel is
            when 1 => T.CCMR1 := (T.CCMR1 with delta First => M);
            when 2 => T.CCMR1 := (T.CCMR1 with delta Second => M);
            when 3 => T.CCMR2 := (T.CCMR2 with delta First => M);
            when 4 => T.CCMR2 := (T.CCMR2 with delta Second => M);
         end case;
         E.CC (Natural (O.Channel)) := (CCE => True, CCP => Inverted);
         T.CCER := E;
      end Start_Channel;
   begin
      if Now.Users > 0 and then Now.Current /= S then
         Stat := In_Use;
         return;
      end if;
      Reserve (O.Port, O.Pin, AF, Stat);
      if Stat /= Ok then
         return;
      end if;
      if Now.Users = 0 then
         Turn_On (O.Timer);
         Start_Timer;
      end if;
      Start_Channel;
      Now.Users := Now.Users + 1;
      Now.Current := S;
      O.S := S;
      O.Claimed := True;
   end Claim;

   procedure Set_Level (O : in out Output; Level : Count) is
   begin
      Regs (O.Timer).CCR (Natural (O.Channel)) := UInt32 (Level);
   end Set_Level;

   procedure Claim (C : in out Counter; Stat : out Status) is
   begin
      if Counter_Taken then
         Stat := In_Use;
         return;
      end if;
      Reserve (A, 0, 1, Stat);
      if Stat /= Ok then
         return;
      end if;
      RCC_Periph.RCC_APB1ENR1.TIM2EN := B_0x1;
      --  The clock starts two cycles after its enable bit is set
      --  (RM0440 Rev 9, 7.2.17): read the bit back first
      declare
         Back : constant RCC_APB1ENR1_Register :=
           RCC_Periph.RCC_APB1ENR1
           with Unreferenced;
      begin
         null;
      end;
      --  Channel 1 as an input from its own pin, rising edges, and
      --  external clock mode 1: each edge on TI1 is one count
      TIM2.CR1 := (CEN => False, ARPE => False);
      TIM2.CCMR1 := (First => (CCS => Input_TI1, others => <>),
                     Second => <>);
      TIM2.CCER := (CC => [others => (CCE => False, CCP => False)]);
      TIM2.SMCR := (SMS => External_Clock_1, TS => TI1FP1);
      TIM2.PSC := 0;
      TIM2.ARR := 16#FFFF_FFFF#;
      TIM2.EGR := (UG => True);
      Counter_Taken := True;
      C.Claimed := True;
   end Claim;

   procedure Start (C : in out Counter) is
      pragma Unreferenced (C);
   begin
      TIM2.CR1 := (CEN => False, ARPE => False);
      TIM2.CNT := 0;
      TIM2.SR := (UIF => False);
      TIM2.CR1 := (CEN => True, ARPE => False);
   end Start;

   procedure Stop (C : in out Counter) is
      pragma Unreferenced (C);
   begin
      TIM2.CR1 := (CEN => False, ARPE => False);
   end Stop;

   function Value (C : Counter) return Natural is
     (Natural (TIM2.CNT mod 2**31));

   function Wrapped (C : Counter) return Boolean is
     (TIM2.SR.UIF or else TIM2.CNT >= 2**31);
end Keel.PWM.STM32G4;
