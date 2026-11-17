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
