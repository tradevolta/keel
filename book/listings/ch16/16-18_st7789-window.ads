--  Take the bus, set the window to W and start the DMA sending
--  its pixels, row by row, from From. Returns at once; the
--  program draws elsewhere while they go, then calls
--  Finish_Window.
procedure Start_Window
  (P    : in out Panel;
   D    : in out Link.Device;
   DC   : in out Pins.Pin;
   W    : Window;
   From : Keel.DMA.Region;
   Stat : out Status)
  with Pre  => Ready (P) and then not Streaming (P)
               and then not Keel.DMA.Is_Register (From)
               and then Keel.DMA.Length (From) >= 2 * Pixels (W),
       Post => Turn (P) = Turn (P)'Old
               and then Ready (P) and then Streaming (P) = (Stat = Ok);

--  Wait for the last pixel to leave and give the bus back. Done
--  is the receipt for From, to reclaim the buffer with.
procedure Finish_Window
  (P    : in out Panel;
   D    : in out Link.Device;
   Done : out Keel.DMA.Receipt)
  with Pre  => Ready (P) and then Streaming (P),
       Post => Turn (P) = Turn (P)'Old
               and then Ready (P) and then not Streaming (P);
