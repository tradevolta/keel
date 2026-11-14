--  SPDX-License-Identifier: Apache-2.0
package body Explorer is

   function Plan_For
     (L : PLL_Limits; Ref, Target : Frequency; Overclock : Boolean)
      return Plan
   is
      C     : PLL_Config;
      Found : Boolean;
   begin
      if Target = Ref then
         return (Kind => From_Reference, Target => Target);
      end if;
      Solve (L, Ref, Target, Overclock, C, Found);
      if Found then
         return (Kind => From_PLL, Target => Target, Setting => C);
      else
         return (Kind => Refused, Target => Target);
      end if;
   end Plan_For;

   --  Natural'Image without its leading space
   function Img (N : Natural) return String is
      S : constant String := Natural'Image (N);
   begin
      return S (S'First + 1 .. S'Last);
   end Img;

   function MHz_Image (kHz : Natural) return String is
     (if kHz >= 10_000
      then Img ((kHz + 500) / 1_000) & " MHz"
      else Img ((kHz + 50) / 1_000) & "."
           & Img (((kHz + 50) / 100) mod 10) & " MHz");

   function Setting_Image (C : PLL_Config) return String is
     (Img (Natural (Reference (C) / 1_000_000)) & " MHz / "
      & Img (Ref_Div (C)) & " * " & Img (Feedback (C))
      & " / " & Img (Post_1 (C)) & " / " & Img (Post_2 (C))
      & " (VCO " & Img (Natural (VCO (C) / 1_000_000)) & " MHz)");
end Explorer;
