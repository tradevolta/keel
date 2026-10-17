--  SPDX-License-Identifier: Apache-2.0
--  The Chapter 3 overlays, placed at their RP2350 addresses.
with System;
with RP2350.IO_Bank0;
with RP2350.Pads_Bank0;
with RP2350.Resets;
with RP2350.SIO;

package Blinky_Regs
  with Preelaborate
is
   IO_Regs : RP2350.IO_Bank0.Peripheral
     with Import, Address => System'To_Address (16#4002_8000#);

   --  PADS_BANK0 through its SET (+0x2000) and CLR (+0x3000) aliases
   Pads_Set : RP2350.Pads_Bank0.Peripheral
     with Import, Address => System'To_Address (16#4003_A000#);
   Pads_Clear : RP2350.Pads_Bank0.Peripheral
     with Import, Address => System'To_Address (16#4003_B000#);

   --  RESETS, and RESETS through its CLR (+0x3000) alias
   Resets_Regs : RP2350.Resets.Peripheral
     with Import, Address => System'To_Address (16#4002_0000#);
   Resets_Clear : RP2350.Resets.Peripheral
     with Import, Address => System'To_Address (16#4002_3000#);

   SIO_Regs : RP2350.SIO.Peripheral
     with Import, Address => System'To_Address (16#D000_0000#);
end Blinky_Regs;
