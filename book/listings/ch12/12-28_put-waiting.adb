--  The probe reads the console every few milliseconds; a capture
--  is about 12 KB and the console's buffer 1 KB, so wait for room
procedure Put_Line_Waiting (Text : String) is
   Give_Up : constant Time := Now + Milliseconds (1_000);
begin
   loop
      exit when Keel.Trace.Space > Text'Length
        or else Now >= Give_Up;
   end loop;
   Keel.Trace.Put_Line (Text);
end Put_Line_Waiting;
