procedure Latch
  (S          : in out Strip;
   Reset_Time : Keel.Time.Time_Span;
   Stat       : out Status) is
begin
   Wait_Empty
     (S.B, S.M, Keel.Time.Bare.Clock + Keel.Time.Milliseconds (1),
      Stat);
   if Stat = Ok then
      Keel.Time.Bare.Wait_Until
        (Keel.Time.Bare.Clock + Pixel_Time + Reset_Time);
   end if;
end Latch;
