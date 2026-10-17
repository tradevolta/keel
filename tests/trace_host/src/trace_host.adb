--  SPDX-License-Identifier: Apache-2.0
--  Write through Keel.Trace, read back through Probe, compare.
with Ada.Command_Line;
with Ada.Text_IO; use Ada.Text_IO;
with Keel.Trace;
with Probe;

procedure Trace_Host is
   Failures : Natural := 0;

   procedure Expect (What : String; Got, Want : String) is
   begin
      if Got = Want then
         Put_Line ("pass: " & What);
      else
         Put_Line ("FAIL: " & What & ": got """ & Got & """");
         Failures := Failures + 1;
      end if;
   end Expect;

   LF : constant String := [1 => ASCII.LF];
begin
   Keel.Trace.Initialize;
   Put_Line ("probe: " & Probe.Describe);

   Keel.Trace.Put ("stack top ");
   Keel.Trace.Put_Hex (16#2008_2000#);
   Keel.Trace.Put (", size ");
   Keel.Trace.Put_Decimal (4096);
   Keel.Trace.Put_Line ("");
   Expect ("text and numbers", Probe.Drain,
           "stack top 16#2008_2000#, size 4096" & LF);

   --  1000 bytes queued leave 23 free: 30 more are dropped whole
   Keel.Trace.Put ([1 .. 1000 => 'a']);
   Keel.Trace.Put ([1 .. 30 => 'b']);
   Expect ("drop when full", Keel.Trace.Dropped'Image, " 1");
   Expect ("nothing torn", Probe.Drain, [1 .. 1000 => 'a']);

   --  The write offset is now 1000: this line wraps around
   Keel.Trace.Put_Line ("wrapped around the end of the ring");
   Expect ("wrap-around", Probe.Drain,
           "wrapped around the end of the ring" & LF);

   if Failures > 0 then
      Ada.Command_Line.Set_Exit_Status (Ada.Command_Line.Failure);
   end if;
end Trace_Host;
