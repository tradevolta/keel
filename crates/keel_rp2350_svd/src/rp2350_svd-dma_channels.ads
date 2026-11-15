--  SPDX-License-Identifier: Apache-2.0
--  Hand-written (not generated): the DMA's 16 channels as an array.
--  The generated code gives each channel's registers their own types
--  (CH0_READ_ADDR ... CH15_AL3_READ_ADDR_TRIG), but every channel has
--  the same 64 bytes from 0x5000_0000 + 0x40 * n (RP2350 datasheet,
--  12.6.10). The SVD lists one value for RING_SIZE, RING_NONE, so
--  the generated CTRL can't hold a ring; CTRL here has RING_SIZE and
--  TREQ_SEL as numbers (12.6.2.3, Table 1254).
with RP2350_SVD.DMA; use RP2350_SVD.DMA;

package RP2350_SVD.DMA_Channels
  with Preelaborate
is
   type Channel is range 0 .. 15;

   type CTRL_Register is record
      EN             : Boolean := False;
      HIGH_PRIORITY  : Boolean := False;
      DATA_SIZE      : CH0_CTRL_TRIG_DATA_SIZE_Field := SIZE_BYTE;
      INCR_READ      : Boolean := False;
      INCR_READ_REV  : Boolean := False;
      INCR_WRITE     : Boolean := False;
      INCR_WRITE_REV : Boolean := False;
      --  Wrap on 2**RING_SIZE bytes; 0: no ring
      RING_SIZE      : UInt4 := 0;
      --  True: the ring is on the write address
      RING_SEL       : Boolean := False;
      --  Its own number: no chain
      CHAIN_TO       : UInt4 := 0;
      --  0 to 54: a DREQ; 59 to 62: a pacing timer; 63: none
      TREQ_SEL       : UInt6 := 0;
      IRQ_QUIET      : Boolean := False;
      BSWAP          : Boolean := False;
      SNIFF_EN       : Boolean := False;
      BUSY           : Boolean := False;
      Reserved_27_28 : UInt2 := 0;
      --  Write 1 to clear
      WRITE_ERROR    : Boolean := False;
      READ_ERROR     : Boolean := False;
      AHB_ERROR      : Boolean := False;
   end record
     with Volatile_Full_Access, Object_Size => 32,
          Bit_Order => System.Low_Order_First;

   for CTRL_Register use record
      EN             at 0 range 0 .. 0;
      HIGH_PRIORITY  at 0 range 1 .. 1;
      DATA_SIZE      at 0 range 2 .. 3;
      INCR_READ      at 0 range 4 .. 4;
      INCR_READ_REV  at 0 range 5 .. 5;
      INCR_WRITE     at 0 range 6 .. 6;
      INCR_WRITE_REV at 0 range 7 .. 7;
      RING_SIZE      at 0 range 8 .. 11;
      RING_SEL       at 0 range 12 .. 12;
      CHAIN_TO       at 0 range 13 .. 16;
      TREQ_SEL       at 0 range 17 .. 22;
      IRQ_QUIET      at 0 range 23 .. 23;
      BSWAP          at 0 range 24 .. 24;
      SNIFF_EN       at 0 range 25 .. 25;
      BUSY           at 0 range 26 .. 26;
      Reserved_27_28 at 0 range 27 .. 28;
      WRITE_ERROR    at 0 range 29 .. 29;
      READ_ERROR     at 0 range 30 .. 30;
      AHB_ERROR      at 0 range 31 .. 31;
   end record;

   --  Alias 0 (0x00 to 0x0C), whose CTRL_TRIG starts the channel,
   --  and alias 1's CTRL (0x10), which doesn't (12.6.3.1). The other
   --  aliases fill the rest of the 64 bytes, unused here.
   pragma Warnings (Off, "*bits of*unused");
   type Channel_Registers is record
      READ_ADDR   : UInt32;
      WRITE_ADDR  : UInt32;
      TRANS_COUNT : CH0_TRANS_COUNT_Register;
      CTRL_TRIG   : CTRL_Register;
      AL1_CTRL    : CTRL_Register;
   end record
     with Volatile, Size => 64 * 8;

   for Channel_Registers use record
      READ_ADDR   at 16#00# range 0 .. 31;
      WRITE_ADDR  at 16#04# range 0 .. 31;
      TRANS_COUNT at 16#08# range 0 .. 31;
      CTRL_TRIG   at 16#0C# range 0 .. 31;
      AL1_CTRL    at 16#10# range 0 .. 31;
   end record;
   pragma Warnings (On, "*bits of*unused");

   type Channel_Array is array (Channel) of Channel_Registers;

   Channels : Channel_Array
     with Import, Address => DMA_Periph'Address;
end RP2350_SVD.DMA_Channels;
