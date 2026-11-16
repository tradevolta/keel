--  SPDX-License-Identifier: Apache-2.0
--  Keel.RTC: wall-clock time as a count of milliseconds since
--  1970-01-01 00:00:00 UTC, the way the RP2350's always-on timer
--  counts it, and the calendar on top. Split turns a count into a
--  date and time and Join turns one back; GNATprove proves that
--  Split's result is a real date and that Join undoes Split. The
--  range is one Gregorian cycle, 400 years, from 1970 to 2369.
package Keel.RTC
  with Pure, SPARK_Mode, No_Elaboration_Code_All
is
   --  400 Gregorian years always hold 146 097 days
   Cycle_Days : constant := 146_097;
   Ms_Per_Day : constant := 86_400_000;

   --  Milliseconds since 1970-01-01 00:00:00 UTC
   type Epoch_Ms is range 0 .. Cycle_Days * Ms_Per_Day - 1;

   subtype Year_Number   is Positive range 1970 .. 2369;
   subtype Month_Number  is Positive range 1 .. 12;
   subtype Day_Number    is Positive range 1 .. 31;
   subtype Hour_Number   is Natural range 0 .. 23;
   subtype Minute_Number is Natural range 0 .. 59;
   subtype Second_Number is Natural range 0 .. 59;
   subtype Milli_Number  is Natural range 0 .. 999;

   type Date_Time is record
      Year   : Year_Number   := 1970;
      Month  : Month_Number  := 1;
      Day    : Day_Number    := 1;
      Hour   : Hour_Number   := 0;
      Minute : Minute_Number := 0;
      Second : Second_Number := 0;
      Milli  : Milli_Number  := 0;
   end record;

   function Is_Leap (Y : Year_Number) return Boolean is
     (Y mod 4 = 0 and then (Y mod 100 /= 0 or else Y mod 400 = 0));

   function Days_In_Year (Y : Year_Number) return Positive is
     (if Is_Leap (Y) then 366 else 365);

   function Days_In_Month (Y : Year_Number; M : Month_Number)
     return Day_Number
   is (case M is
          when 2              => (if Is_Leap (Y) then 29 else 28),
          when 4 | 6 | 9 | 11 => 30,
          when others         => 31);

   --  A date that exists: no 31 April, no 29 February 2025
   function Valid (D : Date_Time) return Boolean is
     (D.Day <= Days_In_Month (D.Year, D.Month));

   --  Leap years before year Y, counted from year 1
   function Leaps_Before (Y : Positive) return Natural is
     ((Y - 1) / 4 - (Y - 1) / 100 + (Y - 1) / 400);

   --  Days from 1970-01-01 to the first of January of year Y
   subtype Year_Bound is Positive range 1970 .. 2370;
   function Days_Before_Year (Y : Year_Bound) return Natural
   is (365 * (Y - 1970) + Leaps_Before (Y) - Leaps_Before (1970));

   --  Days in a common year before the first of month M
   type Month_Table is array (Month_Number) of Natural;
   Before_Month : constant Month_Table :=
     [0, 31, 59, 90, 120, 151, 181, 212, 243, 273, 304, 334];

   --  Days from the first of January to the first of month M
   function Days_Before_Month (Y : Year_Number; M : Month_Number)
     return Natural
   is (Before_Month (M)
       + (if M > 2 and then Is_Leap (Y) then 1 else 0));

   --  A valid date and time as a count
   function Join (D : Date_Time) return Epoch_Ms
     with Pre  => Valid (D),
          Post => Join'Result
                    = Epoch_Ms (Days_Before_Year (D.Year)
                                + Days_Before_Month (D.Year, D.Month)
                                + D.Day - 1) * Ms_Per_Day
                      + Epoch_Ms (D.Hour * 3_600_000
                                  + D.Minute * 60_000
                                  + D.Second * 1_000 + D.Milli);

   --  A count as a date and time
   function Split (T : Epoch_Ms) return Date_Time
     with Post => Valid (Split'Result)
                  and then Join (Split'Result) = T;

   --  "2026-11-15 21:04:05": to the second, in ISO 8601's order
   subtype Stamp is String (1 .. 19);
   function Image (D : Date_Time) return Stamp;

   --  What a chip's real-time clock provides
   generic
      --  The time now
      with function Now return Epoch_Ms;
      --  Set the time
      with procedure Set (T : Epoch_Ms);
   package Clock_Signature is
      pragma Warnings (Off, Now);
      pragma Warnings (Off, Set);
   end Clock_Signature;
end Keel.RTC;
