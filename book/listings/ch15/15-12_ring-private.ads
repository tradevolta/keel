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
