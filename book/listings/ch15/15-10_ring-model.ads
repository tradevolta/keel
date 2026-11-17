--  The model: the ring as a sequence, oldest first. Item (M, I)
--  is the I-th oldest element, for I in 1 .. Last (M).
type Model_Items is array (Position) of Element;
type Model is record
   Items : Model_Items;
   Last  : Length_Type;
end record
  with Ghost;

function Contents (R : Ring) return Model
  with Ghost,
       Post => Contents'Result.Last = Length (R);

--  The two sides' counters, for the frame conditions below
function Head (R : Ring) return Counter;
function Tail (R : Ring) return Counter;

--  The array underneath, for the same purpose
subtype Slot is Natural range 0 .. Capacity - 1;
type Slots is array (Slot) of Element;
function Raw (R : Ring) return Slots
  with Ghost;
function Slot_Of (C : Counter) return Slot is
  (Slot (C mod Counter (Capacity)));
