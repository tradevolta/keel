--  SPDX-License-Identifier: Apache-2.0
--  The raw_masks mistakes with typed registers, plus a third: the
--  wrong function select for a pin. Two of the three do not compile.
with RP2350_SVD.IO_BANK0; use RP2350_SVD.IO_BANK0;
with RP2350_SVD.SIO_Pins; use RP2350_SVD.SIO_Pins;

procedure Typed_Masks is
   Green : constant Pin := 31;            --  meant 13
begin
   Output_Set ([Green => True, others => False]);
   Output_Set ([15 => True] + [15 => True]);
   IO_BANK0_Periph.GPIO13_CTRL := (FUNCSEL => sio_15, others => <>);
end Typed_Masks;
