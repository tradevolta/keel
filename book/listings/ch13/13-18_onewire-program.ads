Code : constant Program :=
  (Last          => 18,
   Code          =>
     [--  Bit_Slot: the next bit, from the TX FIFO
      Out_To (X, 1),
      Set (Pindirs, 1, Idle => 4),
      Jmp (Write_Zero, X_Zero),
      --  A 1, or a read: let go at 6 us, sample at 15
      Set (Pindirs, 0, Idle => 8),
      In_From (Pins, 1, Idle => 31),
      Jmp (Bit_Slot, Idle => 21),
      --  Write_Zero: let go at 60 us, read back 0
      In_From (Zeros, 1, Idle => 31),
      Nop (Idle => 21),
      Set (Pindirs, 0, Idle => 8),
      --  (wrap to Bit_Slot)
      --  Reset: low for 2 + 30 * 16 us
      Set (Pindirs, 1),
      Set (X, 29),
      Jmp (Hold_Low, X_Decrement, Idle => 15),
      --  Let go; a device answers by pulling the bus low
      Set (Pindirs, 0, Idle => 31),
      Nop (Idle => 31),
      Nop (Idle => 5),
      In_From (Pins, 1),
      --  Then 410 us more: 2 + 25 * 16 + 8
      Set (X, 24),
      Jmp (Hold_High, X_Decrement, Idle => 15),
      Jmp (Bit_Slot, Idle => 7)],
   Wrap_Target   => Bit_Slot,
   Wrap          => Write_Zero + 2,
   Side_Bits     => 0,
   Side_Optional => False);
