--  SPDX-License-Identifier: Apache-2.0
--  The UART dividers Keel knows, as data
package Keel.Bus.UART.Chip_Limits
  with Pure, SPARK_Mode
is
   --  RP2350 PL011: Baud = clk_peri / (16 * (IBRD + FBRD / 64)), so
   --  the divisor is 64 * IBRD + FBRD and Scale is 64 / 16 = 4.
   --  IBRD is 1 to 65 535, and FBRD must be 0 when IBRD is 65 535
   --  (datasheet 12.1.3.2.1; PL011 TRM 3.3.6).
   RP2350_PL011 : constant Divider_Limits :=
     (Scale       => 4,
      Min_Divisor => 64,
      Max_Divisor => 65_535 * 64);

   --  STM32G4 LPUART: Baud = 256 * fck / BRR, with BRR from 0x300
   --  to 0xF_FFFF, so fck is 3 to 4 096 times the baud rate
   --  (STM32CubeG4, stm32g4xx_ll_lpuart.h)
   STM32G4_LPUART : constant Divider_Limits :=
     (Scale       => 256,
      Min_Divisor => 16#300#,
      Max_Divisor => 16#F_FFFF#);
end Keel.Bus.UART.Chip_Limits;
