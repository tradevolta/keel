--  SPDX-License-Identifier: Apache-2.0
--  The real ring's specification, with a body that has one bug: Pop
--  takes the newest element, from the producer's end, as a stack
--  would. Everything else is as in crates/keel_core.
package body Keel.Ring_Buffers
  with SPARK_Mode
is
   procedure Push (R : in out Ring; E : Element) is
   begin
      R.Data (Slot_Of (R.Head)) := E;
      R.Head := R.Head + 1;
   end Push;

   procedure Pop (R : in out Ring; E : out Element) is
   begin
      R.Head := R.Head - 1;
      E := R.Data (Slot_Of (R.Head));
   end Pop;

   function Peek (R : Ring) return Element is
     (R.Data (Slot_Of (R.Tail)));

   procedure Clear (R : in out Ring) is
   begin
      R.Tail := R.Head;
   end Clear;
end Keel.Ring_Buffers;
