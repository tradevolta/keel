procedure Fill (B : in out Buffer; E : Element)
  with Pre  => Owner (B) = Program,
       Post => Owner (B) = Program
               and then (for all I in Index => Get (B, I) = E);

--  To := From, element for element, by the processor
procedure Copy (From : Buffer; To : in out Buffer)
  with Pre  => Owner (From) = Program and then Owner (To) = Program,
       Post => Owner (To) = Program
               and then (for all I in Index =>
                           Get (To, I) = Get (From, I));

--  Hand B to the DMA. R is all of it, for a transfer's end.
procedure Lend (B : in out Buffer; R : out Region)
  with Pre  => Owner (B) = Program,
       Post => Owner (B) = Engine and then Lent (B) = R
               and then not Is_Register (R)
               and then Aligned (R, Size)
               and then Length (R) = Elements * Bytes (Size);

--  Take B back. Done is the receipt of a transfer that used it:
--  from a driver's Wait or Stop. What B holds now is whatever the
--  DMA left in it.
procedure Reclaim (B : in out Buffer; Done : Receipt)
  with Pre  => Owner (B) = Engine and then Covers (Done, Lent (B)),
       Post => Owner (B) = Program;

--  Read slot I while the DMA holds B. Only for a slot that the
--  transfer has finished with and won't come back to before the
--  value is used: a ring's settled half. Timing is the caller's
--  to get right; the driver can tell it when it fell behind.
function Peek (B : Buffer; I : Index) return Element
  with Pre => Owner (B) = Engine;
