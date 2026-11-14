--  SPDX-License-Identifier: Apache-2.0
--  The interrupt-side code of Chapter 9 on the host: the quadrature
--  decoder against recorded contact sequences, and the fault report
--  for the registers Chapter 4 read after a real fault.
with Ada.Text_IO;      use Ada.Text_IO;
with Ada.Command_Line;
with Keel.Quadrature;  use Keel.Quadrature;
with Keel.Faults;      use Keel.Faults;
with Keel.Faults.Report;

procedure Irq_Host is
   Failures : Natural := 0;

   procedure Check (Name : String; OK : Boolean) is
   begin
      Put_Line ((if OK then "ok:   " else "FAIL: ") & Name);
      if not OK then
         Failures := Failures + 1;
      end if;
   end Check;

   --  Contacts as (A, B) pairs, one string per run: "00 10 11 01"
   --  is A then B closing, then A then B opening
   procedure Feed (D : in out Decoder; Run : String) is
   begin
      for I in Run'Range loop
         if Run (I) /= ' '
           and then (I = Run'First or else Run (I - 1) = ' ')
         then
            Update (D, Phase_Of (A => Run (I) = '1',
                                 B => Run (I + 1) = '1'));
         end if;
      end loop;
   end Feed;

   procedure Print is new Keel.Faults.Report (Put_Line);
begin
   declare
      Knob : Decoder (Low => 0, High => 32);
   begin
      Feed (Knob, "10 11 01 00");
      Check ("one turn forward is +4", Knob.Position = 4);
      Feed (Knob, "01 11 10 00");
      Check ("and one back is 0", Knob.Position = 0);
      Feed (Knob, "01 11 10 00");
      Check ("back from 0 stops at Low", Knob.Position = 0);
      Feed (Knob, "10 10 10 11 11 01 00");
      Check ("repeated phases (bounce) count once", Knob.Position = 4);
      Feed (Knob, "11 00");
      Check ("a jump over a phase is a miss, no step",
             Knob.Position = 4 and then Knob.Misses = 2);
      for Turn in 1 .. 20 loop
         Feed (Knob, "10 11 01 00");
      end loop;
      Check ("forward stops at High", Knob.Position = 32);
   end;

   Put_Line ("Chapter 4's fault, as Last_Fault held it (no frame):");
   Print (CFSR => 16#0000_0001#, HFSR => 16#4000_0000#,
          MMFAR => 16#E000_ED34#, BFAR => 16#E000_ED38#,
          Frame => (others => 0));
   Check ("IACCVIOL and FORCED, nothing else",
          (for all C in Cause =>
             Present (16#0000_0001#, 16#4000_0000#, C)
               = (C in IACCVIOL | FORCED)));
   Check ("INVSTATE is CFSR bit 17",
          Present (16#0002_0000#, 0, INVSTATE));

   if Failures > 0 then
      Put_Line (Natural'Image (Failures) & " failed");
      Ada.Command_Line.Set_Exit_Status (Ada.Command_Line.Failure);
   end if;
end Irq_Host;
