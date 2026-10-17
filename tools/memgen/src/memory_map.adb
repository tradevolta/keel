--  SPDX-License-Identifier: Apache-2.0
with Ada.Strings.Fixed; use Ada.Strings.Fixed;

package body Memory_Map is

   K : constant := 1024;
   M : constant := 1024 * K;

   procedure Check (B : Board) is
      function Has (Name : String) return Boolean is
        (for some R of B.Regions => R.Name = Name);
      Stack : Region renames B.Regions (B.Stack_Region);
   begin
      if not (Has ("flash") and then Has ("sram")) then
         raise Map_Error with "needs regions named flash and sram";
      end if;

      for I in B.Regions'Range loop
         if B.Regions (I).Origin mod 4 /= 0
           or else B.Regions (I).Size mod 4 /= 0
         then
            raise Map_Error with To_String (B.Regions (I).Name)
              & " is not word-aligned";
         end if;
         for J in I + 1 .. B.Regions'Last loop
            if Overlap (B.Regions (I), B.Regions (J)) then
               raise Map_Error with To_String (B.Regions (I).Name)
                 & " overlaps " & To_String (B.Regions (J).Name);
            end if;
         end loop;
      end loop;

      if B.Stack_Size mod 8 /= 0 then
         raise Map_Error with "the stack size is not a multiple of 8";
      elsif B.Stack_Size > Stack.Size then
         raise Map_Error with "a stack of " & Image (B.Stack_Size)
           & " does not fit in " & To_String (Stack.Name)
           & " (" & Image (Stack.Size) & ")";
      end if;
   end Check;

   function To_Size (Text : String) return Byte_Count is
      Unit : constant Character := Text (Text'Last);
      Number : constant String := Text (Text'First .. Text'Last - 1);
   begin
      case Unit is
         when 'K' => return Byte_Count'Value (Number) * K;
         when 'M' => return Byte_Count'Value (Number) * M;
         when others => return Byte_Count'Value (Text);
      end case;
   end To_Size;

   function Image (Size : Byte_Count) return String is
      function Img (N : Byte_Count) return String is
        (Trim (N'Image, Ada.Strings.Left));
   begin
      if Size /= 0 and then Size mod M = 0 then
         return Img (Size / M) & "M";
      elsif Size /= 0 and then Size mod K = 0 then
         return Img (Size / K) & "K";
      else
         return Img (Size);
      end if;
   end Image;

   function Hex (A : Address) return String is
      Digit : constant String := "0123456789abcdef";
      Text : String (1 .. 10) := "0x00000000";
      V : Address := A;
   begin
      for I in reverse 3 .. 10 loop
         Text (I) := Digit (Integer (V mod 16) + 1);
         V := V / 16;
      end loop;
      return Text;
   end Hex;
end Memory_Map;
