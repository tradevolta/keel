--  SPDX-License-Identifier: Apache-2.0
package body Keel.UI.Canvas.Widgets
  with SPARK_Mode
is
   procedure Label
     (C     : in out Canvas;
      Box   : Rect;
      S     : String;
      Ink   : Color;
      Back  : Color;
      Scale : Scale_Range := 1;
      Align : Alignment := Left)
   is
      Wide_S : constant Integer := Text_Width (S, Scale);
      Tall   : constant Integer := Fonts.Glyph_Size * Scale;
      X      : Integer := Box.X;
      Y      : constant Integer := Box.Y + (Box.Height - Tall) / 2;
   begin
      Fill (C, Box, Back);
      case Align is
         when Left   => null;
         when Center => X := Box.X + (Box.Width - Wide_S) / 2;
         when Right  => X := Right (Box) - Wide_S;
      end case;
      if X in Coordinate and then Y in Coordinate then
         Text (C, X, Y, S, Ink, Scale);
      end if;
   end Label;

   --  Each pixel of the band's bounding box that is on the canvas:
   --  in the band if its distance from the center is between the
   --  inner and outer radii; lit if it is no further round, from
   --  the left, than the value's direction V. With P the pixel as a
   --  vector, y up, that is: the cross product V x P is positive, or
   --  zero with P pointing the same way as V.
   --  V / 256 of L: a sine or cosine times a length
   function Times (V : Unit_256; L : Radius_Range) return Integer
     with Post => Times'Result in -L .. L
   is
   begin
      pragma Assert (V * L in -(256 * L) .. 256 * L);
      return V * L / 256;
   end Times;

   procedure Gauge
     (C : in out Canvas; G : Gauge_Style; Value : Per_Mille)
   is
      R     : constant Radius_Range := G.Radius;
      Theta : constant Degrees := 180 * Value / 1_000;
      VX    : constant Unit_256 := -(Cos_256 (Theta));
      VY    : constant Unit_256 := Sin_256 (Theta);
      --  The same rounding as Disc: within radius r means a squared
      --  distance of at most r * (r + 1)
      Outer : constant Natural := R * (R + 1);
      Inner : constant Natural := (R - G.Band) * (R - G.Band + 1) + 1;
      Box   : constant Rect :=
        Intersection
          ((X => G.X - R, Y => G.Y - R, Width => 2 * R + 1,
            Height => R + 1),
           Area (C));
      Reach : constant Integer := R - G.Band - 6;
   begin
      Fill (C, Box, G.Back);
      if Is_Empty (Box) then
         return;
      end if;
      for Y in Box.Y .. Bottom (Box) - 1 loop
         pragma Loop_Invariant
           (Area (C) = Area (C)'Loop_Entry and then Ours (C));
         for X in Box.X .. Right (Box) - 1 loop
            pragma Loop_Invariant
              (Area (C) = Area (C)'Loop_Entry and then Ours (C));
            declare
               --  The pixel as a vector from the center, y up
               PX : constant Integer range -R .. R := X - G.X;
               PY : constant Integer range 0 .. R := G.Y - Y;
               D  : constant Natural := PX * PX + PY * PY;
               Cr : constant Integer := VX * PY - VY * PX;
               Dt : constant Integer := VX * PX + VY * PY;
               Lit : constant Boolean :=
                 Value > 0
                 and then (Cr > 0 or else (Cr = 0 and then Dt > 0));
            begin
               if D in Inner .. Outer then
                  Point (C, X, Y, (if Lit then G.Ink else G.Track));
               end if;
            end;
         end loop;
      end loop;
      if Reach > 0 then
         Line (C, G.X, G.Y,
               G.X + Times (VX, Reach), G.Y - Times (VY, Reach),
               G.Needle, Thick => 3);
      end if;
      Disc (C, G.X, G.Y, 6, G.Needle);
   end Gauge;

   --  K parts in Last of Span: from 0 up to Span
   function Part (K, Last, Span : Natural) return Natural
     with Pre  => Last in 1 .. 2**15 and then K <= Last
                  and then Span <= 2**15,
          Post => Part'Result <= Span
   is
   begin
      pragma Assert (K * Span <= Last * Span);
      pragma Assert (Last * Span / Last = Span);
      return K * Span / Last;
   end Part;

   procedure Sparkline
     (C      : in out Canvas;
      Box    : Rect;
      Values : Series;
      Ink    : Color;
      Back   : Color)
   is
      Last   : constant Positive := Values'Length - 1;
      Across : constant Natural := Box.Width - 1;
      Down   : constant Natural := Box.Height - 1;
      Floor  : constant Coordinate := Box.Y + Down;
   begin
      Fill (C, Box, Back);
      for K in 1 .. Last loop
         pragma Loop_Invariant
           (Area (C) = Area (C)'Loop_Entry and then Ours (C));
         declare
            Was : constant Per_Mille := Values (Values'First + K - 1);
            Now : constant Per_Mille := Values (Values'First + K);
         begin
            Line (C,
                  Box.X + Part (K - 1, Last, Across),
                  Floor - Part (Was, 1_000, Down),
                  Box.X + Part (K, Last, Across),
                  Floor - Part (Now, 1_000, Down),
                  Ink);
         end;
      end loop;
   end Sparkline;
end Keel.UI.Canvas.Widgets;
