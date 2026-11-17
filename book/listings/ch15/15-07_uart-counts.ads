--  Polled: the program waits on the FIFOs' flags. Interrupt: an
--  interrupt handler fills and empties rings. DMA: the DMA writes
--  received characters into a ring; sending is by interrupt.
type Mode is (Polled, Interrupt, DMA);

--  Counts since Open, each stopping at Natural'Last
type Counts is record
   Received : Natural := 0;
   Sent     : Natural := 0;
   --  The hardware FIFO was full when a character arrived
   Overruns : Natural := 0;
   --  A stop bit was low, the parity was wrong, or the line was
   --  held low for a whole frame
   Framing  : Natural := 0;
   Parity   : Natural := 0;
   Breaks   : Natural := 0;
   --  The software ring was full: characters thrown away
   Dropped  : Natural := 0;
end record;
