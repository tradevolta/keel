--  SPDX-License-Identifier: Apache-2.0
--  Keel.UI.Canvas.Widgets: things a dashboard is made of, drawn with
--  the canvas operations, so they clip the same way. Each draws all
--  of its own area, background included, which lets a program draw
--  a scene into a tile at a time: a widget that crosses the tile's
--  edge draws the part that's on it.
generic
package Keel.UI.Canvas.Widgets
  with SPARK_Mode
is
   type Alignment is (Left, Center, Right);

   --  Box filled with Back, and S in it, centered top to bottom
   procedure Label
     (C     : in out Canvas;
      Box   : Rect;
      S     : String;
      Ink   : Color;
      Back  : Color;
      Scale : Scale_Range := 1;
      Align : Alignment := Left)
     with Pre  => Ours (C) and then S'Length <= 1_000,
          Post => Area (C) = Area (C)'Old and then Ours (C);

   subtype Per_Mille is Natural range 0 .. 1_000;

   --  A half-ring gauge: a band from the left, over the top, to the
   --  right, lit in Ink from the left up to Value, and a needle
   subtype Middle is Coordinate range -2**14 .. 2**14;
   type Gauge_Style is record
      X, Y   : Middle := 0;        --  the center
      Radius : Radius_Range := 96;  --  outer edge of the band
      Band   : Radius_Range := 16;  --  its width
      Track  : Color := Slate;      --  the unlit band
      Ink    : Color := Rust;       --  the lit band
      Needle : Color := Paper;
      Back   : Color := Night;
   end record
     with Predicate => Band in 1 .. Radius;

   procedure Gauge
     (C : in out Canvas; G : Gauge_Style; Value : Per_Mille)
     with Pre  => Ours (C),
          Post => Area (C) = Area (C)'Old and then Ours (C);

   --  A line through Values, oldest on the left, 0 at the bottom of
   --  Box and 1 000 at the top
   type Series is array (Positive range <>) of Per_Mille;

   procedure Sparkline
     (C      : in out Canvas;
      Box    : Rect;
      Values : Series;
      Ink    : Color;
      Back   : Color)
     with Pre  => Ours (C) and then Values'Length in 2 .. 1_024
                  and then Box.Width >= 2 and then Box.Height >= 2
                  and then Box.X <= Coordinate'Last - Box.Width
                  and then Box.Y <= Coordinate'Last - Box.Height,
          Post => Area (C) = Area (C)'Old and then Ours (C);
end Keel.UI.Canvas.Widgets;
