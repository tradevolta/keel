type Channel_Set is array (Channel) of Boolean;
type Sample_Array is array (Positive range <>) of Code;

--  The fastest and slowest Capture rates, in conversions a
--  second: 48 MHz / 96 and 48 MHz / 65 536
Fastest : constant Hertz := 500_000.0;
Slowest : constant Hertz := 733.0;

--  Fill Samples with conversions of the inputs in Inputs, in
--  turn from the lowest, at Rate conversions a second in all:
--  with inputs 0 and 3, Samples holds 0, 3, 0, 3 ... A sample
--  that didn't converge is replaced by the one before it from
--  the same input, and counted in Errors. Not_Supported: Rate
--  is out of range. Timeout: the FIFO overflowed or stalled,
--  and samples were lost.
procedure Capture
  (Inputs : Channel_Set; Rate : Hertz; Samples : out Sample_Array;
   Errors : out Natural; Stat : out Status)
  with Pre  => Is_Enabled
               and then (for some Ch in Channel => Inputs (Ch))
               and then (for all Ch in Channel =>
                           (if Inputs (Ch) then Is_Claimed (Ch))),
       Post => (for all S of Samples => S <= Top (Converter));
