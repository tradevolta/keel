--  x to the right, y down. A canvas can sit anywhere in this
--  range, and drawing may start or end outside it.
subtype Coordinate is Integer range -2**15 .. 2**15 - 1;
subtype Extent is Natural range 0 .. 2**15;

type Rect is record
   X, Y          : Coordinate := 0;
   Width, Height : Extent     := 0;
end record;

function Is_Empty (R : Rect) return Boolean is
  (R.Width = 0 or else R.Height = 0);

--  The first column and row past R
function Right (R : Rect) return Integer is (R.X + R.Width);
function Bottom (R : Rect) return Integer is (R.Y + R.Height);

function Contains (R : Rect; X, Y : Integer) return Boolean is
  (X >= R.X and then X < Right (R)
   and then Y >= R.Y and then Y < Bottom (R));

--  Every point of Inner is in Outer, as the bounds show
function Inside (Inner, Outer : Rect) return Boolean is
  (Is_Empty (Inner)
   or else (Inner.X >= Outer.X and then Inner.Y >= Outer.Y
            and then Right (Inner) <= Right (Outer)
            and then Bottom (Inner) <= Bottom (Outer)));

--  The points in both A and B, and no others
function Intersection (A, B : Rect) return Rect
  with Post =>
    Inside (Intersection'Result, A)
    and then Inside (Intersection'Result, B)
    and then
    (for all X in Coordinate =>
       (for all Y in Coordinate =>
          Contains (Intersection'Result, X, Y)
          = (Contains (A, X, Y) and then Contains (B, X, Y))));
