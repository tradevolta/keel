--  Take P's pins, set its clock divider for Baud from clk_peri
--  (started here if it isn't running) and its frame format, and
--  start it the way How says. With DMA, Channel is the channel
--  that receives, and Keel.DMA.RP2350 must be enabled.
--  Not_Supported: clk_peri can't make Baud. In_Use: a pin, or the
--  channel, has another owner.
procedure Open
  (P        : Port_Id;
   TX, RX   : Pin_Id;
   Baud     : Baud_Rate;
   Stat     : out Status;
   F        : Format := Eight_N_One;
   How      : Mode := Interrupt;
   Channel  : Keel.DMA.RP2350.Channel := 11;
   Priority : Keel.Interrupts.Priority := 4)
  with Pre  => Keel.GPIO.RP2350.Is_Enabled
               and then not Is_Open (P)
               and then Valid_Pins (P, TX, RX)
               and then (if How = DMA
                         then Keel.DMA.RP2350.Is_Enabled),
       Post => Is_Open (P) = (Stat = Ok)
               and then (if Stat = Ok then Mode_Of (P) = How);
