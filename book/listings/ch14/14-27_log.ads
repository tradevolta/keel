Capacity : constant := 12;
subtype Slot is Positive range 1 .. Capacity;

type Log is record
   Held       : Natural range 0 .. Capacity := 0;
   Next       : Slot := 1;               --  where the next goes
   Taken      : Natural range 0 .. 65_535 := 0;
   Recoveries : Natural range 0 .. 255 := 0;
   Last_Cause : Natural range 0 .. 255 := 0;
   Readings   : Pair_Array;
end record;

function Get (L : Log; S : Slot) return Centi is
  (if S mod 2 = 1 then L.Readings ((S + 1) / 2).Low
   else L.Readings (S / 2).High);

function Previous (S : Slot) return Slot is
  (if S = 1 then Capacity else S - 1);

function Latest (L : Log) return Centi is
  (Get (L, Previous (L.Next)));

--  Add a reading, over the oldest once the log is full. Taken
--  stops at its largest value.
procedure Push (L : in out Log; C : Centi)
  with Post => L.Held = Natural'Min (L'Old.Held + 1, Capacity)
               and then L.Taken
                          = Natural'Min (L'Old.Taken + 1, 65_535)
               and then Latest (L) = C;

--  The I-th reading held, oldest first
function Nth (L : Log; I : Positive) return Centi
  with Pre => I <= L.Held;
