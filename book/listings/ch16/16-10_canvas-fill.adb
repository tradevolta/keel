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
