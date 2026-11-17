--  What a device driver needs from a device on a bus. Acquire
--  takes the bus for the device, sets it up for the device's
--  settings if it must, and drives the device's chip select low;
--  In_Use if another device holds it. Release drives the chip
--  select high and frees the bus. Write sends bytes, 8-bit frames,
--  and returns when the last has gone; Exchange sends Data and
--  replaces it with what came back. Start_Stream starts the DMA
--  sending Count 16-bit frames from From, most significant bit
--  first, and returns at once; Finish_Stream waits for the last
--  frame to leave and hands back the receipt for From.
generic
   type Device (<>) is limited private;
   with procedure Acquire (D : in out Device; Stat : out Status);
   with procedure Release (D : in out Device);
   with procedure Write (D : in out Device; Data : Byte_Array);
   with procedure Exchange
     (D : in out Device; Data : in out Byte_Array);
   with procedure Start_Stream
     (D     : in out Device;
      From  : Keel.DMA.Region;
      Count : Positive;
      Stat  : out Status);
   with procedure Finish_Stream
     (D : in out Device; Done : out Keel.DMA.Receipt);
package Device_Signature is
   pragma Warnings (Off, Acquire);
   pragma Warnings (Off, Release);
   pragma Warnings (Off, Write);
   pragma Warnings (Off, Exchange);
   pragma Warnings (Off, Start_Stream);
   pragma Warnings (Off, Finish_Stream);
end Device_Signature;
