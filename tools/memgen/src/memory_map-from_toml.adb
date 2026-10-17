--  SPDX-License-Identifier: Apache-2.0
with TOML; use TOML;
with TOML.File_IO;

function Memory_Map.From_TOML (File_Name : String) return Board is
   Result : constant Read_Result := TOML.File_IO.Load_File (File_Name);
begin
   if not Result.Success then
      raise Map_Error with Format_Error (Result);
   end if;

   declare
      Doc : constant TOML_Value := Result.Value;
      List : constant TOML_Value := Doc.Get ("region");
      Stack : constant TOML_Value := Doc.Get ("stack");
      Stack_Name : constant String := Stack.Get ("region").As_String;
      Found : Boolean := False;
      B : Board (List.Length);
   begin
      B.Description := Doc.Get ("description").As_Unbounded_String;
      for I in B.Regions'Range loop
         declare
            Item : constant TOML_Value := List.Item (I);
         begin
            B.Regions (I) :=
              (Name => Item.Get ("name").As_Unbounded_String,
               Attributes =>
                 Item.Get ("attributes").As_Unbounded_String,
               Origin => Address (Item.Get ("origin").As_Integer),
               Size => To_Size (Item.Get ("size").As_String));
            if B.Regions (I).Name = Stack_Name then
               B.Stack_Region := I;
               Found := True;
            end if;
         end;
      end loop;
      if not Found then
         raise Map_Error with "no region named """ & Stack_Name
           & """ for the stack";
      end if;
      B.Stack_Size := To_Size (Stack.Get ("size").As_String);
      return B;
   end;
end Memory_Map.From_TOML;
