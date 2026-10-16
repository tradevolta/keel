--  SPDX-License-Identifier: Apache-2.0
--  PADS_BANK0 (base 0x4003_8000): electrical control of each pad.
--  Fields from the RP2350 datasheet, PADS_BANK0 GPIOx register tables.
with System;

package RP2350.Pads_Bank0
  with Pure
is
   type Drive_Strength is (Drive_2mA, Drive_4mA, Drive_8mA, Drive_12mA)
     with Size => 2;

   type Pad_Control is record       --  defaults = reset value 0x116
      Slew_Fast      : Boolean        := False;
      Schmitt        : Boolean        := True;
      Pull_Down      : Boolean        := True;
      Pull_Up        : Boolean        := False;
      Drive          : Drive_Strength := Drive_4mA;
      Input_Enable   : Boolean        := False;
      Output_Disable : Boolean        := False;
      Isolate        : Boolean        := True;
      Reserved_9_31  : UInt23         := 0;
   end record
     with Size      => 32,
          Bit_Order => System.Low_Order_First,
          Volatile_Full_Access;

   for Pad_Control use record
      Slew_Fast      at 0 range 0 ..  0;   --  SLEWFAST
      Schmitt        at 0 range 1 ..  1;   --  SCHMITT
      Pull_Down      at 0 range 2 ..  2;   --  PDE
      Pull_Up        at 0 range 3 ..  3;   --  PUE
      Drive          at 0 range 4 ..  5;   --  DRIVE
      Input_Enable   at 0 range 6 ..  6;   --  IE
      Output_Disable at 0 range 7 ..  7;   --  OD
      Isolate        at 0 range 8 ..  8;   --  ISO
      Reserved_9_31  at 0 range 9 .. 31;
   end record;

   --  No bit set: the starting point for SET/CLR/XOR alias masks.
   No_Bits : constant Pad_Control :=
     (Drive => Drive_2mA, Reserved_9_31 => 0, others => False);

   type Pad_Array is array (Pin_Id) of Pad_Control
     with Component_Size => 32;

   type Peripheral is record
      Voltage_Select : Register;    --  0x000
      GPIO           : Pad_Array;   --  0x004 .. 0x0C0
   end record;

   for Peripheral use record
      Voltage_Select at 16#00# range 0 .. 31;
      GPIO           at 16#04# range 0 .. 48 * 32 - 1;
   end record;
end RP2350.Pads_Bank0;
