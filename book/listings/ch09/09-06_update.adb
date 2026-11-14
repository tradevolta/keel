procedure Update (D : in out Decoder; Now : Phase) is
begin
   if Invalid (D.Last, Now) and then D.Misses < Natural'Last then
      D.Misses := D.Misses + 1;
   end if;
   D.Position := Clamp (D, D.Position + Steps (D.Last, Now));
   D.Last := Now;
end Update;
