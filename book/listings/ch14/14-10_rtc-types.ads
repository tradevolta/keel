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
