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
