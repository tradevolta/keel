--  SPDX-License-Identifier: Apache-2.0
with Interfaces; use Interfaces;
with System;

package body Keel.Trace is

   --  SEGGER_RTT_BUFFER_UP and _DOWN from SEGGER_RTT.h. The probe
   --  writes Read_Offset of an up buffer; the target writes the rest.
   type Ring is record
      Name : System.Address;
      Buffer : System.Address;
      Size : Unsigned_32;
      Write_Offset : Unsigned_32;
      Read_Offset : Unsigned_32;
      Flags : Unsigned_32;
   end record
     with Convention => C;

   subtype ID_String is String (1 .. 16);

   --  SEGGER_RTT_CB with one up and one down channel
   type Control_Block is record
      ID : ID_String;
      Max_Up : Integer_32;
      Max_Down : Integer_32;
      Up : Ring;
      Down : Ring;
   end record
     with Convention => C;

   CB : Control_Block
     with Volatile, Export, Convention => C,
          External_Name => "_SEGGER_RTT";

   --  SEGGER_RTT.h on a 32-bit target: 24 bytes per buffer and 72
   --  for the block, so nothing between the components is padding
   pragma Compile_Time_Error
     (System.Address'Size = 32
      and then (Ring'Size /= 24 * 8
                or else Control_Block'Size /= 72 * 8),
      "Control_Block does not match SEGGER_RTT_CB");

   Up_Data : String (1 .. Buffer_Size);
   Down_Data : String (1 .. 16);
   Drops : Natural := 0;

   Channel_Name : constant String := "Terminal" & ASCII.NUL;
   Magic : constant String := "SEGGER RTT";

   --  A full memory barrier (DMB on Arm): the probe must see the data
   --  before it sees the new Write_Offset.
   procedure Barrier
     with Import, Convention => Intrinsic,
          External_Name => "__sync_synchronize";

   procedure Initialize is
   begin
      CB.Max_Up := 1;
      CB.Max_Down := 1;
      CB.Up := (Name => Channel_Name'Address,
                Buffer => Up_Data'Address,
                Size => Buffer_Size,
                Write_Offset => 0,
                Read_Offset => 0,
                Flags => 0);
      CB.Down := (Name => Channel_Name'Address,
                  Buffer => Down_Data'Address,
                  Size => Down_Data'Length,
                  Write_Offset => 0,
                  Read_Offset => 0,
                  Flags => 0);
      Drops := 0;
      --  The ID goes in last, back to front, as SEGGER_RTT.c does:
      --  a probe that finds "SEGGER RTT" finds a finished block.
      CB.ID := [others => ASCII.NUL];
      for I in reverse Magic'Range loop
         Barrier;
         CB.ID (I) := Magic (I);
      end loop;
      Barrier;
   end Initialize;

   procedure Put (Text : String) is
      Write : Unsigned_32 := CB.Up.Write_Offset;
      Read : constant Unsigned_32 := CB.Up.Read_Offset;
      Free : constant Unsigned_32 :=
        (if Read > Write then Read - Write - 1
         else Buffer_Size - (Write - Read) - 1);
   begin
      if Text'Length > Free then
         Drops := Drops + 1;
         return;
      end if;
      for C of Text loop
         Up_Data (Natural (Write) + 1) := C;
         Write := (Write + 1) mod Buffer_Size;
      end loop;
      Barrier;
      CB.Up.Write_Offset := Write;
   end Put;

   procedure Put_Line (Text : String) is
   begin
      Put (Text);
      Put ([1 => ASCII.LF]);
   end Put_Line;

   Hex_Digit : constant String := "0123456789ABCDEF";

   procedure Put_Hex (Value : Unsigned_32) is
      Text : String := "16#0000_0000#";
      V : Unsigned_32 := Value;
   begin
      for I in reverse 4 .. 12 loop
         if I /= 8 then
            Text (I) := Hex_Digit (Natural (V and 16#F#) + 1);
            V := Shift_Right (V, 4);
         end if;
      end loop;
      Put (Text);
   end Put_Hex;

   procedure Put_Decimal (Value : Unsigned_32) is
      Text : String (1 .. 10);
      First : Positive := Text'Last + 1;
      V : Unsigned_32 := Value;
   begin
      loop
         First := First - 1;
         Text (First) := Character'Val (Character'Pos ('0') + V mod 10);
         V := V / 10;
         exit when V = 0;
      end loop;
      Put (Text (First .. Text'Last));
   end Put_Decimal;

   function Dropped return Natural is (Drops);
end Keel.Trace;
