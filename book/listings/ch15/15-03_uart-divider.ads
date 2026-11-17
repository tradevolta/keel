--  The baud-rate divider as data. A chip makes
--  Baud = Clock * Scale / Divisor, with Divisor a whole number
--  from Min_Divisor to Max_Divisor.
type Divider_Limits is record
   Scale       : Positive range 1 .. 256;
   Min_Divisor : Positive range 1 .. 2**24;
   Max_Divisor : Positive range 1 .. 2**24;
end record
  with Predicate => Min_Divisor <= Max_Divisor;

subtype Clock_Hz is Positive range 1_000_000 .. 500_000_000;
subtype Divisor is Natural range 0 .. 2**24;

--  The divisor nearest Clock * Scale / Baud, halves rounded up
function Nearest
  (L : Divider_Limits; Clock : Clock_Hz; Baud : Baud_Rate)
  return Long_Long_Integer
is ((2 * Long_Long_Integer (L.Scale) * Long_Long_Integer (Clock)
     + Long_Long_Integer (Baud)) / (2 * Long_Long_Integer (Baud)));

--  D is within half a step of exact: the rate it makes is as
--  close to Baud as the divider allows
function Within_Half_Step
  (L : Divider_Limits; Clock : Clock_Hz; Baud : Baud_Rate;
   D : Divisor) return Boolean
is (2 * abs (Long_Long_Integer (L.Scale) * Long_Long_Integer (Clock)
             - Long_Long_Integer (D) * Long_Long_Integer (Baud))
    <= Long_Long_Integer (Baud));

--  The divisor for Baud from Clock. Found is False if the nearest
--  divisor is outside the divider's range: Clock is too slow, or
--  too fast, for Baud.
procedure Solve
  (L : Divider_Limits; Clock : Clock_Hz; Baud : Baud_Rate;
   D : out Divisor; Found : out Boolean)
  with Post =>
    (if Found
     then D in L.Min_Divisor .. L.Max_Divisor
          and then Within_Half_Step (L, Clock, Baud, D)
     else Nearest (L, Clock, Baud) not in
            Long_Long_Integer (L.Min_Divisor)
            .. Long_Long_Integer (L.Max_Divisor));
