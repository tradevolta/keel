--  SPDX-License-Identifier: Apache-2.0
--  RESETS (base 0x4002_0000): one bit per peripheral, 1 = in reset.
--  Bit order from the RP2350 datasheet, RESETS: RESET register.
package RP2350.Resets
  with Pure
is
   type Peripheral_Id is
     (ADC, Bus_Ctrl, DMA, HSTX, I2C0, I2C1, IO_Bank0, IO_QSPI, JTAG,
      Pads_Bank0, Pads_QSPI, PIO0, PIO1, PIO2, PLL_Sys, PLL_USB, PWM,
      SHA256, SPI0, SPI1, Sys_Cfg, Sys_Info, TBMAN, Timer0, Timer1,
      TRNG, UART0, UART1, USB_Ctrl, Reserved_29, Reserved_30,
      Reserved_31);                 --  bits 0 .. 31, every bit named

   type Reset_Bits is array (Peripheral_Id) of Boolean
     with Component_Size => 1, Size => 32, Volatile_Full_Access;

   type Peripheral is record
      Reset      : Reset_Bits;      --  0x000, RW
      WD_Sel     : Reset_Bits;      --  0x004, RW
      Reset_Done : Reset_Bits;      --  0x008, RO: True = out of reset
   end record;

   for Peripheral use record
      Reset      at 0 range 0 .. 31;
      WD_Sel     at 4 range 0 .. 31;
      Reset_Done at 8 range 0 .. 31;
   end record;
end RP2350.Resets;
