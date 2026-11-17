--  SPDX-License-Identifier: Apache-2.0
--  The dashboard's scene, drawn on any canvas: a whole frame or one
--  strip of it. Each widget clips to the canvas, so a strip gets
--  exactly its part of the frame.
with Keel.UI.Canvas;

generic
   with package Screen is new Keel.UI.Canvas (<>);
package Dashboard.Painter is
   --  The part of the screen, 240 x 240, at (0, 0), that C covers
   procedure Paint (C : in out Screen.Canvas; R : Readings)
     with Pre => Screen.Ours (C);
end Dashboard.Painter;
