--  SPDX-License-Identifier: Apache-2.0
--  Keel.Ring_Buffers: a first-in, first-out queue in a fixed array,
--  for one producer and one consumer that run without a lock: an
--  interrupt handler and the main program, or the two cores. The
--  producer writes only Head and the slot Head names; the consumer
--  writes only Tail. Head and Tail count without end, modulo 2**32,
--  and Head - Tail is the length, so a full ring and an empty one
--  never look alike and no slot is wasted.
--
--  GNATprove proves the queue's whole behaviour (SPARK Gold): Push
--  appends, Pop removes the oldest, nothing else moves; and it proves
--  which side writes what. What it can't prove is the hardware's
--  part, that each side sees the other's writes in order: see
--  Keel.Bus.UART.RP2350, which puts a barrier around every call.
generic
   type Element is private;
   --  What a slot holds before anything is pushed into it
   Initial : Element;
   --  2**Size_Bits slots, 2 to 32 768
   Size_Bits : Positive;
package Keel.Ring_Buffers
  with Pure, SPARK_Mode
is
   --  'Old after "and then" is evaluated on entry all the same
   pragma Unevaluated_Use_Of_Old (Allow);

   pragma Compile_Time_Error
     (Size_Bits > 15, "a ring has at most 2**15 slots");

   Capacity : constant Positive := 2**Size_Bits;

   --  Head and Tail: elements pushed and popped since the start
   type Counter is mod 2**32;
   subtype Length_Type is Natural range 0 .. Capacity;
   subtype Position is Positive range 1 .. Capacity;

   type Ring is limited private
     with Default_Initial_Condition => Length (Ring) = 0;

   function Length (R : Ring) return Length_Type;
   function Is_Empty (R : Ring) return Boolean is (Length (R) = 0);
   function Is_Full (R : Ring) return Boolean is
     (Length (R) = Capacity);

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

   --  The producer's side: E goes at the end
   procedure Push (R : in out Ring; E : Element)
     with Pre  => not Is_Full (R),
          Post =>
            Length (R) = Length (R)'Old + 1
            and then Contents (R).Items (Length (R)) = E
            and then (for all I in 1 .. Length (R)'Old =>
                        Contents (R).Items (I)
                        = Contents (R)'Old.Items (I))
            --  The frame: Tail, and every slot but one, unchanged
            and then Tail (R) = Tail (R)'Old
            and then Head (R) = Head (R)'Old + 1
            and then (for all S in Slot =>
                        (if S /= Slot_Of (Head (R)'Old)
                         then Raw (R) (S) = Raw (R)'Old (S)));

   --  The consumer's side: E is the oldest, and leaves
   procedure Pop (R : in out Ring; E : out Element)
     with Pre  => not Is_Empty (R),
          Post =>
            E = Contents (R)'Old.Items (1)
            and then Length (R) = Length (R)'Old - 1
            and then (for all I in 1 .. Length (R) =>
                        Contents (R).Items (I)
                        = Contents (R)'Old.Items (I + 1))
            --  The frame: Head and every slot unchanged
            and then Head (R) = Head (R)'Old
            and then Tail (R) = Tail (R)'Old + 1
            and then Raw (R) = Raw (R)'Old;

   --  The oldest element, left in place
   function Peek (R : Ring) return Element
     with Pre  => not Is_Empty (R),
          Post => Peek'Result = Contents (R).Items (1);

   --  Empty the ring from the consumer's side: Tail catches up
   procedure Clear (R : in out Ring)
     with Post => Is_Empty (R)
                  and then Head (R) = Head (R)'Old
                  and then Raw (R) = Raw (R)'Old;

private
   type Ring is limited record
      Data : Slots := [others => Initial];
      Head : Counter := 0;
      Tail : Counter := 0;
   end record
     with Type_Invariant => Ring.Head - Ring.Tail <= Counter (Capacity);

   function Length (R : Ring) return Length_Type is
     (Length_Type (R.Head - R.Tail));
   function Head (R : Ring) return Counter is (R.Head);
   function Tail (R : Ring) return Counter is (R.Tail);
   function Raw (R : Ring) return Slots is (R.Data);

   function Contents (R : Ring) return Model is
     ((Items => [for I in Position =>
                   R.Data (Slot_Of (R.Tail + Counter (I - 1)))],
       Last  => Length (R)));
end Keel.Ring_Buffers;
