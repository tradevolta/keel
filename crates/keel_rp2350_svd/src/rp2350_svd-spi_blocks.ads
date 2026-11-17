--  SPDX-License-Identifier: Apache-2.0
--  Hand-written (not generated): both SPI controllers as one
--  register type. The generated code has SPI0 and SPI1 with the same
--  layout under two sets of type names (datasheet 12.3.5, Table
--  1152). Here SPI1 is SPI0's record at SPI1's base, so one driver
--  serves both through Blocks.
with RP2350_SVD.SPI0; use RP2350_SVD.SPI0;

package RP2350_SVD.SPI_Blocks
  with Preelaborate
is
   type Port is range 0 .. 1;

   SPI1_Periph : aliased SPI0_Peripheral
     with Import, Address => SPI1_Base;

   type Block_Access is access all SPI0_Peripheral;

   function Blocks (P : Port) return Block_Access is
     (if P = 0 then SPI0_Periph'Access else SPI1_Periph'Access);
end RP2350_SVD.SPI_Blocks;
