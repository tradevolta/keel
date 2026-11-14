--  SPDX-License-Identifier: Apache-2.0
--  Keel.Sync.Bare: seam v0 on bare metal. An event is one atomic
--  flag; Wait sleeps with WFI between looks. A critical section
--  masks interrupts with PRIMASK, and sections nest. The wait with
--  a deadline needs Keel.Time.Bare started.
package Keel.Sync.Bare
  with Preelaborate
is
   type Event is limited private;

   --  From a handler or the program
   procedure Signal (E : in out Event) with Inline;
   --  From the program only, outside any critical section
   procedure Wait (E : in out Event);
   function Is_Set (E : Event) return Boolean with Inline;

   --  From the program only: as Wait, but not past Deadline.
   --  Timeout: Deadline came first, and E is as it was.
   procedure Wait
     (E : in out Event; Deadline : Keel.Time.Time; Stat : out Status);

   --  Interrupts off until the matching Leave_Critical
   procedure Enter_Critical;
   procedure Leave_Critical;
private
   type Flag is new Boolean with Atomic;

   type Event is limited record
      Set : Flag := False;
   end record;
end Keel.Sync.Bare;
