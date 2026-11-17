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
