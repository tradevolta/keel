--  SPDX-License-Identifier: Apache-2.0
--  Hand-written (not generated): DMA1's eight channels as an array,
--  and DMAMUX1's request lines for them. The generated code names
--  each channel's registers apart (CCR1 ... CMAR8), but every
--  channel has the same four registers, 0x14 bytes apart from
--  DMA1 + 0x08 (the device's SVD file). ISR and IFCR hold four
--  flags a channel, from bit 4 * (n - 1): GIF, TCIF, HTIF, TEIF.
--  DMAMUX1 channel n - 1 is DMA1 channel n's request line, at
--  DMAMUX1 + 4 * (n - 1) (ST's HAL, stm32g4xx_hal_dma.c).
with System.Storage_Elements; use System.Storage_Elements;
with STM32G4_SVD.DMA;    use STM32G4_SVD.DMA;
with STM32G4_SVD.DMAMUX; use STM32G4_SVD.DMAMUX;

package STM32G4_SVD.DMA_Channels
  with Preelaborate
is
   type Channel is range 1 .. 8;

   --  The last 4 bytes of each 20 are not a register
   pragma Warnings (Off, "*bits of*unused");
   type Channel_Registers is record
      CCR   : CCR_Register;
      CNDTR : CNDTR_Register;
      CPAR  : UInt32;
      CMAR  : UInt32;
   end record
     with Volatile, Size => 20 * 8;

   for Channel_Registers use record
      CCR   at 16#0# range 0 .. 31;
      CNDTR at 16#4# range 0 .. 31;
      CPAR  at 16#8# range 0 .. 31;
      CMAR  at 16#C# range 0 .. 31;
   end record;
   pragma Warnings (On, "*bits of*unused");

   type Channel_Array is array (Channel) of aliased Channel_Registers
     with Component_Size => 20 * 8;

   Channels : Channel_Array
     with Import, Address => DMA1_Base + 16#8#;

   --  The flags, as words: four bits a channel
   Flags : UInt32
     with Import, Volatile_Full_Access, Address => DMA1_Base;
   Clear_Flags : UInt32
     with Import, Volatile_Full_Access, Address => DMA1_Base + 16#4#;

   type Request_Array is array (Channel) of aliased C0CR_Register
     with Component_Size => 32;

   Requests : Request_Array
     with Import, Address => DMAMUX_Base;
end STM32G4_SVD.DMA_Channels;
