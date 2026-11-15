procedure Stop (Ch : Channel; Done : out Receipt) is
   T : Transfer renames Current (Ch);
   R : Regs.Channel_Registers renames Regs.Channels (Regs_Of (Ch));
   Left : constant Natural := Natural (R.TRANS_COUNT.COUNT);
begin
   --  RP2350-E5: an aborted channel may fire its chain, or start
   --  again, unless it and the channel it chains to are disabled
   R.AL1_CTRL :=
     (R.AL1_CTRL with delta EN => False, CHAIN_TO => UInt4 (Ch));
   if T.Chain then
      Regs.Channels (Regs_Of (T.Chain_To)).AL1_CTRL :=
        (Regs.Channels (Regs_Of (T.Chain_To)).AL1_CTRL
         with delta EN => False);
   end if;
   DMA_Periph.CHAN_ABORT := (CHAN_ABORT => Bit (Ch), others => <>);
   loop
      exit when (DMA_Periph.CHAN_ABORT.CHAN_ABORT and Bit (Ch)) = 0;
   end loop;
   loop
      exit when not Is_Busy (Ch);
   end loop;
   Done := Receipt_For (Ch);
   Done.Done :=
     (if T.Mode = Once then T.Count - Natural'Min (Left, T.Count)
      else Position (Ch) / Bytes (T.Size));
end Stop;
