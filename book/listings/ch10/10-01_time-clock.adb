--  Read the high word, the low word, and the high word again. If
--  the high word moved, the low word wrapped between the reads:
--  read both again (the SDK's time_us_64 does the same).
function Clock return Time is
   Hi : UInt32 := TIMER0_Periph.TIMERAWH;
   Lo, Hi_Again : UInt32;
begin
   loop
      Lo := TIMER0_Periph.TIMERAWL;
      Hi_Again := TIMER0_Periph.TIMERAWH;
      exit when Hi_Again = Hi;
      Hi := Hi_Again;
   end loop;
   return Time (Unsigned_64'Min
                  (Shift_Left (Unsigned_64 (Hi), 32)
                     or Unsigned_64 (Lo),
                   Unsigned_64 (Max_Clock)));
end Clock;
