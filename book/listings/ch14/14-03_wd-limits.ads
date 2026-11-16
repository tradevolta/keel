--  A countdown watchdog. Its counter's clock runs at Clock hertz,
--  divided by 2**Shift, Shift from Min_Shift to Max_Shift. The
--  counter loads Reload, at most Max_Reload, and resets the chip
--  after Reload counts, or Reload + 1 if Plus_One.
type Counter_Limits is record
   Clock      : Positive range 1_000 .. 100_000_000;
   Min_Shift  : Natural range 0 .. 16;
   Max_Shift  : Natural range 0 .. 16;
   Max_Reload : Positive range 1 .. 2**24 - 1;
   Plus_One   : Boolean;
end record
  with Predicate => Min_Shift <= Max_Shift;

type Setting is record
   Shift  : Natural range 0 .. 16 := 0;
   Reload : Natural range 0 .. 2**24 - 1 := 0;
end record;

--  A timeout in milliseconds, up to an hour
subtype Timeout_Ms is Positive range 1 .. 3_600_000;

subtype Ticks_Count is Long_Long_Integer range 0 .. 2**50;

--  2**Shift, as a table: no run-time exponent routine
type Power_Table is array (0 .. 16) of Ticks_Count;
Pow2 : constant Power_Table :=
  [1, 2, 4, 8, 16, 32, 64, 128, 256, 512, 1_024, 2_048, 4_096,
   8_192, 16_384, 32_768, 65_536];

--  Clock ticks before the watchdog fires
function Ticks (L : Counter_Limits; S : Setting) return Ticks_Count
is ((Long_Long_Integer (S.Reload)
     + (if L.Plus_One then 1 else 0)) * Pow2 (S.Shift));

--  Clock ticks in T milliseconds, rounded up
function Ticks_For (L : Counter_Limits; T : Timeout_Ms)
  return Ticks_Count
is ((Long_Long_Integer (T) * Long_Long_Integer (L.Clock) + 999)
    / 1_000);

function Fits (L : Counter_Limits; S : Setting) return Boolean is
  (S.Shift in L.Min_Shift .. L.Max_Shift
   and then S.Reload <= L.Max_Reload);
