--  SPDX-License-Identifier: Apache-2.0
with Keel.Cortex_M;   use Keel.Cortex_M;
with Keel.Time;       use Keel.Time;
with Keel.Time.Bare;

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

   --  The same, with Keel.Time.Bare set to end the WFI by Deadline
   procedure Wait
     (E : in out Event; Deadline : Keel.Time.Time; Stat : out Status)
   is
   begin
      loop
         Disable_Interrupts;
         if E.Set then
            E.Set := False;
            Stat := Ok;
            exit;
         elsif Keel.Time.Bare.Clock >= Deadline then
            Stat := Timeout;
            exit;
         end if;
         Keel.Time.Bare.Wake_At (Deadline);
         WFI;
         Enable_Interrupts;
      end loop;
      Enable_Interrupts;
   end Wait;

   --  The bare backend fits the seam: these fail to compile if not
   package Fits is new Keel.Sync.Event_Signature
     (Event, Signal, Wait, Is_Set);
   pragma Unreferenced (Fits);
   package Fits_Deadline is new Keel.Sync.Deadline_Signature
     (Event, Wait);
   pragma Unreferenced (Fits_Deadline);

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
