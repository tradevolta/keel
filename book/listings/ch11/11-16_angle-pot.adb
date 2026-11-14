function Angle (Frame : Natural) return Degrees is
   pragma Unreferenced (Frame);
   Total : Natural := 0;
   C     : Code;
   Stat  : Keel.Status;
begin
   for I in 1 .. Samples_For (Extra) loop
      Read (Wiper, C, Stat);
      Total := Total + C;
   end loop;
   return Oversample (Converter, Total, Extra) * 180
            / Top (Converter, Extra);
end Angle;
