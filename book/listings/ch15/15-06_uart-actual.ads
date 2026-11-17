--  The rate D really makes, to the nearest whole baud
function Actual
  (L : Divider_Limits; Clock : Clock_Hz; D : Divisor)
  return Long_Long_Integer
is ((Long_Long_Integer (L.Scale) * Long_Long_Integer (Clock)
     + Long_Long_Integer (D) / 2) / Long_Long_Integer (D))
  with Pre => D > 0;

--  Its error against Baud, in parts per million, toward zero, for
--  a divisor Solve found
function Error_PPM
  (L : Divider_Limits; Clock : Clock_Hz; Baud : Baud_Rate;
   D : Divisor) return Long_Long_Integer
is ((Long_Long_Integer (L.Scale) * Long_Long_Integer (Clock)
     - Long_Long_Integer (D) * Long_Long_Integer (Baud))
    * 1_000_000
    / (Long_Long_Integer (D) * Long_Long_Integer (Baud)))
  with Pre => D > 0 and then Within_Half_Step (L, Clock, Baud, D);
