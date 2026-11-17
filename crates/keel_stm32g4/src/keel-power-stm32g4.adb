--  SPDX-License-Identifier: Apache-2.0
with Keel.Time.Bare;
with STM32G4_SVD;      use STM32G4_SVD;
with STM32G4_SVD.PWR;  use STM32G4_SVD.PWR;
with STM32G4_SVD.RCC;  use STM32G4_SVD.RCC;
with STM32G4_SVD.TAMP; use STM32G4_SVD.TAMP;

package body Keel.Power.STM32G4 is

   procedure Initialize is
   begin
      RCC_Periph.RCC_APB1ENR1.PWREN := STM32G4_SVD.RCC.B_0x1;
      RCC_Periph.RCC_APB1ENR1.RTCAPBEN := STM32G4_SVD.RCC.B_0x1;
      --  The clock starts two cycles after its enable bit is set
      --  (RM0440 Rev 9, 7.2.17): read the bit back first
      declare
         Back : constant RCC_APB1ENR1_Register :=
           RCC_Periph.RCC_APB1ENR1
           with Unreferenced;
      begin
         null;
      end;
      PWR_Periph.PWR_CR1.DBP := STM32G4_SVD.PWR.B_0x1;
   end Initialize;

   --  BKP0R to BKP7R, as HAL_RTCEx_BKUPWrite addresses them: one
   --  word apart from BKP0R
   function Retained (I : Retained_Index) return Word is
     (case I is
        when 0 => Word (TAMP_Periph.BKP0R),
        when 1 => Word (TAMP_Periph.BKP1R),
        when 2 => Word (TAMP_Periph.BKP2R),
        when 3 => Word (TAMP_Periph.BKP3R),
        when 4 => Word (TAMP_Periph.BKP4R),
        when 5 => Word (TAMP_Periph.BKP5R),
        when 6 => Word (TAMP_Periph.BKP6R),
        when 7 => Word (TAMP_Periph.BKP7R));

   procedure Retain (I : Retained_Index; Value : Word) is
      V : constant UInt32 := UInt32 (Value);
   begin
      case I is
         when 0 => TAMP_Periph.BKP0R := V;
         when 1 => TAMP_Periph.BKP1R := V;
         when 2 => TAMP_Periph.BKP2R := V;
         when 3 => TAMP_Periph.BKP3R := V;
         when 4 => TAMP_Periph.BKP4R := V;
         when 5 => TAMP_Periph.BKP5R := V;
         when 6 => TAMP_Periph.BKP6R := V;
         when 7 => TAMP_Periph.BKP7R := V;
      end case;
   end Retain;

   --  Keel.Time.Bare's own wait is the Sleep: WFI between ticks
   procedure Enter (M : Mode; Deadline : Keel.Time.Time) is
   begin
      if M /= Run then
         Keel.Time.Bare.Wait_Until (Deadline);
      end if;
   end Enter;

   Set_Deepest : Mode := Sleep;

   --  Only Sleep is real here: deeper limits act as Sleep
   procedure Set_Policy (P : Policy) is
   begin
      Set_Deepest := Mode'Min (P.Deepest, Sleep);
   end Set_Policy;

   function Current return Policy is
     ((Deepest => Set_Deepest, Wake => [others => 0]));

   package Idle_Here is new Keel.Power.Idle
     (Keel.Time.Bare.Clock, Enter, Current);

   procedure Wait_Until (Deadline : Keel.Time.Time) is
   begin
      Idle_Here.Wait_Until (Deadline);
   end Wait_Until;

   package Fits is new Keel.Time.Clock_Signature
     (Keel.Time.Bare.Clock, Wait_Until);
   pragma Unreferenced (Fits);
end Keel.Power.STM32G4;
