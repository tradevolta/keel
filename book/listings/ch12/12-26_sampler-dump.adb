--  The ring is the program's again: print the capture
Out_Format.Header (Rate, Length, Pre, Set);
Errors := 0;
Filled := 0;
for K in Natural range 0 .. Length - 1 loop
   Filled := Filled + 1;
   Line (Filled) := Get (Ring, Slot_Of (T, K));
   if Failed (Line (Filled)) then
      Errors := Errors + 1;
   end if;
   if Filled = Line'Last then
      Out_Format.Data (Line);
      Filled := 0;
   end if;
end loop;
if Filled > 0 then
   Out_Format.Data (Line (1 .. Filled));
end if;
Out_Format.Finish (Errors);
if Behind or else Lost or else not Intact (T, Next) then
   Put_Line ("sampler: samples were lost: behind "
             & Behind'Image & ", FIFO" & Lost'Image
             & ", overwritten " & Boolean'Image
               (not Intact (T, Next)));
end if;
