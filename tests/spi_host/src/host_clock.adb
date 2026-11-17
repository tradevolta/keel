--  SPDX-License-Identifier: Apache-2.0
package body Host_Clock is
   Now   : Time := 0;
   Start : Time := 0;

   function Clock return Time is (Now);

   procedure Wait_Until (Deadline : Time) is
   begin
      if Deadline > Now then
         Now := Deadline;
      end if;
   end Wait_Until;

   function Waited return Time_Span is (Now - Start);

   procedure Reset is
   begin
      Start := Now;
   end Reset;
end Host_Clock;
