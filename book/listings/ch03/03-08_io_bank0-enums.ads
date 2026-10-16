--  SPDX-License-Identifier: Apache-2.0
--  IO_BANK0 (base 0x4002_8000): per-pin STATUS and CTRL registers.
--  Fields from the RP2350 datasheet, GPIOx_CTRL register tables.
with System;

package RP2350.IO_Bank0
  with Pure
is
   type Function_Select is
     (F0, SPI, UART, I2C, PWM, SIO, PIO0, PIO1, PIO2, F9, USB,
      UART_Alt, None)
     with Size => 5;
   for Function_Select use
     (F0 => 0, SPI => 1, UART => 2, I2C => 3, PWM => 4, SIO => 5,
      PIO0 => 6, PIO1 => 7, PIO2 => 8, F9 => 9, USB => 10,
      UART_Alt => 11, None => 31);

   type Override is (Normal, Invert, Drive_Low, Drive_High)
     with Size => 2;  --  OUTOVER, INOVER, IRQOVER
   type OE_Override is (Normal, Invert, Disable, Enable)
     with Size => 2;  --  OEOVER
