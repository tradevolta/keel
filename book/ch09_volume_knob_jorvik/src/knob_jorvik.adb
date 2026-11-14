--  SPDX-License-Identifier: Apache-2.0
--  The same knob on the light-tasking runtime: the environment task
--  blocks on the protected entry; the handler opens it. The console
--  is RTT, as in the bare build.
with Keel.Trace;
with Knob; use Knob;

procedure Knob_Jorvik is
   Now : Volume;
begin
   Keel.Trace.Initialize;
   Start;
   loop
      Encoder.Changed (Now);
      Keel.Trace.Put_Line ("volume" & Now'Image & "/32");
   end loop;
end Knob_Jorvik;
