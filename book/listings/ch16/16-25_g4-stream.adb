procedure Start_Stream
  (D     : in out Device;
   From  : Keel.DMA.Region;
   Count : Positive;
   Stat  : out Status)
is
begin
   if not Has_DMA or else Count > Count_16'Last then
      Stat := Not_Supported;
      return;
   end if;
   declare
      T : constant Transfer :=
        (From     => From,
         To       => Keel.DMA.Register (R.DR'Address),
         Size     => Keel.DMA.Half_Word,
         Count    => Count,
         Paced_By => SPI1_TX_Request,
         Notify   => True,
         others   => <>);
   begin
      if not Valid (T) then
         Stat := Not_Supported;
         return;
      end if;
      --  In the order 42.5.9 gives ("Communication using DMA"):
      --  the channel, then TXDMAEN, then SPE. The first request
      --  comes at once, since TXE is set.
      Disable;
      R.CR2 := (DS => Sixteen_Bits, FRXTH => False, others => <>);
      Start (Chan, T, Stat);
      if Stat /= Ok then
         R.CR2 := (DS => Eight_Bits, FRXTH => True, others => <>);
         R.CR1.SPE := True;
         return;
      end if;
      R.CR2.TXDMAEN := True;
      R.CR1.SPE := True;
      D.Streaming := True;
   end;
end Start_Stream;

procedure Finish_Stream
  (D : in out Device; Done : out Keel.DMA.Receipt) is
begin
   Wait (Chan, Done);
   --  The DMA has written the last frame; the SPI disable
   --  procedure waits for it to leave, and only then does
   --  TXDMAEN go off (42.5.9, "Communication using DMA"), with
   --  8-bit frames back
   Disable;
   R.CR2 := (DS => Eight_Bits, FRXTH => True, others => <>);
   R.CR1.SPE := True;
   D.Streaming := False;
end Finish_Stream;
