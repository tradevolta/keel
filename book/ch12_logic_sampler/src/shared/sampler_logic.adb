--  SPDX-License-Identifier: Apache-2.0
package body Sampler_Logic is

   procedure Scan
     (S : in out State; Set : Setting; First : Ring_Slot;
      Count : Natural; Found : out Boolean; At_Slot : out Ring_Slot)
   is
      Slot : Ring_Slot := First;
   begin
      Found := False;
      At_Slot := First;
      for I in 1 .. Count loop
         Step (S, Set, Sample_At (Slot), Found);
         if Found then
            At_Slot := Slot;
            return;
         end if;
         Slot := Advance (Slot, 1, Slots);
      end loop;
   end Scan;
end Sampler_Logic;
