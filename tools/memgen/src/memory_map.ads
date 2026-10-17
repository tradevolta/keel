--  SPDX-License-Identifier: Apache-2.0
--  A board's memory map: named regions of the 32-bit address space,
--  where the stack goes, and the checks that make it safe to link.
with Ada.Strings.Unbounded; use Ada.Strings.Unbounded;

package Memory_Map is

   type Address is range 0 .. 2**32 - 1;
   --  A region may end at the top of memory, so a size can be 2**32.
   type Byte_Count is range 0 .. 2**32;

   type Region is record
      Name : Unbounded_String;
      Attributes : Unbounded_String;
      Origin : Address;
      Size : Byte_Count;
   end record;

   function Last (R : Region) return Byte_Count is
     (Byte_Count (R.Origin) + R.Size - 1);

   function Overlap (A, B : Region) return Boolean is
     (Byte_Count (A.Origin) <= Last (B)
      and then Byte_Count (B.Origin) <= Last (A));

   type Region_Array is array (Positive range <>) of Region;

   type Board (Count : Positive) is record
      Description : Unbounded_String;
      Regions : Region_Array (1 .. Count);
      Stack_Region : Positive;
      Stack_Size : Byte_Count;
   end record;

   Map_Error : exception;

   --  Raise Map_Error, with a message, unless the map is usable: a
   --  "flash" and an "sram" region, no overlaps, word-aligned
   --  regions, and a stack that is 8-byte aligned and fits.
   procedure Check (B : Board);

   --  "4M", "520K" or "4096" to bytes; Constraint_Error otherwise.
   function To_Size (Text : String) return Byte_Count;

   --  A size the way GNU ld writes it: "4M", "512K" or "4096".
   function Image (Size : Byte_Count) return String;

   --  0x20081000
   function Hex (A : Address) return String;
end Memory_Map;
