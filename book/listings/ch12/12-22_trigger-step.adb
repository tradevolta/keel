procedure Step
  (S : in out State; Set : Setting; X : Sample; Fired : out Boolean)
is
   V : constant Integer := Value (X);
   T : constant Integer := Set.Threshold;
begin
   Fired := False;
   if Failed (X) then
      return;
   elsif not S.Armed then
      --  Integer: Threshold - Band can be below 0
      S.Armed := (if Set.Slope = Rising then V < T - Set.Band
                  else V > T + Set.Band);
   elsif (if Set.Slope = Rising then V >= T else V <= T) then
      Fired := True;
      S.Armed := False;
   end if;
end Step;
