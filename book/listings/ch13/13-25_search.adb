--  Each device sends its bit, then the bit's complement, and
--  the line is the AND of them all. Then the controller sends
--  the branch it takes, and the devices on the other drop out.
for N in 1 .. 64 loop
   Wire.Touch (B, True, Id, Stat);
   if Stat = Ok then
      Wire.Touch (B, True, Comp, Stat);
   end if;
   if Stat /= Ok or else (Id and Comp) then
      --  No device is left
      if Stat = Ok then
         Stat := No_Device;
      end if;
      S := Fresh_Search;
      return;
   end if;
   if Id /= Comp then
      --  Every device left has this bit
      Take := Id;
   else
      --  Both values: a branch. Below the last discrepancy,
      --  follow the last code; at it, take the 1 this time;
      --  beyond it, take the 0 first.
      Take := (if N < S.Last_Discrepancy then Bit (Code, N)
               else N = S.Last_Discrepancy);
      if not Take then
         Last_Zero := N;
      end if;
   end if;
   Set_Bit (Code, N, Take);
   Wire.Touch (B, Take, Id, Stat);
   if Stat /= Ok then
      S := Fresh_Search;
      return;
   end if;
end loop;

--  A line held low answers every bit with 0 and 0, a branch
--  each time; the zeros it gives have a good CRC
if All_Zero (Code) then
   Stat := Bus_Low;
   S := Fresh_Search;
   return;
elsif not Valid (Code) then
   Stat := CRC_Error;
   S := Fresh_Search;
   return;
end if;
