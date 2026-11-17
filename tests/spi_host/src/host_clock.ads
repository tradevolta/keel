--  SPDX-License-Identifier: Apache-2.0
--  A clock for the host tests that only moves when someone waits:
--  the driver's pauses add up here instead of passing
with Keel.Time; use Keel.Time;

package Host_Clock is
   function Clock return Time;
   procedure Wait_Until (Deadline : Time);

   --  Microseconds waited since Reset
   function Waited return Time_Span;
   procedure Reset;

   package Fits is new Clock_Signature (Clock, Wait_Until);
end Host_Clock;
