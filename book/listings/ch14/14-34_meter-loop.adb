Next := Keel.Time.Bare.Clock;
loop
   Ends := Next + Window;
   Sum := 0;
   N := 0;
   Least := Integer'Last;
   Most := Integer'First;
   while Next < Ends loop
      Next := Next + Step;
      Keel.Time.Bare.Wait_Until (Next);
      Read_Shunt (Bus, uV, Stat);
      if Stat = Keel.Ok then
         uA := Current_uA (uV, Shunt);
         Sum := Sum + Long_Long_Integer (uA);
         N := N + 1;
         Least := Integer'Min (Least, uA);
         Most := Integer'Max (Most, uA);
      end if;
   end loop;
   if N = 0 then
      Keel.Trace.Put_Line ("meter: no readings: " & Stat'Image);
   else
      Keel.Trace.Put_Line
        ("meter:"
         & Long_Long_Integer'Image (Sum / Long_Long_Integer (N))
         & Least'Image & Most'Image & N'Image);
   end if;
end loop;
