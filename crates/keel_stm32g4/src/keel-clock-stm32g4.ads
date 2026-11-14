--  SPDX-License-Identifier: Apache-2.0
--  Keel.Clock on the STM32G474: SYSCLK from HSI16 or from the main
--  PLL's R output, with the flash wait states and the core voltage
--  mode each frequency needs, and SYSCLK / 16 on the MCO pin (PA8).
with Keel.Clock.Chip_Limits;

package Keel.Clock.STM32G4
  with Preelaborate
is
   --  The internal 16 MHz RC oscillator, SYSCLK after reset
   HSI16 : constant Frequency := 16_000_000;
   PLL : PLL_Limits renames Chip_Limits.STM32G474_PLL;

   --  What Keel last set SYSCLK to; HSI16 until then
   function Sys_Frequency return Frequency;

   --  SYSCLK from HSI16; the PLL is left running
   procedure Run_From_HSI16
     with Post => Sys_Frequency = HSI16;

   --  SYSCLK from the PLL at Setting. SYSCLK runs from HSI16 while
   --  the PLL relocks. Timeout: no lock; SYSCLK stays on HSI16.
   procedure Run_From_PLL (Setting : PLL_Config; Stat : out Status)
     with Pre  => Limits (Setting) = PLL
                  and then Reference (Setting) = HSI16,
          Post => Sys_Frequency =
                    (if Stat = Ok then Output (Setting) else HSI16);

   --  SYSCLK / 16 on PA8 (MCO, AF0), from now on. 16 is MCOPRE's
   --  largest divider. In_Use: PA8 has another owner.
   procedure Start_Clock_Out (Stat : out Status);
end Keel.Clock.STM32G4;
