loop
   --  Arm: the DMA first, then the ADC (datasheet 12.4.3.5)
   Lend (Ring, R);
   Start (Sampler, (Stream with delta To => R), Stat);
   if Stat = Keel.Ok then
      Start_Stream (Probe, Hertz (Rate), Stat);
   end if;
   if Stat /= Keel.Ok then
      Put_Line ("sampler: cannot start: " & Stat'Image);
      loop
         null;
      end loop;
   end if;

   --  Sleep, half by half, until the trigger fires. The first
   --  half only arms it, so that Pre samples exist before T.
   S := (others => <>);
   Seen := 0;
   Behind := False;
   loop
      Wait_Round (Sampler);
      Seen := Seen + 1;
      Behind := Behind or else Rounds (Sampler) > Seen;
      Scan (S, Set, (if Seen mod 2 = 1 then 0 else Half), Half,
            Found, T);
      exit when Found and then Seen > 1;
   end loop;

   --  The rest of the capture, then stop
   loop
      Next := Write_Slot;
      exit when Logic.Done (T, Next);
   end loop;
   Stop (Sampler, Done);
   Stop_Stream (Lost);
   Next := Write_Slot;
   Reclaim (Ring, Done);
