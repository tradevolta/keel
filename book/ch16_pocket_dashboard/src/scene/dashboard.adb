--  SPDX-License-Identifier: Apache-2.0
package body Dashboard is

   procedure Record_Reading (R : in out Readings; Value : Per_Mille) is
   begin
      R.Past (1 .. History_Length - 1) := R.Past (2 .. History_Length);
      R.Past (History_Length) := Value;
      R.Reading := Value;
   end Record_Reading;

   function Two (N : Natural) return String is
     [Character'Val (Character'Pos ('0') + N / 10 mod 10),
      Character'Val (Character'Pos ('0') + N mod 10)];

   function Clock_Image (Seconds : Natural) return String is
     (Two (Seconds / 3_600 mod 24) & ":" & Two (Seconds / 60 mod 60)
      & ":" & Two (Seconds mod 60));

   function Decimal (Tenths : Natural) return String is
      S : constant String := Natural'Image (Tenths / 10);
   begin
      return S (S'First + 1 .. S'Last) & "."
        & Character'Val (Character'Pos ('0') + Tenths mod 10);
   end Decimal;

   function Temperature_Image (R : Readings) return String is
     (if not R.Has_Temp then "n/a"
      elsif R.Centi_C < 0
      then "-" & Decimal ((-R.Centi_C + 5) / 10) & " C"
      else Decimal ((R.Centi_C + 5) / 10) & " C");

   function FPS_Image (Tenths : Natural) return String is
     ((if Tenths = 0 then "--" else Decimal (Tenths)) & " fps");

   function MHz_Image (Hz : Natural) return String is
      Whole : constant String := Natural'Image (Hz / 1_000_000);
      Milli : constant String :=
        Natural'Image (1_000 + Hz / 1_000 mod 1_000);
   begin
      return Whole (2 .. Whole'Last) & "." & Milli (3 .. 5) & " MHz";
   end MHz_Image;
end Dashboard;
