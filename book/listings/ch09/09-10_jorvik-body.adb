protected body Encoder is
   entry Changed (Position : out Volume) when Moved is
   begin
      Position := D.Position;
      Moved := False;
   end Changed;

   procedure Handler is
   begin
      IO_BANK0_Periph.INTR2 := Edges_16_17;
      Update (D, Contacts);
      Moved := True;
   end Handler;
end Encoder;
