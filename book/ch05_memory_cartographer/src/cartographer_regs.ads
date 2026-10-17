--  SPDX-License-Identifier: Apache-2.0
--  The Chapter 3 overlays at their RP2350 addresses, and the XIP
--  cache's two performance counters (RP2350 datasheet, 4.4.4).
with System;
with Interfaces;
with RP2350.IO_Bank0;
with RP2350.Pads_Bank0;
with RP2350.Resets;
with RP2350.SIO;

package Cartographer_Regs
  with Preelaborate
is
   IO_Regs : RP2350.IO_Bank0.Peripheral
     with Import, Address => System'To_Address (16#4002_8000#);
   Pads_Set : RP2350.Pads_Bank0.Peripheral
     with Import, Address => System'To_Address (16#4003_A000#);
   Pads_Clear : RP2350.Pads_Bank0.Peripheral
     with Import, Address => System'To_Address (16#4003_B000#);
   Resets_Regs : RP2350.Resets.Peripheral
     with Import, Address => System'To_Address (16#4002_0000#);
   Resets_Clear : RP2350.Resets.Peripheral
     with Import, Address => System'To_Address (16#4002_3000#);
   SIO_Regs : RP2350.SIO.Peripheral
     with Import, Address => System'To_Address (16#D000_0000#);

   --  XIP_CTRL CTR_HIT and CTR_ACC: they saturate, and any write
   --  clears them.
   XIP_Hits : Interfaces.Unsigned_32
     with Import, Atomic,
          Address => System'To_Address (16#400C_800C#);
   XIP_Accesses : Interfaces.Unsigned_32
     with Import, Atomic,
          Address => System'To_Address (16#400C_8010#);
end Cartographer_Regs;
