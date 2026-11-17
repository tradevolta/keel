procedure Pop (R : in out Ring; E : out Element) is
begin
   R.Head := R.Head - 1;
   E := R.Data (Slot_Of (R.Head));
end Pop;
