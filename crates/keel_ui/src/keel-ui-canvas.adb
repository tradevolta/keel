--  SPDX-License-Identifier: Apache-2.0
package body Keel.UI.Canvas
  with SPARK_Mode
is
   pragma Assert (Height * Width = Pixels.Elements);

   procedure Move_To
     (C : in out Canvas; Left : Left_Edge; Top : Top_Edge) is
   begin
      C.Left := Left;
      C.Top := Top;
   end Move_To;

   procedure Clear (C : in out Canvas; Ink : Color) is
   begin
      Pixels.Fill (C.Store, Ink);
   end Clear;

   --  Clip, then put each pixel; Intersection's bounds keep the
   --  element numbers inside the buffer
   procedure Fill (C : in out Canvas; R : Rect; Ink : Color) is
      On : constant Rect := Intersection (R, Area (C));
   begin
      if Is_Empty (On) then
         return;
      end if;
      for Y in On.Y .. Bottom (On) - 1 loop
         pragma Loop_Invariant (Ours (C));
         for X in On.X .. Right (On) - 1 loop
            pragma Loop_Invariant (Ours (C));
            Pixels.Put
              (C.Store, (Y - C.Top) * Width + (X - C.Left), Ink);
         end loop;
      end loop;
   end Fill;

   procedure Point (C : in out Canvas; X, Y : Coordinate; Ink : Color)
   is
   begin
      Fill (C, (X => X, Y => Y, Width => 1, Height => 1), Ink);
   end Point;

   subtype Wide is Long_Long_Integer;

   --  V can be a coordinate
   function On_Grid (V : Wide) return Boolean is
     (V in Wide (Coordinate'First) .. Wide (Coordinate'Last));

   --  A / B to the nearest whole number, halves away from zero
   function Div_Round (A : Wide; B : Positive) return Wide is
     (if A >= 0 then (2 * A + Wide (B)) / (2 * Wide (B))
      else -((2 * (-A) + Wide (B)) / (2 * Wide (B))))
     with Pre  => A in -2**32 .. 2**32,
          Post => (if A >= 0 then Div_Round'Result in 0 .. A
                   else Div_Round'Result in A .. 0);

   subtype Side_Length is Positive range 1 .. 32;

   --  A Size by Size square with its top left pixel at (Left, Top),
   --  if that corner is a coordinate at all
   procedure Square
     (C : in out Canvas; Left, Top : Wide; Size : Side_Length;
      Ink : Color)
     with Pre  => Ours (C),
          Post => Area (C) = Area (C)'Old and then Ours (C)
   is
   begin
      if On_Grid (Left) and then On_Grid (Top) then
         Fill (C, (X      => Coordinate (Left),
                   Y      => Coordinate (Top),
                   Width  => Size,
                   Height => Size), Ink);
      end if;
   end Square;

   --  The pen: a Thick by Thick square centered on (X, Y)
   procedure Dab
     (C : in out Canvas; X, Y : Wide; Ink : Color; Thick : Thickness)
     with Pre  => Ours (C) and then X in -2**33 .. 2**33
                  and then Y in -2**33 .. 2**33,
          Post => Area (C) = Area (C)'Old and then Ours (C)
   is
      Half : constant Wide := Wide (Thick - 1) / 2;
   begin
      Square (C, X - Half, Y - Half, Thick, Ink);
   end Dab;

   --  One dab per step along the longer axis, the other coordinate
   --  rounded to the nearest pixel: no gaps, no doubled pixels
   procedure Line
     (C              : in out Canvas;
      X0, Y0, X1, Y1 : Coordinate;
      Ink            : Color;
      Thick          : Thickness := 1)
   is
      DX    : constant Wide := Wide (X1) - Wide (X0);
      DY    : constant Wide := Wide (Y1) - Wide (Y0);
      Steps : constant Natural := Natural (Wide'Max (abs DX, abs DY));
   begin
      if Steps = 0 then
         Dab (C, Wide (X0), Wide (Y0), Ink, Thick);
         return;
      end if;
      for Step in 0 .. Steps loop
         pragma Loop_Invariant
           (Area (C) = Area (C)'Loop_Entry and then Ours (C));
         Dab (C,
              Wide (X0) + Div_Round (DX * Wide (Step), Steps),
              Wide (Y0) + Div_Round (DY * Wide (Step), Steps),
              Ink, Thick);
      end loop;
   end Line;

   --  Row by row from the middle out: Half shrinks as the row moves
   --  away from Y, until Half**2 + Row**2 <= Radius * (Radius + 1)
   procedure Disc
     (C : in out Canvas; X, Y : Coordinate; Radius : Radius_Range;
      Ink : Color)
   is
      Limit : constant Natural := Radius * (Radius + 1);
      Half  : Natural := Radius;
   begin
      for Row in 0 .. Radius loop
         pragma Loop_Invariant
           (Area (C) = Area (C)'Loop_Entry and then Ours (C)
            and then Half <= Radius);
         while Half > 0 and then Half * Half + Row * Row > Limit loop
            pragma Loop_Invariant (Half in 1 .. Radius);
            pragma Loop_Variant (Decreases => Half);
            Half := Half - 1;
         end loop;
         for Side in Boolean loop
            pragma Loop_Invariant
              (Area (C) = Area (C)'Loop_Entry and then Ours (C));
            declare
               Top : constant Wide :=
                 (if Side then Wide (Y) + Wide (Row)
                  else Wide (Y) - Wide (Row));
               Left : constant Wide := Wide (X) - Wide (Half);
            begin
               if On_Grid (Top) and then On_Grid (Left)
                 and then (Side or else Row > 0)
               then
                  Fill (C, (X      => Coordinate (Left),
                            Y      => Coordinate (Top),
                            Width  => 2 * Half + 1,
                            Height => 1), Ink);
               end if;
            end;
         end loop;
      end loop;
   end Disc;

   procedure Text
     (C     : in out Canvas;
      X, Y  : Coordinate;
      S     : String;
      Ink   : Color;
      Scale : Scale_Range := 1)
   is
      Step : constant Positive := Fonts.Glyph_Size * Scale;
   begin
      for K in 0 .. S'Length - 1 loop
         pragma Loop_Invariant
           (Area (C) = Area (C)'Loop_Entry and then Ours (C));
         declare
            G : constant Fonts.Glyph :=
              Fonts.Glyph_Of (S (S'First + K));
         begin
            for Row in Fonts.Glyph_Index loop
               pragma Loop_Invariant
                 (Area (C) = Area (C)'Loop_Entry and then Ours (C));
               for Column in Fonts.Glyph_Index loop
                  pragma Loop_Invariant
                    (Area (C) = Area (C)'Loop_Entry and then Ours (C));
                  if Fonts.Is_Set (G, Row, Column) then
                     Square
                       (C,
                        Wide (X) + Wide (K * Step + Column * Scale),
                        Wide (Y) + Wide (Row * Scale),
                        Scale, Ink);
                  end if;
               end loop;
            end loop;
         end;
      end loop;
   end Text;
end Keel.UI.Canvas;
