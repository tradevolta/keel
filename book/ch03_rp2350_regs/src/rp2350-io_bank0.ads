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

   type GPIO_Ctrl is record  --  defaults = reset values
      Funcsel : Function_Select := None;
      Reserved_5_11 : UInt7 := 0;
      Outover : Override := Normal;
      Oeover : OE_Override := Normal;
      Inover : Override := Normal;
      Reserved_18_27 : UInt10 := 0;
      Irqover : Override := Normal;
      Reserved_30_31 : UInt2 := 0;
   end record
     with Size => 32,
          Bit_Order => System.Low_Order_First,
          Volatile_Full_Access;

   for GPIO_Ctrl use record
      Funcsel        at 0 range  0 ..  4;
      Reserved_5_11  at 0 range  5 .. 11;
      Outover        at 0 range 12 .. 13;
      Oeover         at 0 range 14 .. 15;
      Inover         at 0 range 16 .. 17;
      Reserved_18_27 at 0 range 18 .. 27;
      Irqover        at 0 range 28 .. 29;
      Reserved_30_31 at 0 range 30 .. 31;
   end record;

   --  STATUS is read-only and left raw in this chapter.
   type GPIO_Pair is record
      Status : Register;
      Ctrl   : GPIO_Ctrl;
   end record
     with Size => 64;

   for GPIO_Pair use record
      Status at 0 range 0 .. 31;
      Ctrl   at 4 range 0 .. 31;
   end record;

   type GPIO_Array is array (Pin_Id) of GPIO_Pair
     with Component_Size => 64;

   type Peripheral is record  --  offsets 0x000 .. 0x17C only
      GPIO : GPIO_Array;
   end record;
end RP2350.IO_Bank0;
