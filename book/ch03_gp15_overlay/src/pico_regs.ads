--  SPDX-License-Identifier: Apache-2.0
--  The overlays placed on the real RP2350 addresses. Import stops
--  Ada from default-initializing them (that would write registers).
with System;
with RP2350.IO_Bank0;
with RP2350.Pads_Bank0;
with RP2350.Resets;
with RP2350.SIO;

package Pico_Regs
  with Preelaborate
is
   IO_Regs      : RP2350.IO_Bank0.Peripheral
     with Import, Address => System'To_Address (16#4002_8000#);
   Pads_Regs    : RP2350.Pads_Bank0.Peripheral
     with Import, Address => System'To_Address (16#4003_8000#);
   Pads_Clear   : RP2350.Pads_Bank0.Peripheral     --  +0x3000 alias
     with Import, Address => System'To_Address (16#4003_B000#);
   Resets_Regs  : RP2350.Resets.Peripheral
     with Import, Address => System'To_Address (16#4002_0000#);
   Resets_Clear : RP2350.Resets.Peripheral         --  +0x3000 alias
     with Import, Address => System'To_Address (16#4002_3000#);
   SIO_Regs     : RP2350.SIO.Peripheral
     with Import, Address => System'To_Address (16#D000_0000#);
end Pico_Regs;
