--  SPDX-License-Identifier: Apache-2.0
--  The volume knob: the handler decodes the encoder, the program
--  sleeps until it signals, then draws the bar and reports. A
--  press of the knob's switch crashes the program on purpose.
with Board; use Board;
with Crash;

procedure Volume_Knob is
   Shown : Integer := -1;
   Now : Volume;
   Misses : Natural;
begin
   Initialize;
   Put_Line ("volume_knob: turn the knob; press it to crash");
   loop
      Wait_For_Change;
      if Pressed then
         Put_Line ("volume_knob: crashing on purpose");
         Crash.Now;
      end if;
      Read (Now, Misses);
      if Now /= Shown then
         Show (Now / 4);
         Put_Line ("volume" & Now'Image & "/32, misses"
                   & Misses'Image);
         Shown := Now;
      end if;
   end loop;
end Volume_Knob;
