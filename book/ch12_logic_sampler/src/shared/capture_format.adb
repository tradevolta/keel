--  SPDX-License-Identifier: Apache-2.0
package body Capture_Format is

   function Image (N : Natural) return String is
      S : constant String := N'Image;
   begin
      return S (S'First + 1 .. S'Last);
   end Image;

   procedure Header
     (Rate : Positive; Samples : Positive; Trigger_At : Natural;
      Set : Setting) is
   begin
      Put_Line
        ("capture rate=" & Image (Rate) & " samples=" & Image (Samples)
         & " trigger=" & Image (Trigger_At)
         & " level=" & Image (Set.Threshold)
         & (if Set.Slope = Rising then " rising" else " falling"));
   end Header;

   Hex : constant String := "0123456789ABCDEF";

   procedure Data (Line : Sample_Array) is
      Text : String (1 .. 5 + 3 * Line'Length) := [others => ' '];
      At_C : Positive := 6;
      V    : Level;
   begin
      Text (1 .. 5) := "data ";
      for S of Line loop
         if Failed (S) then
            Text (At_C .. At_C + 2) := "xxx";
         else
            V := Value (S);
            Text (At_C)     := Hex (V / 256 + 1);
            Text (At_C + 1) := Hex (V / 16 mod 16 + 1);
            Text (At_C + 2) := Hex (V mod 16 + 1);
         end if;
         At_C := At_C + 3;
      end loop;
      Put_Line (Text);
   end Data;

   procedure Finish (Errors : Natural) is
   begin
      Put_Line ("end errors=" & Image (Errors));
   end Finish;
end Capture_Format;
