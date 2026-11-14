--  SPDX-License-Identifier: Apache-2.0
--  What the monitor works out from its samples: each input's sum in
--  a round-robin capture, and a wave's range and frequency.
with Keel.ADC;        use Keel.ADC;
with Keel.ADC.RP2350; use Keel.ADC.RP2350;
with Keel.Units;      use Keel.Units;

package Readings is
   type Sums is array (Channel) of Natural;

   --  Add up each input's samples. A capture of Inputs holds them
   --  in turn from the lowest, so sample I belongs to the input at
   --  position (I - 1) mod (number of inputs). Each: samples per
   --  input, counting only whole rounds.
   procedure Split
     (Inputs : Channel_Set; Samples : Sample_Array;
      Total : out Sums; Each : out Natural)
     with Pre => Samples'First = 1;

   --  A wave: its lowest, highest and mean code, the times it rose
   --  through the middle, and its frequency from the first rise to
   --  the last, 0.0 with fewer than two rises
   type Wave is record
      Low, High, Mean : Code := 0;
      Rises           : Natural := 0;
      Frequency       : Hertz := 0.0;
   end record;

   function Measure (Samples : Sample_Array; Rate : Hertz) return Wave
     with Pre => Samples'Length > 0;
end Readings;
