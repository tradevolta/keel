--  SPDX-License-Identifier: Apache-2.0
package body Keel.UI.Fonts
  with SPARK_Mode
is
   function Glyph_Of (C : Character) return Glyph is
     (if C in Printable then Font_8x8 (C) else Font_8x8 ('?'));
end Keel.UI.Fonts;
