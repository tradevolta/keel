function V (Input : Channel; S : Scale := Converter) return Volts is
  (To_Volts (S, Oversample (S, Total (Input), Extra), Extra));

function Img (X : Volts) return String is (X'Image);
function Percent (X : Volts) return Natural is
  (Natural (X / Volts'(0.033)));
begin
Board.Initialize;
Set_DAC (Steps (Step));
Next := Now;
loop
   Next := Next + Period;
   Wait_Until (Next);

   Capture (Slow, 40_000.0, Buffers.Slow, Errors, Stat);
   if Stat = Keel.Ok then
      Split (Slow, Buffers.Slow, Total, Each);
      Show (Lit_Count'Min (8, Percent (V (Light)) * 9 / 100));
      Put_Line
        ("monitor: VSYS" & Img (V (Battery, VSYS_Scale))
         & " V, light" & Percent (V (Light))'Image & " %, DAC"
         & Img (Steps (Step)) & " V set," & Img (V (Loopback))
         & " V read, chip"
         & Celsius'Image (Temperature (Sensor, V (Chip))) & " C");
   else
      Put_Line ("monitor: slow inputs: " & Stat'Image);
   end if;
