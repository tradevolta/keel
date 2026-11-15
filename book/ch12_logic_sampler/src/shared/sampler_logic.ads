--  SPDX-License-Identifier: Apache-2.0
--  The sampler's bookkeeping, on the board and on the host alike. A
--  ring of Slots samples fills in two halves; after each half, the
--  program scans it for the trigger. Once it has fired at slot T,
--  the capture is Pre samples before T and Post from T on, so the
--  DMA must be stopped after it has written Post samples from T and
--  before it comes round to T - Pre again.
with Keel.DMA; use Keel.DMA;
with Trigger;  use Trigger;

generic
   Slots : Ring_Length;
   Pre   : Natural;
   Post  : Positive;
   --  The sample in a slot that the DMA has finished with
   with function Sample_At (Slot : Ring_Slot) return Sample;
package Sampler_Logic is
   pragma Compile_Time_Error
     (Pre + Post >= Slots, "the capture must be shorter than the ring");

   Half : constant Positive := Slots / 2;

   --  Feed Count samples from slot First to the trigger. Found: one
   --  fired, at slot At_Slot; the samples after it are not looked at.
   procedure Scan
     (S : in out State; Set : Setting; First : Ring_Slot;
      Count : Natural; Found : out Boolean; At_Slot : out Ring_Slot)
     with Pre => First < Slots and then Count <= Slots;

   --  The DMA's next slot is Next: has it written Post samples from
   --  the trigger at T?
   function Done (T, Next : Ring_Slot) return Boolean is
     (Distance (T, Next, Slots) >= Post)
     with Pre => T < Slots and then Next < Slots;

   --  It went on to Next before it stopped: are the Pre samples
   --  before T still there?
   function Intact (T, Next : Ring_Slot) return Boolean is
     (Distance (T, Next, Slots) <= Slots - Pre)
     with Pre => T < Slots and then Next < Slots;

   --  The capture's K-th sample, K from 0, is in this slot
   function Slot_Of (T : Ring_Slot; K : Natural) return Ring_Slot is
     (Advance (Back (T, Pre, Slots), K, Slots))
     with Pre => T < Slots and then Pre <= Slots and then K < Slots;
end Sampler_Logic;
