procedure Set_Frame (D : Device; Size : SSPCR0_DSS_Field) is
   R  : SPI0_Peripheral renames Regs (D.Port).all;
   C0 : SSPCR0_Register := R.SSPCR0;
begin
   R.SSPCR1 := (SSE => False, others => <>);
   C0.DSS := Size;
   R.SSPCR0 := C0;
   R.SSPCR1 := (SSE => True, others => <>);
end Set_Frame;

procedure Start_Stream
  (D     : in out Device;
   From  : Keel.DMA.Region;
   Count : Positive;
   Stat  : out Status)
is
   S : Port_State renames State (D.Port);
   R : SPI0_Peripheral renames Regs (D.Port).all;
   T : constant Transfer :=
     (From     => From,
      To       => Keel.DMA.Register (R.SSPDR'Address),
      Size     => Keel.DMA.Half_Word,
      Count    => Count,
      Paced_By => TX_Request (D.Port),
      Mode     => Once,
      Notify   => True,
      others   => <>);
begin
   if not S.Has_DMA or else not Valid (T) then
      Stat := Not_Supported;
      return;
   end if;
   Set_Frame (D, Sixteen_Bits);
   R.SSPDMACR := (TXDMAE => True, others => <>);
   Start (S.Channel, T, Stat);
   if Stat /= Ok then
      R.SSPDMACR := (others => <>);
      Set_Frame (D, Eight_Bits);
      return;
   end if;
   D.Streaming := True;
end Start_Stream;

procedure Finish_Stream
  (D : in out Device; Done : out Keel.DMA.Receipt)
is
   R : SPI0_Peripheral renames Regs (D.Port).all;
begin
   Wait (State (D.Port).Channel, Done);
   --  The DMA has filled the FIFO for the last time; the frames
   --  still in it go out before the frame size changes back
   loop
      exit when R.SSPSR.TFE;
   end loop;
   Drain (R);
   R.SSPDMACR := (others => <>);
   Set_Frame (D, Eight_Bits);
   D.Streaming := False;
end Finish_Stream;
