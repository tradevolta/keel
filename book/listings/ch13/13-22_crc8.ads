--  The definition: one bit at a time, N bits of B into CRC
function Shift (CRC, B : Byte; N : Natural) return Byte is
  (if N = 0 then CRC
   else Shift ((if (CRC xor B) mod 2 = 1
                then (CRC / 2) xor 16#8C#
                else CRC / 2),
               B / 2, N - 1))
  with Pre                => N <= 8,
       Subprogram_Variant => (Decreases => N);

function Update (CRC, B : Byte) return Byte is
  (Shift (CRC, B, 8));

--  The CRC of Data, byte by byte from the left
function CRC8_Of (Data : Byte_Array) return Byte is
  (if Data'Length = 0 then 0
   else Update (CRC8_Of (Data (Data'First .. Data'Last - 1)),
                Data (Data'Last)))
  with Ghost,
       Subprogram_Variant => (Decreases => Data'Length);

--  The CRC as a loop: what a driver runs, proved to match
function CRC8 (Data : Byte_Array) return Byte
  with Post => CRC8'Result = CRC8_Of (Data);

--  The CRC of zeros is 0, so bytes read from a line held low pass
--  it. A reader checks for them first.
function All_Zero (Data : Byte_Array) return Boolean is
  (for all D of Data => D = 0);
