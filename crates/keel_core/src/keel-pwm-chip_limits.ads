--  SPDX-License-Identifier: Apache-2.0
--  The PWM counters of the chips Keel runs on, as data, next to
--  Keel.Clock.Chip_Limits and for the same reason: the proof and
--  the host tests can see them.
package Keel.PWM.Chip_Limits
  with Pure, SPARK_Mode
is
   --  RP2350 datasheet 12.5.2.4 and 12.5.2.6: an 8.4 fractional
   --  divider from 1.0 to 256.0, a 16-bit counter, phase-correct
   --  mode. Top_Max leaves room for the 100 % level.
   RP2350_Slice : constant Counter_Limits :=
     (Div_Min => 16, Div_Max => 4_096, Div_Step => 1,
      Top_Max => 65_534, Phase_Correct => True);

   --  RM0440 29.4 (TIM2 to TIM5): PSC divides by 1 to 65_536 in
   --  whole steps, and TIM3's and TIM4's ARR is 16 bits. Their
   --  center-aligned mode isn't the RP2350's phase-correct mode,
   --  so Keel doesn't offer it.
   STM32G474_Timer : constant Counter_Limits :=
     (Div_Min => 16, Div_Max => 2**20, Div_Step => 16,
      Top_Max => 65_534, Phase_Correct => False);
end Keel.PWM.Chip_Limits;
