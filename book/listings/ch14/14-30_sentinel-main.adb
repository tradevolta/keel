begin
   Board.Initialize;
   Why := Cause;
   Load (L, Found);
   if not Found then
      L := (others => <>);
   end if;
   if Why in Watchdog_Timeout | Watchdog_Forced then
      L.Recoveries := Natural'Min (L.Recoveries + 1, 255);
   end if;
   L.Last_Cause := Reset_Cause'Pos (Why);
   Store (L);
   Put_Line ("sentinel: " & Stamp & " start: " & Why'Image
             & (if Found then ", log kept" else ", new log")
             & ", rescues" & L.Recoveries'Image
             & ", deepest " & Deepest_Mode);

   Start_Watchdog (Timeout);
   Next := Now;
   loop
      if Hang_Requested then
         Put_Line ("sentinel: hang: no more feeding");
         loop
            null;
         end loop;
      end if;

      Read_Temperature (C, Stat);
      if Stat = Keel.Ok then
         Push (L, C);
         Store (L);
         Put_Line ("sentinel: " & Stamp & " " & Degrees (C)
                   & " C, taken" & L.Taken'Image & ", log"
                   & History);
      else
         Put_Line ("sentinel: temperature: " & Stat'Image);
      end if;

      Feed;
      Next := Next + Period;
      Wait_Until (Next);
   end loop;
end Sleepy_Sentinel;
