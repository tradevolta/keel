--  SPDX-License-Identifier: Apache-2.0
--  What the viewer shows: a summary, a plot in text for a terminal,
--  and an SVG for a page.
with Captures; use Captures;

package Plots is
   --  The rate, the trigger, the range, and the rising crossings
   --  (with the sampler's 64-code band) and the period they give
   procedure Summary (C : Capture);

   --  Width columns of plot, 12 rows from 0 to 3.3 V, with the
   --  level dotted across and the trigger marked under the axis
   procedure Text_Plot (C : Capture; Width : Positive := 64)
     with Pre => not C.Samples.Is_Empty;

   --  An SVG of the trace, 640 by 300, in the book's figure style.
   --  Note goes into its title, such as "simulated".
   procedure SVG (C : Capture; Name : String; Note : String)
     with Pre => not C.Samples.Is_Empty;
end Plots;
