procedure Start_Stream
  (Inputs : Channel_Set; Rate : Hertz; Stat : out Status)
is
   Count : Natural;
begin
   Start_Many (Inputs, Rate, True, Count, Stat);
   Streaming := Stat = Ok;
end Start_Stream;

procedure Stop_Stream (Lost : out Boolean) is
begin
   Stop_Many (Lost);
   Streaming := False;
end Stop_Stream;

function FIFO return Keel.DMA.Region is
  (Keel.DMA.Register (ADC_Periph.FIFO'Address));
