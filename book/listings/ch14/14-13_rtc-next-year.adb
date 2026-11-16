procedure Next_Year (Y : Year_Number)
  with Ghost,
       Post => Days_Before_Year (Y + 1)
                 = Days_Before_Year (Y) + Days_In_Year (Y)
is
begin
   pragma Assert (Y / 4 - (Y - 1) / 4
                    = (if Y mod 4 = 0 then 1 else 0));
   pragma Assert (Y / 100 - (Y - 1) / 100
                    = (if Y mod 100 = 0 then 1 else 0));
   pragma Assert (Y / 400 - (Y - 1) / 400
                    = (if Y mod 400 = 0 then 1 else 0));
end Next_Year;
