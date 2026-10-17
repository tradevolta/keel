--  SPDX-License-Identifier: Apache-2.0
--  Keel's L0 startup for the RP2350, used when the crate
--  configuration says Startup = "keel": the boot block, the vector
--  table, the reset handler and the fault handlers. This code runs
--  before elaboration, so it must need none.
with System.Storage_Elements;
with Interfaces;

package Keel.Startup
  with Preelaborate, No_Elaboration_Code_All
is
   --  What HardFault_Handler saw, for GDB to print.
   type Fault_Info is record
      CFSR : Interfaces.Unsigned_32;
      HFSR : Interfaces.Unsigned_32;
      MMFAR : Interfaces.Unsigned_32;
      BFAR : Interfaces.Unsigned_32;
   end record;

   Last_Fault : Fault_Info with Volatile;

   --  Where an unhandled exception was raised: a NUL-terminated
   --  file name and a line number.
   type Exception_Info is record
      File : System.Address;
      Line : Integer;
   end record;

   Last_Exception : Exception_Info with Volatile;

   --  Reset_Handler fills the stack below its own frame with this
   --  pattern; a word that still holds it was never used.
   Stack_Pattern : constant := 16#DEAD_BEEF#;

   --  The main stack's size, and how many bytes at its bottom have
   --  never been written since reset: the margin left.
   function Stack_Size return System.Storage_Elements.Storage_Count;
   function Stack_Never_Used
     return System.Storage_Elements.Storage_Count;

   procedure Reset_Handler
     with Export, Convention => C,
          External_Name => "keel_reset_handler",
          No_Return;

   procedure HardFault_Handler
     with Export, Convention => C,
          External_Name => "keel_hardfault_handler",
          No_Return;

   procedure Default_Handler
     with Export, Convention => C,
          External_Name => "keel_default_handler",
          No_Return;

   --  Replaces the runtime's handler: the light runtime calls it for
   --  every exception that is raised.
   procedure Last_Chance_Handler (File : System.Address; Line : Integer)
     with Export, Convention => C,
          External_Name => "__gnat_last_chance_handler",
          No_Return;
end Keel.Startup;
