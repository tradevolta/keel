--  SPDX-License-Identifier: Apache-2.0
--  SIO (base 0xD000_0000): GPIO registers for GPIO0 .. GPIO31.
--  SIO has no atomic aliases; it has its own SET, CLR and XOR
--  registers instead (RP2350 datasheet, section 3.1).
package RP2350.SIO
  with Pure
is
   --  One bit per pin, so (15 => True, others => False) is GP15.
   type Pin_Mask is array (Low_Pin) of Boolean
     with Component_Size => 1, Size => 32, Volatile_Full_Access;

   type Peripheral is record
      CPUID        : Register;
      GPIO_In      : Pin_Mask;
      GPIO_Out     : Pin_Mask;
      GPIO_Out_Set : Pin_Mask;
      GPIO_Out_Clr : Pin_Mask;
      GPIO_Out_XOR : Pin_Mask;
      GPIO_OE      : Pin_Mask;
      GPIO_OE_Set  : Pin_Mask;
      GPIO_OE_Clr  : Pin_Mask;
      GPIO_OE_XOR  : Pin_Mask;
   end record;

   for Peripheral use record        --  the GPIO_HI_* gaps are skipped
      CPUID        at 16#00# range 0 .. 31;
      GPIO_In      at 16#04# range 0 .. 31;
      GPIO_Out     at 16#10# range 0 .. 31;
      GPIO_Out_Set at 16#18# range 0 .. 31;
      GPIO_Out_Clr at 16#20# range 0 .. 31;
      GPIO_Out_XOR at 16#28# range 0 .. 31;
      GPIO_OE      at 16#30# range 0 .. 31;
      GPIO_OE_Set  at 16#38# range 0 .. 31;
      GPIO_OE_Clr  at 16#40# range 0 .. 31;
      GPIO_OE_XOR  at 16#48# range 0 .. 31;
   end record;
end RP2350.SIO;
