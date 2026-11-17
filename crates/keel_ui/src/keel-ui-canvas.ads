--  SPDX-License-Identifier: Apache-2.0
--  Keel.UI.Canvas: a rectangle of pixels in RAM, and where it sits on
--  the screen. Its pixels are a Keel.DMA.Buffers buffer, so a driver
--  can lend the whole canvas to the DMA and send it to a display
--  while the program draws on another. A canvas as big as the screen
--  is a framebuffer; a smaller one is a tile, which the program
--  moves down the screen and draws the scene into once per tile.
--  Every operation takes screen coordinates and clips to the canvas:
--  drawing off its edge, even far off, is never an error and never
--  touches memory outside it.
with Keel.DMA.Buffers;
with Keel.UI.Fonts;

generic
   --  Pixels in a row. Pixels.Elements is a whole number of rows.
   Width : Positive;
   with package Pixels is new Keel.DMA.Buffers
     (Element => Color, others => <>);
package Keel.UI.Canvas
  with SPARK_Mode
is
   pragma Compile_Time_Error
     (Width > Extent'Last or else Pixels.Elements < Width
      or else Pixels.Elements mod Width /= 0
      or else Pixels.Elements / Width > Extent'Last,
      "a canvas is a whole number of rows of at most 32 768 pixels");

   Height : constant Positive := Pixels.Elements / Width;

   use type Pixels.Holder;

   --  Where the top left corner can go: anywhere the whole canvas
   --  still has coordinates
   subtype Left_Edge is Coordinate
     range Coordinate'First .. Coordinate'Last + 1 - Width;
   subtype Top_Edge is Coordinate
     range Coordinate'First .. Coordinate'Last + 1 - Height;

   --  Pixel (X, Y) on the screen is element
   --  (Y - Top) * Width + (X - Left) of Store
   type Canvas is limited record
      Store : Pixels.Buffer;
      Left  : Left_Edge := 0;
      Top   : Top_Edge := 0;
   end record;

   function Ours (C : Canvas) return Boolean is
     (Pixels.Owner (C.Store) = Pixels.Program);

   --  The part of the screen C covers
   function Area (C : Canvas) return Rect is
     ((X => C.Left, Y => C.Top, Width => Width, Height => Height));

   --  Put C's top left corner at (Left, Top) on the screen. The
   --  pixels stay as they are: draw the new place before sending it.
   procedure Move_To
     (C : in out Canvas; Left : Left_Edge; Top : Top_Edge)
     with Pre  => Ours (C),
          Post => Ours (C) and then C.Left = Left and then C.Top = Top;

   --  Every pixel of C
   procedure Clear (C : in out Canvas; Ink : Color)
     with Pre  => Ours (C),
          Post => Area (C) = Area (C)'Old and then Ours (C);

   --  The pixels of R that are on C
   procedure Fill (C : in out Canvas; R : Rect; Ink : Color)
     with Pre  => Ours (C),
          Post => Area (C) = Area (C)'Old and then Ours (C);

   procedure Point (C : in out Canvas; X, Y : Coordinate; Ink : Color)
     with Pre  => Ours (C),
          Post => Area (C) = Area (C)'Old and then Ours (C);

   --  A line from (X0, Y0) to (X1, Y1), both ends included, drawn
   --  with a square pen Thick pixels wide
   subtype Thickness is Positive range 1 .. 32;
   procedure Line
     (C              : in out Canvas;
      X0, Y0, X1, Y1 : Coordinate;
      Ink            : Color;
      Thick          : Thickness := 1)
     with Pre  => Ours (C),
          Post => Area (C) = Area (C)'Old and then Ours (C);

   --  A filled circle: the pixels whose centers are within Radius of
   --  (X, Y)
   subtype Radius_Range is Natural range 0 .. 2_048;
   procedure Disc
     (C : in out Canvas; X, Y : Coordinate; Radius : Radius_Range;
      Ink : Color)
     with Pre  => Ours (C),
          Post => Area (C) = Area (C)'Old and then Ours (C);

   --  Text in Font_8x8, its top left corner at (X, Y), each font
   --  pixel Scale by Scale screen pixels. Only the glyphs' set pixels
   --  are drawn: what is under the rest shows through.
   subtype Scale_Range is Positive range 1 .. 8;
   procedure Text
     (C     : in out Canvas;
      X, Y  : Coordinate;
      S     : String;
      Ink   : Color;
      Scale : Scale_Range := 1)
     with Pre  => Ours (C) and then S'Length <= 1_000,
          Post => Area (C) = Area (C)'Old and then Ours (C);

   --  The width Text gives S, in screen pixels
   function Text_Width (S : String; Scale : Scale_Range) return Natural
   is (S'Length * Fonts.Glyph_Size * Scale)
     with Pre => S'Length <= 1_000;
end Keel.UI.Canvas;
