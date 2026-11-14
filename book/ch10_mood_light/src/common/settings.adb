--  SPDX-License-Identifier: Apache-2.0
with Keel.PWM;   use Keel.PWM;

package body Settings is

   --  Natural'Image without its leading space
   function Img (N : Natural) return String is
      S : constant String := N'Image;
   begin
      return S (S'First + 1 .. S'Last);
   end Img;

   function Image (S : Setting) return String is
     ("div " & Img (Div (S)) & "/16, top " & Img (Top (S))
      & (if Mode (S) = Phase_Correct then ", phase correct, "
         else ", trailing edge, ")
      & Img (Natural (Output (S))) & " Hz");
end Settings;
