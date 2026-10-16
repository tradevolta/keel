--  SPDX-License-Identifier: Apache-2.0
--  Compile-time layout checks against the datasheet. This unit is
--  never linked into a program: compiling it is the test.
with RP2350.IO_Bank0;
with RP2350.Pads_Bank0;
with RP2350.SIO;

package RP2350.Layout is
   IO   : IO_Bank0.Peripheral;
   Pads : Pads_Bank0.Peripheral;
   SIO  : RP2350.SIO.Peripheral;

   pragma Compile_Time_Error
     (IO_Bank0.GPIO_Ctrl'Size /= 32, "GPIO_CTRL is not 32 bits");
   pragma Compile_Time_Error
     (IO.GPIO (15).Ctrl.Oeover'Position * 8
        + IO.GPIO (15).Ctrl.Oeover'First_Bit /= 14,
      "GPIO_CTRL.OEOVER does not start at bit 14");
   pragma Compile_Time_Error
     (IO_Bank0.GPIO_Array'Component_Size * 15 / 8
        + IO.GPIO (15).Ctrl'Position /= 16#7C#,
      "GPIO15_CTRL is not at offset 0x07C");
   pragma Compile_Time_Error
     (Pads.GPIO'Position + 15 * 4 /= 16#40#,
      "PADS_BANK0 GPIO15 is not at offset 0x040");
   pragma Compile_Time_Error
     (SIO.GPIO_Out_XOR'Position /= 16#28#
        or else SIO.GPIO_OE_Set'Position /= 16#38#,
      "SIO GPIO registers out of place");
end RP2350.Layout;
