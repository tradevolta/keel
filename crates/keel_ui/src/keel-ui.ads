--  SPDX-License-Identifier: Apache-2.0
--  Keel.UI: what keel_ui draws with. A color is an RGB565 pixel, the
--  format an ST7789 takes with COLMOD 0x55, as most small color
--  panels do. Screen coordinates count right and down from the top
--  left corner. A rectangle is a corner and a size; its
--  intersection with another is proved exact, and every drawing
--  operation in Keel.UI.Canvas clips through it.
package Keel.UI
  with Pure, SPARK_Mode
is
   --  Red in bits 15:11, green in 10:5, blue in 4:0
   type Color is mod 2**16;
   subtype Level is Natural range 0 .. 255;

   --  An 8-bit-a-channel color, each channel cut to its top bits
   function RGB (R, G, B : Level) return Color is
     (Color (R / 8) * 2**11 + Color (G / 4) * 2**5 + Color (B / 8));

   Black : constant Color := 16#0000#;
   White : constant Color := 16#FFFF#;
   --  The book's palette, through RGB: #1A1A2E, #F5F0E8, #C8401A,
   --  #1A6B8A, #4A7C3F, #B8982A, #7EC8E3, #6B6350 and #3A3A52
   Night : constant Color := 16#18C5#;
   Paper : constant Color := 16#F79D#;
   Rust  : constant Color := 16#CA03#;
   Teal  : constant Color := 16#1B51#;
   Moss  : constant Color := 16#4BE7#;
   Gold  : constant Color := 16#BCC5#;
   Sky   : constant Color := 16#7E5C#;
   Muted : constant Color := 16#6B0A#;
   Slate : constant Color := 16#39CA#;

   --  x to the right, y down. A canvas can sit anywhere in this
   --  range, and drawing may start or end outside it.
   subtype Coordinate is Integer range -2**15 .. 2**15 - 1;
   subtype Extent is Natural range 0 .. 2**15;

   type Rect is record
      X, Y          : Coordinate := 0;
      Width, Height : Extent     := 0;
   end record;

   function Is_Empty (R : Rect) return Boolean is
     (R.Width = 0 or else R.Height = 0);

   --  The first column and row past R
   function Right (R : Rect) return Integer is (R.X + R.Width);
   function Bottom (R : Rect) return Integer is (R.Y + R.Height);

   function Contains (R : Rect; X, Y : Integer) return Boolean is
     (X >= R.X and then X < Right (R)
      and then Y >= R.Y and then Y < Bottom (R));

   --  Every point of Inner is in Outer, as the bounds show
   function Inside (Inner, Outer : Rect) return Boolean is
     (Is_Empty (Inner)
      or else (Inner.X >= Outer.X and then Inner.Y >= Outer.Y
               and then Right (Inner) <= Right (Outer)
               and then Bottom (Inner) <= Bottom (Outer)));

   --  The points in both A and B, and no others
   function Intersection (A, B : Rect) return Rect
     with Post =>
       Inside (Intersection'Result, A)
       and then Inside (Intersection'Result, B)
       and then
       (for all X in Coordinate =>
          (for all Y in Coordinate =>
             Contains (Intersection'Result, X, Y)
             = (Contains (A, X, Y) and then Contains (B, X, Y))));

   --  Sine and cosine of a whole number of degrees, times 256
   subtype Degrees is Natural range 0 .. 360;
   subtype Unit_256 is Integer range -256 .. 256;
   function Sin_256 (D : Degrees) return Unit_256;
   function Cos_256 (D : Degrees) return Unit_256 is
     (Sin_256 ((D + 90) mod 360));

private
   --  sin (0 .. 90 degrees) * 256, rounded
   type Quarter_Wave is array (0 .. 90) of Natural range 0 .. 256;
   Quarter : constant Quarter_Wave :=
     [0, 4, 9, 13, 18, 22, 27, 31, 36, 40, 44, 49, 53, 58, 62, 66, 71,
      75, 79, 83, 88, 92, 96, 100, 104, 108, 112, 116, 120, 124, 128,
      132, 136, 139, 143, 147, 150, 154, 158, 161, 165, 168, 171, 175,
      178, 181, 184, 187, 190, 193, 196, 199, 202, 204, 207, 210, 212,
      215, 217, 219, 222, 224, 226, 228, 230, 232, 234, 236, 237, 239,
      241, 242, 243, 245, 246, 247, 248, 249, 250, 251, 252, 253, 254,
      254, 255, 255, 255, 256, 256, 256, 256];

   function Sin_256 (D : Degrees) return Unit_256 is
     (if D <= 90 then Quarter (D)
      elsif D <= 180 then Quarter (180 - D)
      elsif D <= 270 then -Quarter (D - 180)
      else -Quarter (360 - D));
end Keel.UI;
