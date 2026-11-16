--  SPDX-License-Identifier: Apache-2.0
--  Keel.Watchdog on the RP2350: the watchdog counter (datasheet
--  12.9), ticking once per microsecond from the tick generator, and
--  the reset reason, from the watchdog's REASON register and
--  POWMAN's CHIP_RESET. A timeout runs the power-on state machine
--  for everything but the oscillators, as the Pico SDK does, so
--  POWMAN and its scratch registers survive it.
with Keel.Clock.RP2350;
with Keel.Watchdog.Chip_Limits;

package Keel.Watchdog.RP2350
  with Preelaborate
is
   Limits : Counter_Limits renames Chip_Limits.RP2350_Watchdog;

   --  Count down from T. Pause_On_Debug: stop counting while the
   --  debugger halts a core, so a breakpoint is not a reset.
   --  Not_Supported: T is over 16.7 s, the 24-bit counter's limit.
   procedure Start
     (T : Timeout_Ms; Stat : out Status;
      Pause_On_Debug : Boolean := True)
     with Pre => Keel.Clock.RP2350.Crystal_Running;

   --  Load the counter again
   procedure Feed;

   --  Reset the chip now, through the watchdog
   procedure Force;

   --  Microseconds left before the watchdog fires
   function Remaining_us return Natural;

   --  Why the chip last started. A watchdog reset shows as
   --  Watchdog_Timeout or Watchdog_Forced only if Keel armed the
   --  watchdog: the bootrom uses it to reboot too.
   function Last_Cause return Reset_Cause;

   --  POWMAN's CHIP_RESET, raw, for the curious (Table 521)
   function Chip_Reset_Flags return Natural;

   --  The chip package fits the signature: this fails to compile if
   --  it does not
   procedure Start_Default (T : Timeout_Ms; Stat : out Status);
   package Fits is new Signature (Start_Default, Feed, Last_Cause);
end Keel.Watchdog.RP2350;
