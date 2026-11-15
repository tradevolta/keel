procedure Touch
  (L : in out Line; Bit : Boolean; Got : out Boolean;
   Stat : out Status) is
begin
   Hold;
   Set (L, Keel.GPIO.Low);
   if Bit then
      Wait_Us (A);
      Set (L, Keel.GPIO.High);
      Wait_Us (E);
      Got := Sense (L) = Keel.GPIO.High;
      Let_Go;
      Wait_Us (F);
   else
      Wait_Us (C);
      Set (L, Keel.GPIO.High);
      Let_Go;
      Got := False;
      Wait_Us (D);
   end if;
   Stat := Ok;
end Touch;
