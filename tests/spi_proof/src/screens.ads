--  SPDX-License-Identifier: Apache-2.0
--  The canvases Chapter 16's dashboard uses, instantiated for the
--  proof: a whole 240 x 240 frame and a 240 x 24 strip
with Keel.DMA.Buffers;
with Keel.UI.Canvas.Widgets;

package Screens
  with SPARK_Mode
is
   use Keel.UI;

   package Frame_Pixels is new Keel.DMA.Buffers (Color, 240 * 240);
   package Frames is new Keel.UI.Canvas (240, Frame_Pixels);
   package Frame_Widgets is new Frames.Widgets;

   package Strip_Pixels is new Keel.DMA.Buffers (Color, 240 * 24);
   package Strips is new Keel.UI.Canvas (240, Strip_Pixels);
   package Strip_Widgets is new Strips.Widgets;
end Screens;
