--  SPDX-License-Identifier: Apache-2.0
--  The watchdogs Keel knows, as data
package Keel.Watchdog.Chip_Limits
  with Pure, SPARK_Mode
is
   --  RP2350: a 24-bit counter of 1 us ticks from the tick generator.
   --  LOAD = 0xFF_FFFF is about 16 s (datasheet 12.9.7).
   RP2350_Watchdog : constant Counter_Limits :=
     (Clock      => 1_000_000,
      Min_Shift  => 0,
      Max_Shift  => 0,
      Max_Reload => 16#FF_FFFF#,
      Plus_One   => False);

   --  STM32G4 IWDG: the LSI, 32 kHz typical, divided by 4 to 256,
   --  into a 12-bit counter that fires after Reload + 1 counts:
   --  125 us to 32.8 s (STM32CubeG4, stm32g4xx_hal_iwdg.c)
   STM32G4_IWDG : constant Counter_Limits :=
     (Clock      => 32_000,
      Min_Shift  => 2,
      Max_Shift  => 8,
      Max_Reload => 4_095,
      Plus_One   => True);
end Keel.Watchdog.Chip_Limits;
