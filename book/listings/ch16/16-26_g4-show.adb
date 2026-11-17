--  Strip K into buffer K mod 2; while it is drawn, the DMA sends
--  strip K - 1 from the other buffer
procedure Show (R : Dashboard.Readings) is
   Start : constant Keel.Time.Time := Keel.Time.Bare.Clock;
   Draw  : Natural := 0;
   Wait  : Natural := 0;
   T     : Keel.Time.Time;
   Area  : Keel.DMA.Region;
   Done  : Keel.DMA.Receipt;
   Stat  : Status;
begin
   for K in Natural range 0 .. 240 / Strip_Rows - 1 loop
      declare
         B : Strips.Canvas renames Strip (K mod 2);
      begin
         T := Keel.Time.Bare.Clock;
         Strips.Move_To (B, 0, K * Strip_Rows);
         Paint.Paint (B, R);
         Draw := Draw + Micros (T, Keel.Time.Bare.Clock);

         T := Keel.Time.Bare.Clock;
         if ST7789.Streaming (Panel) then
            ST7789.Finish_Window (Panel, TFT, Done);
            Pixels.Reclaim (Strip ((K + 1) mod 2).Store, Done);
         end if;
         Wait := Wait + Micros (T, Keel.Time.Bare.Clock);

         Pixels.Lend (B.Store, Area);
         ST7789.Start_Window
           (Panel, TFT, DC,
            (X => 0, Y => K * Strip_Rows, Across => 240,
             Down => Strip_Rows),
            Area, Stat);
         if Stat /= Ok then
            Ready := False;
            return;
         end if;
      end;
   end loop;
   --  The last strip goes on sending while the next frame's first
   --  strip is drawn, and comes back after it
   Stats :=
     (Frames    => Stats.Frames + 1,
      Draw_Us   => Draw,
      Wait_Us   => Wait,
      Period_Us => Micros (Before, Start));
   Before := Start;
end Show;
