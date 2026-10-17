--  SPDX-License-Identifier: Apache-2.0
with Interfaces; use Interfaces;
with System;

package body Probe is

   --  Written from SEGGER_RTT.h, not from Keel.Trace's body
   type Ring is record
      Name, Buffer : System.Address;
      Size, Write_Offset, Read_Offset, Flags : Unsigned_32;
   end record
     with Convention => C;

   type Control_Block is record
      ID : String (1 .. 16);
      Max_Up, Max_Down : Integer_32;
      Up, Down : Ring;
   end record
     with Convention => C;

   CB : Control_Block
     with Volatile, Import, Convention => C,
          External_Name => "_SEGGER_RTT";

   function C_String (At_Address : System.Address) return String is
      Text : String (1 .. 32) with Import, Address => At_Address;
   begin
      for I in Text'Range loop
         if Text (I) = ASCII.NUL then
            return Text (1 .. I - 1);
         end if;
      end loop;
      return Text;
   end C_String;

   function Describe return String is
     ("ID """ & C_String (CB.ID'Address) & ""","
      & CB.Max_Up'Image & " up," & CB.Max_Down'Image & " down,"
      & " channel 0 """ & C_String (CB.Up.Name) & ""","
      & CB.Up.Size'Image & " bytes");

   function Drain return String is
      Data : String (1 .. Natural (CB.Up.Size))
        with Import, Address => CB.Up.Buffer;
      Read : constant Natural := Natural (CB.Up.Read_Offset);
      Write : constant Natural := Natural (CB.Up.Write_Offset);
   begin
      CB.Up.Read_Offset := CB.Up.Write_Offset;
      if Write >= Read then
         return Data (Read + 1 .. Write);
      else
         return Data (Read + 1 .. Data'Last) & Data (1 .. Write);
      end if;
   end Drain;
end Probe;
