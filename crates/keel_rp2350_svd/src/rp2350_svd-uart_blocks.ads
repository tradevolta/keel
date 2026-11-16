--  SPDX-License-Identifier: Apache-2.0
--  Hand-written (not generated): both UARTs as one register type.
--  The generated code has a package per instance, UART0 and UART1,
--  with the same layout under two sets of type names (datasheet
--  12.1.8, Table 1081). Here UART1 is UART0's record at UART1's base,
--  so one driver serves both through Blocks.
with RP2350_SVD.UART0; use RP2350_SVD.UART0;

package RP2350_SVD.UART_Blocks
  with Preelaborate
is
   type Port is range 0 .. 1;

   UART1_Periph : aliased UART0_Peripheral
     with Import, Address => UART1_Base;

   type Block_Access is access all UART0_Peripheral;
   type Block_Array is array (Port) of Block_Access;

   function Blocks (P : Port) return Block_Access is
     (if P = 0 then UART0_Periph'Access else UART1_Periph'Access);
end RP2350_SVD.UART_Blocks;
