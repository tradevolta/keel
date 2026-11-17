--  The frame: a start bit, the data bits least significant first,
--  an optional parity bit, one or two stop bits
type Data_Bits is range 7 .. 8;
type Parity is (None, Even, Odd);
type Stop_Bits is range 1 .. 2;

type Format is record
   Bits  : Data_Bits := 8;
   Check : Parity    := None;
   Stops : Stop_Bits := 1;
end record;

--  8N1: what nearly everything speaks
Eight_N_One : constant Format := (others => <>);

function Frame_Bits (F : Format) return Positive is
  (1 + Natural (F.Bits) + (if F.Check = None then 0 else 1)
   + Natural (F.Stops));

subtype Baud_Rate is Positive range 300 .. 10_000_000;

--  Characters a second, at most, on a busy line
function Characters_Per_Second
  (B : Baud_Rate; F : Format) return Positive
is (B / Frame_Bits (F));
