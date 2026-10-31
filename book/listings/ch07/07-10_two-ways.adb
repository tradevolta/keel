--  The same pin through the signature and through the interface
declare
   Led : aliased Output_Pin (13);
   Line : Fake_Lines.Line (Led'Access);

   procedure Light (L : in out Lines.Output_Line'Class) is
   begin
      L.Set (High);
   end Light;
begin
   Claim (Led, (others => <>), Stat);
   Fake_Pulse (Led);
   Check ("generic Pulse: two edges", Edges (13) = 2);
   Light (Line);
   Check ("Output_Line'Class Set: High", Lamp (13) = High);
end;
