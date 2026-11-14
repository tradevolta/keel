--  SPDX-License-Identifier: Apache-2.0
--  Keel's HardFault handler: it finds the frame the processor pushed,
--  records the fault status registers in Keel.Startup.Last_Fault and,
--  once Keel.Trace is initialized, prints a report. It never returns.
with System;

package Keel.Fault_Reporter
  with Preelaborate
is
   --  The HardFault vector. Naked: no prologue may touch the stack
   --  before it has read the frame's address.
   procedure HardFault_Entry
     with Export, Convention => C,
          External_Name => "keel_hardfault_entry";
   pragma Machine_Attribute (HardFault_Entry, "naked");

   --  Frame is the address of the stacked R0
   procedure Report (Frame : System.Address)
     with Export, Convention => C,
          External_Name => "keel_fault_report",
          No_Return;
end Keel.Fault_Reporter;
