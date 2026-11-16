--  SPDX-License-Identifier: Apache-2.0
package body Keel.RTC
  with SPARK_Mode
is
   --  Day 0 is 1970-01-01; the last day of the cycle is Cycle_Days - 1
   subtype Day_Index is Natural range 0 .. Cycle_Days - 1;

   --  A year's first day plus its length is the next year's first
   --  day: the leap rule and Leaps_Before agree
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

   --  The same for months, inside a year
   procedure Next_Month (Y : Year_Number; M : Month_Number)
     with Ghost,
          Pre  => M < 12,
          Post => Days_Before_Month (Y, M + 1)
                    = Days_Before_Month (Y, M) + Days_In_Month (Y, M)
   is
   begin
      null;
   end Next_Month;

   function Day_Of (D : Date_Time) return Day_Index is
     (Days_Before_Year (D.Year) + Days_Before_Month (D.Year, D.Month)
      + D.Day - 1)
     with Pre => Valid (D);

   function Join (D : Date_Time) return Epoch_Ms is
   begin
      pragma Assert (Days_Before_Year (D.Year) <= 145_732);
      return Epoch_Ms (Day_Of (D)) * Ms_Per_Day
        + Epoch_Ms (D.Hour * 3_600_000 + D.Minute * 60_000
                    + D.Second * 1_000 + D.Milli);
   end Join;

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

   function Image (D : Date_Time) return Stamp is
      Digit : constant String (1 .. 10) := "0123456789";
      S     : Stamp := "0000-00-00 00:00:00";

      --  N's last two digits into S at From
      procedure Put (N : Natural; From : Positive)
        with Pre => From in S'First .. S'Last - 1
      is
      begin
         S (From) := Digit (N / 10 mod 10 + 1);
         S (From + 1) := Digit (N mod 10 + 1);
      end Put;
   begin
      Put (D.Year / 100, 1);
      Put (D.Year mod 100, 3);
      Put (D.Month, 6);
      Put (D.Day, 9);
      Put (D.Hour, 12);
      Put (D.Minute, 15);
      Put (D.Second, 18);
      return S;
   end Image;
end Keel.RTC;
