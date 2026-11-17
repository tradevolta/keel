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
