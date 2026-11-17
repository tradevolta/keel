procedure Paint (C : in out Screen.Canvas; R : Readings) is
   Past : W.Series (1 .. History_Length);
begin
   for I in Past'Range loop
      Past (I) := R.Past (I);
   end loop;
   Screen.Clear (C, Night);
   W.Label (C, Clock_Box, Clock_Image (R.Seconds), Paper, Night,
            Scale => 3, Align => W.Center);
   W.Gauge (C, Dial, R.Needle);
   W.Label (C, Value_Box, Percent (R.Reading), Gold, Night,
            Scale => 2, Align => W.Center);
   W.Label (C, Name_Box,
            (if R.Source = Light then "light" else "sweep"),
            Muted, Night, Align => W.Center);
   W.Label (C, Temp_Box, Temperature_Image (R), Sky, Night,
            Scale => 2);
   W.Label (C, Temp_Name, "cpu", Muted, Night);
   W.Sparkline (C, Past_Box, Past, Moss, Night);
   W.Label (C, FPS_Box, FPS_Image (R.FPS_Tenths), Muted, Night,
            Align => W.Right);
end Paint;
