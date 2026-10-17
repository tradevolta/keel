--  SPDX-License-Identifier: Apache-2.0
--  memgen MEMORY.TOML MEMORY.LD           write MEMORY.LD
--  memgen --check MEMORY.TOML MEMORY.LD   fail if MEMORY.LD is stale
with Ada.Command_Line; use Ada.Command_Line;
with Ada.Directories;
with Ada.Exceptions; use Ada.Exceptions;
with Ada.IO_Exceptions;
with Ada.Streams.Stream_IO; use Ada.Streams.Stream_IO;
with Ada.Text_IO;
with Memory_Map; use Memory_Map;
with Memory_Map.From_TOML;
with Memory_Map.Linker_Script;

procedure Memgen is
   Check_Only : constant Boolean :=
     Argument_Count = 3 and then Argument (1) = "--check";
   First : constant Positive := (if Check_Only then 2 else 1);

   function Read (Name : String) return String is
      F : File_Type;
   begin
      Open (F, In_File, Name);
      return Text : String (1 .. Natural (Size (F))) do
         String'Read (Stream (F), Text);
         Close (F);
      end return;
   end Read;

   procedure Fail (Message : String) is
   begin
      Ada.Text_IO.Put_Line (Ada.Text_IO.Standard_Error,
                            "memgen: " & Message);
      Set_Exit_Status (Failure);
   end Fail;
begin
   if Argument_Count /= First + 1 then
      Fail ("usage: memgen [--check] MEMORY.TOML MEMORY.LD");
      return;
   end if;

   declare
      Map : constant Board := From_TOML (Argument (First));
      Out_Name : constant String := Argument (First + 1);
   begin
      Check (Map);
      declare
         Script : constant String := Linker_Script (Map);
         F : File_Type;
      begin
         if not Check_Only then
            Create (F, Out_File, Out_Name);
            String'Write (Stream (F), Script);
            Close (F);
         elsif not Ada.Directories.Exists (Out_Name)
           or else Read (Out_Name) /= Script
         then
            Fail (Out_Name & " is stale: run tools/memgen");
         end if;
      end;
   end;
exception
   when E : Map_Error | Constraint_Error
     | Ada.IO_Exceptions.Name_Error =>
      Fail (Argument (First) & ": " & Exception_Message (E));
end Memgen;
