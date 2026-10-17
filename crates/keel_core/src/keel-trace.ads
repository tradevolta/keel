--  SPDX-License-Identifier: Apache-2.0
--  Keel.Trace: a text console over SEGGER RTT. The program writes to
--  a ring buffer in RAM; a debug probe reads it through the debug
--  port while the core runs. No pins, no UART, no clocks to set up.
with Interfaces;

package Keel.Trace
  with Preelaborate, No_Elaboration_Code_All
is
   --  Size of up channel 0; one byte always stays free.
   Buffer_Size : constant := 1024;

   --  Fill in the control block. Call once, before any Put.
   procedure Initialize;

   --  Queue Text on up channel 0. Put never waits: when Text does not
   --  fit in the free space, it is dropped whole and counted. One
   --  writer at a time: Chapter 9 adds what interrupts need.
   procedure Put (Text : String);
   procedure Put_Line (Text : String);

   --  16#2008_1000#, the way Keel writes addresses
   procedure Put_Hex (Value : Interfaces.Unsigned_32);
   procedure Put_Decimal (Value : Interfaces.Unsigned_32);

   --  How many Put calls were dropped since Initialize
   function Dropped return Natural;
end Keel.Trace;
