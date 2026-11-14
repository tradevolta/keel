--  SPDX-License-Identifier: Apache-2.0
--  Keel.Sync, seam v0: what Keel's drivers need from the layer that
--  runs them. An interrupt handler signals an event; the program
--  waits for it. The bare backend (Keel.Sync.Bare in each chip
--  crate) sleeps with WFI; a Jorvik backend waits on a protected
--  entry. Drivers are written against the signature, so either
--  backend fits. Chapter 10 adds waiting with a deadline.
with Keel.Time;

package Keel.Sync
  with Pure, No_Elaboration_Code_All
is
   generic
      type Event is limited private;
      --  Set the event. From a handler or the program; never waits.
      with procedure Signal (E : in out Event);
      --  Wait until the event is set, then clear it. One waiter.
      with procedure Wait (E : in out Event);
      --  Set and not yet waited for
      with function Is_Set (E : Event) return Boolean;
   package Event_Signature is
   end Event_Signature;

   --  Wait for the event, but not past Deadline. Ok: it was set, and
   --  is now clear. Timeout: Deadline came first; the event is as it
   --  was.
   generic
      type Event is limited private;
      with procedure Wait
        (E : in out Event; Deadline : Keel.Time.Time;
         Stat : out Status);
   package Deadline_Signature is
   end Deadline_Signature;
end Keel.Sync;
