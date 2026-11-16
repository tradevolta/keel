--  SPDX-License-Identifier: Apache-2.0
--  Keel.RTC on the RP2350: the always-on timer (datasheet 12.10), a
--  64-bit count of milliseconds in POWMAN's always-on domain. It
--  keeps counting through SLEEP, DORMANT and switched-core power
--  down, ticking from the 32.768 kHz low-power oscillator, LPOSC.
--  Its alarm can wake the chip from all three.
with Keel.Clock.RP2350;

package Keel.RTC.RP2350
  with Preelaborate
is
   --  Is the timer counting? It stops only at power-on, brown-out,
   --  a RUN pin reset and some debugger resets (Table 560).
   function Running return Boolean;

   --  Load T and count from it, on LPOSC
   procedure Start (T : Epoch_Ms)
     with Post => Running;

   --  Tick from the 12 MHz crystal, far steadier than LPOSC, while
   --  the chip is awake; from LPOSC again before DORMANT or a power
   --  down, which stop the crystal. The Pico SDK does the same.
   --  Each waits for the switch to happen.
   procedure Use_Crystal
     with Pre => Running and then Keel.Clock.RP2350.Crystal_Running;
   procedure Use_LPOSC
     with Pre => Running;
   function On_Crystal return Boolean;

   --  The time now. Read upper, lower, upper again, as with TIMER0.
   function Now return Epoch_Ms
     with Pre => Running;

   --  Set the time: stop, load, start (SET_TIME may not be written
   --  while the timer runs)
   procedure Set (T : Epoch_Ms);

   --  Arm the alarm for T. Power_Up: let it start a power-up from
   --  a switched-core power down as well. The alarm ends DORMANT
   --  whether or not its interrupt is enabled (6.5.3.1).
   procedure Set_Alarm (T : Epoch_Ms; Power_Up : Boolean := False);
   procedure Clear_Alarm;

   --  The alarm went off since it was last armed or cleared. The
   --  flag lives in the always-on domain, so it survives a
   --  switched-core power down.
   function Alarm_Fired return Boolean;

   --  The timer fits the signature
   package Fits is new Clock_Signature (Now, Set);
end Keel.RTC.RP2350;
