--  SPDX-License-Identifier: Apache-2.0
with Ada.Strings.Fixed; use Ada.Strings.Fixed;
with Ada.Strings.Unbounded; use Ada.Strings.Unbounded;
with Ada.Text_IO;       use Ada.Text_IO;

package body Plots is

   Band : constant := 64;

   --  Float to text with D decimals, no leading space
   function Img (X : Float; D : Natural := 2) return String is
      Scaled : constant Integer := Integer (X * 10.0**D);
      Sign   : constant String := (if Scaled < 0 then "-" else "");
      Whole  : constant String := Trim (Integer'Image
                 (abs Scaled / 10**D), Ada.Strings.Left);
      Frac   : String (1 .. D);
      F      : Natural := abs Scaled mod 10**D;
   begin
      if D = 0 then
         return Sign & Whole;
      end if;
      for K in reverse Frac'Range loop
         Frac (K) := Character'Val (48 + F mod 10);
         F := F / 10;
      end loop;
      return Sign & Whole & "." & Frac;
   end Img;

   function Img (N : Integer) return String is
     (Trim (N'Image, Ada.Strings.Left));

   --  Milliseconds from the trigger to sample K
   function Ms (C : Capture; K : Integer) return Float is
     (Float (K - C.Trigger_At) * 1_000.0 / Float (C.Rate));

   procedure Summary (C : Capture) is
      N      : constant Natural := Natural (C.Samples.Length);
      Lo     : Code := 4_095;
      Hi     : Code := 0;
      Armed  : Boolean := False;
      First  : Integer := -1;
      Last   : Integer := -1;
      Count  : Natural := 0;
      List   : Unbounded_String;
   begin
      for K in 0 .. N - 1 loop
         declare
            X : constant Code := C.Samples (K);
         begin
            if X /= No_Code then
               Lo := Code'Min (Lo, X);
               Hi := Code'Max (Hi, X);
               if X < C.Level - Band then
                  Armed := True;
               elsif Armed and then X >= C.Level then
                  Armed := False;
                  Count := Count + 1;
                  if First < 0 then
                     First := K;
                  end if;
                  Last := K;
                  List := List & " " & Img (K);
               end if;
            end if;
         end;
      end loop;
      Put_Line ("capture:" & N'Image & " samples at" & C.Rate'Image
                & " S/s, " & Img (Float (N) * 1_000.0
                                  / Float (C.Rate), 3) & " ms");
      Put_Line ("trigger: sample" & C.Trigger_At'Image
                & (if C.Rising then ", rising" else ", falling")
                & " through" & C.Level'Image & " ("
                & Img (Volts (C.Level), 3) & " V)");
      Put_Line ("range:  " & Lo'Image & " .." & Hi'Image & " ("
                & Img (Volts (Lo), 3) & " .. " & Img (Volts (Hi), 3)
                & " V), errors" & C.Errors'Image);
      Put_Line ("rising crossings at" & To_String (List));
      if Count >= 2 then
         declare
            Period : constant Float :=
              Float (Last - First) / Float (Count - 1);
         begin
            Put_Line ("period: " & Img (Period, 1) & " samples, "
                      & Img (Float (C.Rate) / Period, 1) & " Hz");
         end;
      end if;
   end Summary;

   procedure Text_Plot (C : Capture; Width : Positive := 64) is
      Rows : constant := 12;
      N    : constant Natural := Natural (C.Samples.Length);
      type Grid is array (0 .. Rows - 1, 0 .. Width - 1) of Character;
      G    : Grid := [others => [others => ' ']];
      Lvl  : constant Natural := Rows - 1 - C.Level * Rows / 4_096;
      Trig : constant Natural := C.Trigger_At * Width / N;

      function Row (X : Code) return Natural is
        (Rows - 1 - X * Rows / 4_096);
   begin
      for Col in 0 .. Width - 1 loop
         G (Lvl, Col) := '.';
         declare
            Lo : Natural := Rows;
            Hi : Integer := -1;
         begin
            for K in Col * N / Width .. (Col + 1) * N / Width - 1 loop
               if C.Samples (K) /= No_Code then
                  Lo := Natural'Min (Lo, Row (C.Samples (K)));
                  Hi := Integer'Max (Hi, Row (C.Samples (K)));
               end if;
            end loop;
            for R in Lo .. Hi loop
               G (R, Col) := '*';
            end loop;
         end;
      end loop;
      for R in 0 .. Rows - 1 loop
         declare
            Label : String (1 .. 7) := [others => ' '];
            Line  : String (1 .. Width);
         begin
            if R = 0 then
               Label := "3.3 V |";
            elsif R = Lvl then
               Label := Head (Img (Volts (C.Level), 2), 6) & "|";
            elsif R = Rows - 1 then
               Label := "  0 V |";
            else
               Label (7) := '|';
            end if;
            for Col in Line'Range loop
               Line (Col) := G (R, Col - 1);
            end loop;
            Put_Line (Trim (Label & Line, Ada.Strings.Right));
         end;
      end loop;
      Put_Line ("      +" & Width * '-');
      Put_Line (7 * ' ' & Trig * ' ' & "^ trigger");
      declare
         L : constant String := Img (Ms (C, 0), 1) & " ms";
         R : constant String := "+" & Img (Ms (C, N), 1) & " ms";
      begin
         Put_Line (7 * ' ' & L & (Width - L'Length - R'Length) * ' '
                   & R);
      end;
   end Text_Plot;

   procedure SVG (C : Capture; Name : String; Note : String) is
      N      : constant Natural := Natural (C.Samples.Length);
      Left   : constant Float := 70.0;
      Right  : constant Float := 620.0;
      Top    : constant Float := 34.0;
      Bottom : constant Float := 244.0;
      F      : File_Type;

      function X_Of (K : Float) return Float is
        (Left + (Right - Left) * K / Float (N));
      function Y_Of (V : Float) return Float is
        (Bottom - (Bottom - Top) * V / 3.3);

      procedure P (S : String) is
      begin
         Put_Line (F, S);
      end P;

      procedure Line (X1, Y1, X2, Y2 : Float; Class : String) is
      begin
         P ("  <line class=""" & Class & """ x1=""" & Img (X1, 1)
            & """ y1=""" & Img (Y1, 1) & """ x2=""" & Img (X2, 1)
            & """ y2=""" & Img (Y2, 1) & """/>");
      end Line;

      procedure Text (X, Y : Float; S, Anchor : String) is
      begin
         P ("  <text x=""" & Img (X, 1) & """ y=""" & Img (Y, 1)
            & """ text-anchor=""" & Anchor & """>" & S & "</text>");
      end Text;

      Title : constant String :=
        "Logic sampler capture" & (if Note = "" then "" else
                                     ", " & Note);
      Span  : constant Float := Float (N) * 1_000.0 / Float (C.Rate);
      Ms0   : constant Integer := Integer (Float'Floor (Ms (C, 0)));
      Ms1   : constant Integer := Integer (Float'Floor (Ms (C, N)));
   begin
      Create (F, Out_File, Name);
      P ("<?xml version=""1.0"" encoding=""UTF-8""?>");
      P ("<svg xmlns=""http://www.w3.org/2000/svg"" "
         & "viewBox=""0 0 640 300"" width=""640"" height=""300"" "
         & "role=""img"" aria-labelledby=""t d"">");
      P ("  <title id=""t"">" & Title & "</title>");
      P ("  <desc id=""d"">The voltage on the probe against time, "
         & Img (N) & " samples at " & Img (C.Rate) & " samples a "
         & "second, " & Img (Span, 3) & " ms. Time is in "
         & "milliseconds from the trigger, the first sample at or "
         & "above " & Img (Volts (C.Level), 2) & " V after the "
         & "input was below the band under it; a dashed line marks "
         & "the trigger and a dotted one the level.</desc>");
      P ("  <style>");
      P ("    text { font-family: ""DM Sans"", ""DM Sans 9pt"", "
         & "Arial, sans-serif; font-size: 11px; fill: #000; }");
      P ("    .grid { stroke: #b3b3b3; stroke-width: 0.6; }");
      P ("    .axis { stroke: #000; stroke-width: 1.2; }");
      P ("    .trace { stroke: #000; stroke-width: 1.4; fill: none; }");
      P ("    .trig { stroke: #000; stroke-width: 1; "
         & "stroke-dasharray: 6 3; }");
      P ("    .level { stroke: #595959; stroke-width: 1; "
         & "stroke-dasharray: 2 3; }");
      P ("  </style>");
      for Tenth in 0 .. 3 loop
         declare
            V : constant Float := 1.1 * Float (Tenth);
         begin
            Line (Left, Y_Of (V), Right, Y_Of (V), "grid");
            Text (Left - 6.0, Y_Of (V) + 4.0, Img (V, 1) & " V", "end");
         end;
      end loop;
      for M in Ms0 .. Ms1 loop
         declare
            K : constant Float :=
              Float (C.Trigger_At)
              + Float (M) * Float (C.Rate) / 1_000.0;
         begin
            if K >= 0.0 and then K <= Float (N) then
               Line (X_Of (K), Top, X_Of (K), Bottom, "grid");
               Text (X_Of (K), Bottom + 16.0, Img (M), "middle");
            end if;
         end;
      end loop;
      Text ((Left + Right) / 2.0, Bottom + 34.0,
            "milliseconds from the trigger", "middle");
      Line (Left, Bottom, Right, Bottom, "axis");
      Line (Left, Top, Left, Bottom, "axis");
      Line (Left, Y_Of (Volts (C.Level)), Right,
            Y_Of (Volts (C.Level)), "level");
      Line (X_Of (Float (C.Trigger_At)), Top - 8.0,
            X_Of (Float (C.Trigger_At)), Bottom, "trig");
      Text (X_Of (Float (C.Trigger_At)) + 4.0, Top - 2.0, "trigger",
            "start");
      Put (F, "  <polyline class=""trace"" points=""");
      for K in 0 .. N - 1 loop
         if C.Samples (K) /= No_Code then
            Put (F, Img (X_Of (Float (K) + 0.5), 1) & ","
                 & Img (Y_Of (Volts (C.Samples (K))), 1)
                 & (if K mod 8 = 7 then ASCII.LF & "    " else " "));
         end if;
      end loop;
      P ("""/>");
      Text (Left, 18.0, Title, "start");
      P ("</svg>");
      Close (F);
   end SVG;
end Plots;
