procedure Logic_Sampler is
   use Samples;

   Rate : constant := 500_000;

   --  A capture: 1024 samples before the trigger and 2560 from it
   --  on, 7.2 ms in all, with 512 slots of the ring to spare
   Pre    : constant := 1_024;
   Post   : constant := 2_560;
   Length : constant := Pre + Post;

   --  1.65 V, rising, with a band of 64 codes, about 52 mV
   Set : constant Setting :=
     (Threshold => 2_048, Band => 64, Slope => Rising);

   function Settled (Slot : Ring_Slot) return Sample is
     (Peek (Ring, Slot));

   package Logic is new Sampler_Logic
     (Slots => Ring_Slots, Pre => Pre, Post => Post,
      Sample_At => Settled);
   use Logic;

   package Out_Format is new Capture_Format (Put_Line_Waiting);

   Stream : constant Transfer :=
     (From => FIFO, To => No_Region, Size => Half_Word,
      Count => Half, Paced_By => ADC_Request, Mode => Repeat,
      Wrap => Ring_Wrap, others => <>);
