--  SPDX-License-Identifier: Apache-2.0
--  Keel.Sync.Bare: seam v0 on bare metal. An event is one atomic
--  flag; Wait sleeps with WFI between looks. A critical section
--  masks interrupts with PRIMASK, and sections nest.
package Keel.Sync.Bare
  with Preelaborate, No_Elaboration_Code_All
is
   type Event is limited private;

   --  From a handler or the program
   procedure Signal (E : in out Event) with Inline;
   --  From the program only, outside any critical section
   procedure Wait (E : in out Event);
   function Is_Set (E : Event) return Boolean with Inline;

   --  Interrupts off until the matching Leave_Critical
   procedure Enter_Critical;
   procedure Leave_Critical;
private
   type Flag is new Boolean with Atomic;

   type Event is limited record
      Set : Flag := False;
   end record;
end Keel.Sync.Bare;
