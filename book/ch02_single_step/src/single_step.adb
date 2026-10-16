--  SPDX-License-Identifier: Apache-2.0
--  Single-step the blink: the Chapter 1 loop, with its period held
--  in a variable that you can change from GDB.
with Ada.Real_Time; use Ada.Real_Time;
with Blink_Control; use Blink_Control;
with LED_GP15;

procedure Single_Step is
   Next : Time := Clock;
begin
   LED_GP15.Init;
   loop
      LED_GP15.Toggle;
      Toggles := Toggles + 1;
      Next := Next + Milliseconds (Half_Period_Ms);
      delay until Next;
   end loop;
end Single_Step;
