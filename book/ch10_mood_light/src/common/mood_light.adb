--  SPDX-License-Identifier: Apache-2.0
--  The mood light: 50 frames a second, each one a degree further
--  round the color wheel for the RGB LED and a new angle for the
--  servo. Once a second it reports, with the frequency the meter
--  measured on its input.
with Angle_Source; use Angle_Source;
with Board;        use Board;
with Colors;       use Colors;
with Keel;         use type Keel.Status;
with Keel.Time;    use Keel.Time;
with Servo;

procedure Mood_Light is
   Frame_Time : constant Time_Span := Milliseconds (20);

   Next  : Time;
   Shade : Hue := 0;
   C     : RGB;
   A     : Degrees;
   Frame : Natural := 0;
   Hz    : Natural;
   Stat  : Keel.Status;
begin
   Board.Initialize;
   Angle_Source.Initialize;
   Start_Meter;
   Next := Now;
   loop
      --  Each deadline counts from the last one, not from Now, so
      --  late frames don't add up to drift
      Next := Next + Frame_Time;
      Wait_Until (Next);

      C := Wheel (Shade);
      Set_Color (Gamma (C.Red), Gamma (C.Green), Gamma (C.Blue));
      A := Angle (Frame);
      Set_Pulse (Servo.Width (A));

      Shade := Shade + 1;
      Frame := (Frame + 1) mod 3_000;
      if Frame mod 50 = 0 then
         Read_Meter (Hz, Stat);
         Put_Line
           ("mood_light: hue" & Shade'Image & ", angle" & A'Image
            & ", input "
            & (if Stat = Keel.Ok then Hz'Image & " Hz"
               else Stat'Image));
         Start_Meter;
      end if;
   end loop;
end Mood_Light;
