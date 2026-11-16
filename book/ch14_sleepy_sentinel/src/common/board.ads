--  SPDX-License-Identifier: Apache-2.0
--  What the sleepy sentinel needs from a board: a watchdog and why
--  the chip last started, retained words for the log, a hang button,
--  a temperature, a calendar, time that waits in a low-power mode,
--  and a console. The body has its pins in its comments.
with Keel;
with Keel.Time;     use Keel.Time;
with Keel.Watchdog; use Keel.Watchdog;
with Sentinel_Log;

package Board is
   --  Start the clocks, the time base, the console, the calendar,
   --  the button and the power policy. Stops the program, after a
   --  message, if any of them fails.
   procedure Initialize;

   --  Why the chip started, and the deepest mode the build waits in
   function Cause return Reset_Cause;
   function Deepest_Mode return String;

   --  The log in retained words; Found is False if they hold none
   procedure Load (L : out Sentinel_Log.Log; Found : out Boolean);
   procedure Store (L : Sentinel_Log.Log);

   procedure Start_Watchdog (T : Timeout_Ms);
   procedure Feed;

   --  The hang button is held, or its press ended a power down
   function Hang_Requested return Boolean;

   --  The chip's own temperature, in hundredths of a degree
   procedure Read_Temperature
     (C : out Sentinel_Log.Centi; Stat : out Keel.Status);

   --  The calendar's date and time, UTC: "2026-11-16 02:04:05"
   function Stamp return String;

   function Now return Time;
   --  Wait in the deepest mode the policy allows; after a power
   --  down, the program starts again instead of returning
   procedure Wait_Until (Deadline : Time);

   procedure Put_Line (Text : String);
end Board;
