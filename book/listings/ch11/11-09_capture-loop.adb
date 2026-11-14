for I in Samples'Range loop
   Got := False;
   for Try in 1 .. Patience loop
      if not ADC_Periph.FCS.EMPTY then
         Got := True;
         exit;
      end if;
   end loop;
   exit when not Got;
   F := ADC_Periph.FIFO;
   if not F.ERR then
      Samples (I) := Code (F.VAL);
   else
      --  Discard it (datasheet 12.4.3.4): keep the last good
      --  sample from the same input, if there is one
      Errors := Errors + 1;
      if I - Samples'First >= Count then
         Samples (I) := Samples (I - Count);
      end if;
   end if;
   if I = Samples'Last then
      Stat := Ok;
   end if;
end loop;
