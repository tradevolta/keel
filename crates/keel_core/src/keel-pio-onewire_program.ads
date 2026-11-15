--  SPDX-License-Identifier: Apache-2.0
--  The 1-Wire program: one pin, open drain. The pin's output level
--  stays 0, and SET PINDIRS pulls the bus low (1, an output) or lets
--  the pull-up raise it (0, an input). Run the machine at 1 MHz, so
--  a cycle is a microsecond, with autopull and autopush at 1 bit and
--  IN shifting left: each word put is one bit to send, and each word
--  got back holds one bit read, in bit 0.
--
--  The times are AN126's for standard speed. A slot is 70 us. A 1
--  pulls the bus low for 6 us and samples it at 15 us, so writing a
--  1 is also how a bit is read; a 0 pulls it low for 60 us and reads
--  back 0. Reset pulls the bus low for 482 us, samples the presence
--  pulse 70 us after letting go, and waits 410 us more. The driver
--  starts it with a forced JMP.
with Keel.PIO.Assembler;

package Keel.PIO.OneWire_Program
  with SPARK_Mode
is
   package Asm is new Keel.PIO.Assembler;
   use Asm;

   --  Labels
   Bit_Slot   : constant Address := 0;
   Write_Zero : constant Address := 6;
   Reset      : constant Address := 9;
   Hold_Low   : constant Address := 11;
   Hold_High  : constant Address := 17;

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
end Keel.PIO.OneWire_Program;
