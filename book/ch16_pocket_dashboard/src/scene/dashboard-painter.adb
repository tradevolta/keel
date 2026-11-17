--  SPDX-License-Identifier: Apache-2.0
with Keel.UI; use Keel.UI;
with Keel.UI.Canvas.Widgets;

package body Dashboard.Painter is
   package W is new Screen.Widgets;

   --  The layout, top to bottom: the clock; the gauge, its value
   --  and what it shows; the temperature, the history and the frame
   --  rate along the bottom
   Clock_Box : constant Rect := (X => 0, Y => 6, Width => 240,
                                 Height => 30);
   Dial      : constant W.Gauge_Style :=
     (X => 120, Y => 150, Radius => 96, Band => 16, others => <>);
   Value_Box : constant Rect := (X => 0, Y => 158, Width => 240,
                                 Height => 18);
   Name_Box  : constant Rect := (X => 0, Y => 178, Width => 240,
                                 Height => 10);
   Temp_Box  : constant Rect := (X => 8, Y => 202, Width => 104,
                                 Height => 18);
   Temp_Name : constant Rect := (X => 8, Y => 224, Width => 104,
                                 Height => 10);
   Past_Box  : constant Rect := (X => 128, Y => 198, Width => 104,
                                 Height => 24);
   FPS_Box   : constant Rect := (X => 128, Y => 226, Width => 104,
                                 Height => 10);

   function Percent (V : Per_Mille) return String is
      S : constant String := Natural'Image ((V + 5) / 10);
   begin
      return S (S'First + 1 .. S'Last) & "%";
   end Percent;

   procedure Paint (C : in out Screen.Canvas; R : Readings) is
      Past : W.Series (1 .. History_Length);
   begin
      for I in Past'Range loop
         Past (I) := R.Past (I);
      end loop;
      Screen.Clear (C, Night);
      W.Label (C, Clock_Box, Clock_Image (R.Seconds), Paper, Night,
               Scale => 3, Align => W.Center);
      W.Gauge (C, Dial, R.Needle);
      W.Label (C, Value_Box, Percent (R.Reading), Gold, Night,
               Scale => 2, Align => W.Center);
      W.Label (C, Name_Box,
               (if R.Source = Light then "light" else "sweep"),
               Muted, Night, Align => W.Center);
      W.Label (C, Temp_Box, Temperature_Image (R), Sky, Night,
               Scale => 2);
      W.Label (C, Temp_Name, "cpu", Muted, Night);
      W.Sparkline (C, Past_Box, Past, Moss, Night);
      W.Label (C, FPS_Box, FPS_Image (R.FPS_Tenths), Muted, Night,
               Align => W.Right);
   end Paint;
end Dashboard.Painter;
