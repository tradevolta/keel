--  SPDX-License-Identifier: Apache-2.0
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
      E := R.Data (Slot_Of (R.Tail));
      R.Tail := R.Tail + 1;
   end Pop;

   function Peek (R : Ring) return Element is
     (R.Data (Slot_Of (R.Tail)));

   procedure Clear (R : in out Ring) is
   begin
      R.Tail := R.Head;
   end Clear;
end Keel.Ring_Buffers;
