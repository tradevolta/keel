--  A rise: below the middle by an eighth of the range, then
--  above it by as much, so noise near the middle doesn't count
Mid := (W.Low + W.High) / 2;
Band := (W.High - W.Low) / 8;
for I in Samples'Range loop
   if Samples (I) < Mid - Band then
      Below := True;
   elsif Below and then Samples (I) > Mid + Band then
      Below := False;
      W.Rises := W.Rises + 1;
      if First = 0 then
         First := I;
      end if;
      Last := I;
   end if;
end loop;

if W.Rises >= 2 and then Last > First then
   W.Frequency :=
     Hertz (Long_Long_Integer (W.Rises - 1)
            * Long_Long_Integer (Rate)
            / Long_Long_Integer (Last - First));
end if;
