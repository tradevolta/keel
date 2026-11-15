--  SPDX-License-Identifier: Apache-2.0
--  The logic sampler's trigger: a level crossed in one direction,
--  with a band of hysteresis so that noise around the level doesn't
--  fire it twice. Samples come as the ADC's FIFO gives them to the
--  DMA: the code in bits 0 to 11, the error flag in bit 15. A sample
--  whose conversion failed is skipped: it neither arms nor fires.
package Trigger
  with Pure, SPARK_Mode
is
   type Sample is mod 2**16;

   subtype Level is Natural range 0 .. 4_095;

   function Value (S : Sample) return Level is
     (Level (S and 16#0FFF#));
   function Failed (S : Sample) return Boolean is
     ((S and 16#8000#) /= 0);

   type Edge is (Rising, Falling);

   --  Rising: fire when the input reaches Threshold, once it has
   --  been below Threshold - Band. Falling: the mirror image.
   type Setting is record
      Threshold : Level := 2_048;
      Band      : Level := 64;
      Slope     : Edge := Rising;
   end record;

   --  Armed: the input has been on the far side of the band
   type State is record
      Armed : Boolean := False;
   end record;

   --  Look at one sample. Fired: this sample crossed the level.
   procedure Step
     (S : in out State; Set : Setting; X : Sample; Fired : out Boolean)
     with Post =>
       (if Fired then
          not Failed (X)
          and then S'Old.Armed and then not S.Armed
          and then (if Set.Slope = Rising
                    then Value (X) >= Set.Threshold
                    else Value (X) <= Set.Threshold));
end Trigger;
