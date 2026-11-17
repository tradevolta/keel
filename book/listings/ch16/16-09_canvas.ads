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
