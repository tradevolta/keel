--  SPDX-License-Identifier: Apache-2.0
with Keel.Cortex_M; use Keel.Cortex_M;

package body Keel.Sync.Bare is

   procedure Signal (E : in out Event) is
   begin
      E.Set := True;
   end Signal;

   function Is_Set (E : Event) return Boolean is (Boolean (E.Set));

   --  Look with interrupts masked, and sleep still masked: an
   --  interrupt that arrives between the look and the WFI stays
   --  pending, and a pending interrupt ends the WFI. Unmasking then
   --  lets its handler run before the next look.
   procedure Wait (E : in out Event) is
   begin
      loop
         Disable_Interrupts;
         exit when E.Set;
         WFI;
         Enable_Interrupts;
      end loop;
      E.Set := False;
      Enable_Interrupts;
   end Wait;

   --  The bare backend fits the seam: this fails to compile if not
   package Fits is new Keel.Sync.Event_Signature
     (Event, Signal, Wait, Is_Set);
   pragma Unreferenced (Fits);

   Depth : Natural := 0;
   Was_Masked : Boolean := False;

   procedure Enter_Critical is
      Masked : constant Boolean := Interrupts_Disabled;
   begin
      Disable_Interrupts;
      if Depth = 0 then
         Was_Masked := Masked;
      end if;
      Depth := Depth + 1;
   end Enter_Critical;

   procedure Leave_Critical is
   begin
      Depth := Depth - 1;
      if Depth = 0 and then not Was_Masked then
         Enable_Interrupts;
      end if;
   end Leave_Critical;
end Keel.Sync.Bare;
