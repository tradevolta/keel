procedure Show (R : Dashboard.Readings) is
   Other   : constant Natural := 1 - Next;
   Start   : constant Keel.Time.Time := Keel.Time.Bare.Clock;
   Drawn   : Keel.Time.Time;
   Area    : Keel.DMA.Region;
   Done    : Keel.DMA.Receipt;
   Stat    : Status;
begin
   --  Draw into the frame the program holds ...
   Paint.Paint (Frame (Next), R);
   Drawn := Keel.Time.Bare.Clock;

   --  ... wait for the other to finish sending, and take it back
   if ST7789.Streaming (Panel) then
      ST7789.Finish_Window (Panel, TFT, Done);
      Pixels.Reclaim (Frame (Other).Store, Done);
   end if;

   --  ... and send the new one while the next is drawn
   Stats :=
     (Frames    => Stats.Frames + 1,
      Draw_Us   => Micros (Start, Drawn),
      Wait_Us   => Micros (Drawn, Keel.Time.Bare.Clock),
      Period_Us => Micros (Before, Keel.Time.Bare.Clock));
   Before := Keel.Time.Bare.Clock;
   Pixels.Lend (Frame (Next).Store, Area);
   ST7789.Start_Window (Panel, TFT, DC, (others => <>), Area, Stat);
   if Stat /= Ok then
      --  The frame stays lent, with no transfer to give it back:
      --  only a bus another device holds can do this, and nothing
      --  else is on this one. Stop showing frames.
      Ready := False;
      return;
   end if;
   Next := Other;
end Show;
