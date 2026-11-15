--  SPDX-License-Identifier: Apache-2.0
--  The text a capture travels in, from the sampler over RTT to the
--  host's viewer. One header line, then the samples in time order,
--  20 to a line as three hex digits each ("xxx" for a sample whose
--  conversion failed), then an end line:
--
--     capture rate=500000 samples=3584 trigger=1024 level=2048 rising
--     data 7FE801803...
--     end errors=0
--
--  trigger= is the first sample after the crossing, counted from 0.
with Trigger; use Trigger;

generic
   with procedure Put_Line (Text : String);
package Capture_Format is
   Per_Line : constant := 20;

   type Sample_Array is array (Positive range <>) of Sample;

   procedure Header
     (Rate : Positive; Samples : Positive; Trigger_At : Natural;
      Set : Setting);

   --  One data line
   procedure Data (Line : Sample_Array)
     with Pre => Line'Length in 1 .. Per_Line;

   procedure Finish (Errors : Natural);

   --  N without the space that 'Image puts in front
   function Image (N : Natural) return String;
end Capture_Format;
