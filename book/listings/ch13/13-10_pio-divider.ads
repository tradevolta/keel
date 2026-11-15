--  A state machine's clock divider: Int + Frac / 256, from 1.0 to
--  65536.0 (datasheet 11.5.5). The machine runs one cycle every
--  Int + Frac / 256 system clock cycles.
type Divider is record
   Int  : Positive range 1 .. 65_536 := 1;
   Frac : Natural range 0 .. 255 := 0;
end record;

--  The divider that runs a machine at Rate cycles a second from a
--  Clock-Hz system clock: Clock / Rate, rounded down to 1/256.
--  Exact when Rate divides 256 * Clock.
function Divider_For (Clock, Rate : Positive) return Divider
  with Pre  => Rate <= Clock and then Clock / Rate <= 65_535,
       Post => Long_Long_Integer (Divider_For'Result.Int) * 256
               + Long_Long_Integer (Divider_For'Result.Frac)
               = Long_Long_Integer (Clock) * 256
                 / Long_Long_Integer (Rate);
