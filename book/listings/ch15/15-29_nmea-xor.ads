--  The definition: every character XORed in, left to right
function XOR_Of (S : String) return Byte is
  (if S'Length = 0 then 0
   else XOR_Of (S (S'First .. S'Last - 1))
        xor Byte (Character'Pos (S (S'Last))))
  with Ghost,
       Subprogram_Variant => (Decreases => S'Length);

--  The same as a loop: what a parser runs
function Checksum (S : String) return Byte
  with Post => Checksum'Result = XOR_Of (S);
