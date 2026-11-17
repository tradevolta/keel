--  SPDX-License-Identifier: Apache-2.0
package body Keel.UI
  with SPARK_Mode
is
   function Intersection (A, B : Rect) return Rect is
      X0 : constant Coordinate := Integer'Max (A.X, B.X);
      Y0 : constant Coordinate := Integer'Max (A.Y, B.Y);
      X1 : constant Integer := Integer'Min (Right (A), Right (B));
      Y1 : constant Integer := Integer'Min (Bottom (A), Bottom (B));
   begin
      if X1 <= X0 or else Y1 <= Y0 then
         return (X => X0, Y => Y0, Width => 0, Height => 0);
      end if;
      return (X => X0, Y => Y0, Width => X1 - X0, Height => Y1 - Y0);
   end Intersection;
end Keel.UI;
