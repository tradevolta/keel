function Read (Reg : Offset) return UInt32
  with Inline;

--  Write Value, with the password if Reg is protected
procedure Write (Reg : Offset; Value : UInt32)
  with Inline,
       Pre => (if Reg in Protected_Offset then Value < 2**16);

--  Set or clear the bits that are 1 in Bits, through the atomic
--  aliases, with the password if Reg is protected (the Pico SDK's
--  powman_set_bits and powman_clear_bits do the same)
procedure Set_Bits (Reg : Offset; Bits : UInt32)
  with Inline,
       Pre => (if Reg in Protected_Offset then Bits < 2**16);
procedure Clear_Bits (Reg : Offset; Bits : UInt32)
  with Inline,
       Pre => (if Reg in Protected_Offset then Bits < 2**16);
