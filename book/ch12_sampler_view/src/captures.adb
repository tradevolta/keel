--  SPDX-License-Identifier: Apache-2.0
with Ada.Strings.Fixed; use Ada.Strings.Fixed;
with Ada.Text_IO;       use Ada.Text_IO;

package body Captures is

   --  The value after Key= in Line, up to the next space
   function Field (Line, Key : String) return String is
      K : constant Natural := Index (Line, " " & Key & "=");
      F : Positive;
      L : Natural;
   begin
      if K = 0 then
         return "";
      end if;
      F := K + Key'Length + 2;
      L := Index (Line (F .. Line'Last), " ");
      return Line (F .. (if L = 0 then Line'Last else L - 1));
   end Field;

   function Hex (S : String) return Code is
      V : Natural := 0;
   begin
      if S = "xxx" then
         return No_Code;
      end if;
      for Ch of S loop
         V := 16 * V + (case Ch is
                          when '0' .. '9' => Character'Pos (Ch) - 48,
                          when 'A' .. 'F' => Character'Pos (Ch) - 55,
                          when others     => raise Data_Error);
      end loop;
      return V;
   end Hex;

   procedure Read (Name : String; C : out Capture; Found : out Boolean)
   is
      File  : File_Type;
      From_File : Boolean := False;
      Work  : Capture;
      Busy  : Boolean := False;

      function Next return String is
        (if From_File then Get_Line (File) else Get_Line);
      function At_End return Boolean is
        (if From_File then End_Of_File (File) else End_Of_File);
   begin
      Found := False;
      if Name /= "" then
         Open (File, In_File, Name);
         From_File := True;
      end if;
      while not At_End loop
         declare
            Line : constant String := Next;
         begin
            if Line'Length > 8 and then Head (Line, 8) = "capture " then
               Work := (others => <>);
               Work.Rate := Positive'Value (Field (Line, "rate"));
               Work.Trigger_At :=
                 Natural'Value (Field (Line, "trigger"));
               Work.Level := Code'Value (Field (Line, "level"));
               Work.Rising := Index (Line, " rising") > 0;
               Busy := True;
            elsif Busy and then Line'Length > 5
              and then Head (Line, 5) = "data "
            then
               for K in 0 .. (Line'Length - 5) / 3 - 1 loop
                  Work.Samples.Append
                    (Hex (Line (Line'First + 5 + 3 * K
                                .. Line'First + 7 + 3 * K)));
               end loop;
            elsif Busy and then Index (Line, "end errors=") = Line'First
            then
               Work.Errors := Natural'Value
                 (Line (Line'First + 11 .. Line'Last));
               C := Work;
               Found := True;
               Busy := False;
            end if;
         end;
      end loop;
      if From_File then
         Close (File);
      end if;
   end Read;
end Captures;
