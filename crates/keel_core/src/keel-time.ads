--  SPDX-License-Identifier: Apache-2.0
--  Keel.Time, the second piece of the kernel seam: a monotonic clock
--  that counts microseconds, and waiting until a deadline. The bare
--  backend, Keel.Time.Bare in each chip crate, counts with TIMER0 on
--  the RP2350 and with SysTick on the STM32G4; a Jorvik backend
--  would use Ada.Real_Time. Drivers are written against
--  Clock_Signature, so either backend fits.
package Keel.Time
  with Pure, SPARK_Mode, No_Elaboration_Code_All
is
   --  Microseconds since the time base started. Clock stops at
   --  Max_Clock, about 146 000 years at 1 MHz, so a time from Clock
   --  plus a span always fits in the type.
   type Time is range 0 .. 2**63 - 1;
   Max_Clock : constant Time := 2**62 - 1;

   --  The difference of two times, in microseconds
   type Time_Span is range -(2**62 - 1) .. 2**62 - 1;

   function "+" (T : Time; S : Time_Span) return Time is
     (Time (Long_Long_Integer (T) + Long_Long_Integer (S)))
     with Pre => (if S > 0 then T <= Max_Clock
                  else Long_Long_Integer (T) >= -Long_Long_Integer (S));

   function "-" (A, B : Time) return Time_Span is
     (Time_Span (Long_Long_Integer (A) - Long_Long_Integer (B)))
     with Pre => A <= Max_Clock and then B <= Max_Clock;

   --  Two times don't add up to a time, and their difference is a
   --  span: these take Time's predefined "+" and "-" out of play
   function "+" (A, B : Time) return Time is abstract;
   function "-" (A, B : Time) return Time is abstract;

   function Microseconds (N : Natural) return Time_Span is
     (Time_Span (N));
   function Milliseconds (N : Natural) return Time_Span is
     (Time_Span (N) * 1_000);

   --  What a backend provides. Clock never passes Max_Clock.
   --  Wait_Until returns at or after Deadline; at once if it has
   --  passed.
   generic
      with function Clock return Time;
      with procedure Wait_Until (Deadline : Time);
   package Clock_Signature is
   end Clock_Signature;
end Keel.Time;
