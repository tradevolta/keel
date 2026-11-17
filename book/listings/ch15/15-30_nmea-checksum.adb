function Checksum (S : String) return Byte is
   Sum : Byte := 0;
begin
   for I in S'Range loop
      Sum := Sum xor Byte (Character'Pos (S (I)));
      pragma Loop_Invariant (Sum = XOR_Of (S (S'First .. I)));
   end loop;
   return Sum;
end Checksum;
