--  SPDX-License-Identifier: Apache-2.0
with Ada.Text_IO; use Ada.Text_IO;
with Ada.Unchecked_Conversion;
with Interfaces;  use Interfaces;
with Hex;

procedure Dump_Register (Value : Register; Offset : Natural) is
   function To_Word is
     new Ada.Unchecked_Conversion (Register, Unsigned_32);
begin
   Put_Line (Name & " +" & Hex (Unsigned_32 (Offset), 3) & " = "
             & Hex (To_Word (Value), 8));
end Dump_Register;
