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
