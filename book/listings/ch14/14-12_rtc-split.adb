function Split (T : Epoch_Ms) return Date_Time is
   Days : constant Day_Index := Natural (T / Ms_Per_Day);
   Rest : constant Natural := Natural (T mod Ms_Per_Day);
   Y    : Year_Number := 1970;
   M    : Month_Number := 1;
   Left : Natural := Days;
begin
   --  Whole years, then whole months; Left is the day in month
   while Left >= Days_In_Year (Y) loop
      pragma Loop_Invariant (Days_Before_Year (Y) + Left = Days);
      pragma Loop_Variant (Decreases => Left);
      Next_Year (Y);
      Left := Left - Days_In_Year (Y);
      Y := Y + 1;
   end loop;
   while Left >= Days_In_Month (Y, M) loop
      pragma Loop_Invariant
        (Days_Before_Year (Y) + Days_Before_Month (Y, M) + Left
           = Days);
      pragma Loop_Invariant
        (Days_Before_Month (Y, M) + Left < Days_In_Year (Y));
      pragma Loop_Variant (Decreases => Left);
      Next_Month (Y, M);
      Left := Left - Days_In_Month (Y, M);
      M := M + 1;
   end loop;

   declare
      D : constant Date_Time :=
        (Year   => Y,
         Month  => M,
         Day    => Left + 1,
         Hour   => Rest / 3_600_000,
         Minute => Rest / 60_000 mod 60,
         Second => Rest / 1_000 mod 60,
         Milli  => Rest mod 1_000);
   begin
      pragma Assert (Valid (D));
      pragma Assert (Day_Of (D) = Days);
      pragma Assert
        (D.Hour * 3_600_000 + D.Minute * 60_000 + D.Second * 1_000
           + D.Milli = Rest);
      pragma Assert
        (Epoch_Ms (Days) * Ms_Per_Day + Epoch_Ms (Rest) = T);
      return D;
   end;
end Split;
