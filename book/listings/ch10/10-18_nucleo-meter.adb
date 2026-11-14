procedure Start_Meter is
begin
   Start (Meter);
   Opened := Now;
end Start_Meter;

--  Edges over the time since Start_Meter: never waits
procedure Read_Meter (Hz : out Natural; Stat : out Keel.Status) is
   Gate  : constant Time_Span := Now - Opened;
   Edges : Natural;
begin
   Stop (Meter);
   Edges := Value (Meter);
   Hz := 0;
   if Wrapped (Meter) then
      Stat := Keel.Not_Supported;
   elsif Gate <= 0 then
      Stat := Keel.Timeout;
   else
      Hz := Natural (Long_Long_Integer (Edges) * 1_000_000
                     / Long_Long_Integer (Gate));
      Stat := Keel.Ok;
   end if;
end Read_Meter;
