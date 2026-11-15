--  One end of a transfer
type Region is private;
No_Region : constant Region;

function Start (R : Region) return Integer_Address;
function Address_Of (R : Region) return System.Address;
--  In bytes. A register has none: the transfer doesn't move on.
function Length (R : Region) return Natural;
function Is_Register (R : Region) return Boolean;

--  A peripheral's data register, such as the ADC's FIFO
function Register (A : System.Address) return Region
  with Post => Is_Register (Register'Result)
               and then Length (Register'Result) = 0;

--  The start is a whole number of elements of Size
function Aligned (R : Region; Size : Element_Size) return Boolean is
  (Start (R) mod Integer_Address (Bytes (Size)) = 0);

--  Bytes First .. First + Bytes - 1 of a region of RAM
function Slice (R : Region; First, Bytes : Natural) return Region
  with Pre  => not Is_Register (R)
               and then First <= Length (R)
               and then Bytes <= Length (R) - First,
       Post => not Is_Register (Slice'Result)
               and then Length (Slice'Result) = Bytes;

--  A transfer's end in RAM can take Count elements of Size: they
--  fit in R from its start, or, with a ring of 2**Wrap bytes, R is
--  that ring exactly and starts on a multiple of its size
function Fits
  (R : Region; Size : Element_Size; N : Count; Wrap : Ring_Bits)
   return Boolean
is
  (not Is_Register (R)
   and then Aligned (R, Size)
   and then
     (if Wrap = 0 then N <= Length (R) / Bytes (Size)
      else Length (R) = Ring_Bytes (Wrap)
           and then Ring_Bytes (Wrap) >= Bytes (Size)
           and then Start (R) mod Integer_Address (Length (R)) = 0));
