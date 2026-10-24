--  SPDX-License-Identifier: Apache-2.0
--  The C way: registers as 32-bit words and masks as numbers. Every
--  line type-checks without the driver rule, and two of them are
--  wrong. The pragma is the driver rule from ../gnat.adc, which
--  bad.gpr does not load.
pragma Restrictions (No_Use_Of_Entity => RP2350_SVD.UInt32);
with RP2350_SVD;     use RP2350_SVD;
with RP2350_SVD.SIO; use RP2350_SVD.SIO;

procedure Raw_Masks is
   Red   : constant UInt32 := 2**15;
   Amber : constant UInt32 := 2**14;
   Green : constant UInt32 := 2**31;      --  meant 2**13
begin
   SIO_Periph.GPIO_OE_SET := Red or Amber or Green;
   SIO_Periph.GPIO_OUT_SET := Red + Red;  --  GP16, not GP15
end Raw_Masks;
