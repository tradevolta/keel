--  SPDX-License-Identifier: Apache-2.0
with Interfaces; use Interfaces;
with System; use System;
with System.Storage_Elements; use System.Storage_Elements;
with Keel.Trace; use Keel.Trace;

package body Sections is

   --  Only the addresses of these symbols mean anything.
   type Symbol is null record;

   Text_Start : Symbol with Import, External_Name => "keel_vectors";
   Text_End : Symbol with Import, External_Name => "__keel_text_end";
   Data_Load : Symbol with Import, External_Name => "__keel_data_load";
   Data_Start : Symbol
     with Import, External_Name => "__keel_data_start";
   Data_End : Symbol with Import, External_Name => "__keel_data_end";
   Fast_End : Symbol
     with Import, External_Name => "__keel_time_critical_end";
   BSS_Start : Symbol with Import, External_Name => "__keel_bss_start";
   BSS_End : Symbol with Import, External_Name => "__keel_bss_end";
   Stack_Start : Symbol
     with Import, External_Name => "__keel_stack_start";
   Stack_End : Symbol with Import, External_Name => "__keel_stack_end";

   function Number (A : Address) return Unsigned_32 is
     (Unsigned_32 (To_Integer (A)));

   procedure Line (Name : String; First, After : Address) is
   begin
      Put (Name);
      Put_Hex (Number (First));
      Put (" .. ");
      Put_Hex (Number (After));
      Put (" ");
      Put_Decimal (Number (After) - Number (First));
      Put_Line (" bytes");
   end Line;

   procedure Report is
      Data_Size : constant Storage_Offset :=
        Data_End'Address - Data_Start'Address;
   begin
      Line (".text          ", Text_Start'Address, Text_End'Address);
      Line ("copied from    ", Data_Load'Address,
            Data_Load'Address + Data_Size);
      Line (".time_critical ", Data_Start'Address, Fast_End'Address);
      Line (".data          ", Fast_End'Address, Data_End'Address);
      Line (".bss           ", BSS_Start'Address, BSS_End'Address);
      Line ("stack          ", Stack_Start'Address, Stack_End'Address);
   end Report;
end Sections;
