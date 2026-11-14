--  The frequency S makes, to the nearest hertz
function Output (S : Setting) return Hertz;

--  A fraction of the period, to 1/65536
type Duty is delta 2.0**(-16) range 0.0 .. 1.0
  with Small => 2.0**(-16), Size => 32;

--  The level for a duty: D * (Top + 1), to the nearest count
function Level_For (S : Setting; D : Duty) return Count
  with Post => Level_For'Result <= Top (S) + 1;

--  The level that keeps the output high for W in each period,
--  to the nearest count, and Top + 1 if W is a period or more
function Width_Level (S : Setting; W : Micro_Seconds) return Count
  with Post => Width_Level'Result <= Top (S) + 1;
