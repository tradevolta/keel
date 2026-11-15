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
