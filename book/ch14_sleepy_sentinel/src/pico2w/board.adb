--  SPDX-License-Identifier: Apache-2.0
--  The Pico 2 W board. The hang button joins GP16 (pin 21) to GND
--  (pin 23), against the pin's pull-up; a press ends a power down
--  too. clk_sys runs from the 12 MHz crystal, with no PLL: the
--  sentinel has little to do and pll_sys would only cost current.
--  clk_adc's 48 MHz from pll_usb runs only while a reading is taken.
--  The console is RTT, so it needs the Debug Probe: unplug the probe
--  to measure current.
with Ch14_Sleepy_Sentinel_Config; use Ch14_Sleepy_Sentinel_Config;
with Keel.ADC;              use Keel.ADC;
with Keel.ADC.RP2350;       use Keel.ADC.RP2350;
with Keel.Clock;
with Keel.Clock.RP2350;     use Keel.Clock.RP2350;
with Keel.GPIO;             use Keel.GPIO;
with Keel.GPIO.RP2350;      use Keel.GPIO.RP2350;
with Keel.Power;            use Keel.Power;
with Keel.Power.RP2350;
with Keel.RTC;              use Keel.RTC;
with Keel.RTC.RP2350;
with Keel.Time.Bare;
with Keel.Trace;
with Keel.Units;            use Keel.Units;
with Keel.Watchdog.RP2350;

package body Board is
   use type Keel.Status;
   package Power renames Keel.Power.RP2350;
   use type Power.Wake_Source;
   package AON renames Keel.RTC.RP2350;
   package Dog renames Keel.Watchdog.RP2350;

   Button     : Input_Pin (16);
   ADC_PLL    : Keel.Clock.PLL_Config;

   --  The calendar keeps UTC, and starts here after a power-on:
   --  21:00 in New York on the day this chapter was written
   First_Time : constant Date_Time :=
     (Year => 2026, Month => 11, Day => 16, Hour => 2,
      others => 0);

   procedure Check (Stat : Keel.Status; What : String) is
   begin
      if Stat /= Keel.Ok then
         Keel.Trace.Put_Line ("sentinel: " & What & ": " & Stat'Image);
         loop
            null;
         end loop;
      end if;
   end Check;

   procedure Initialize is
      Stat  : Keel.Status;
      Found : Boolean;
   begin
      Keel.Trace.Initialize;
      Start_Crystal (Stat);
      Check (Stat, "crystal");
      Keel.Time.Bare.Start (Crystal);

      --  The calendar runs on through everything but a power-on
      if not AON.Running then
         AON.Start (Join (First_Time));
      end if;
      AON.Use_Crystal;
      Power.Initialize;

      Keel.GPIO.RP2350.Enable;
      Claim (Button, (Bias => Pull_Up), Stat);
      Check (Stat, "button on GP16");
      Watch (Button, (Falling => True, Rising => False));
      Power.Set_Wake_Pin (Button.Id);
      Power.Ignore_Debugger;

      Keel.Clock.Solve (PLL_SYS, Crystal, 48_000_000, False, ADC_PLL,
                        Found);
      Check ((if Found then Keel.Ok else Keel.Not_Supported),
             "pll_usb setting");
      Power.Set_Policy
        ((Deepest => Mode'Val (Deepest_Kind'Pos (Deepest)),
          Wake    => Power.Default_Costs));
   end Initialize;

   function Cause return Reset_Cause is
     (if Power.Last_Wake = Power.Wake_Pin then Power_Up
      else Dog.Last_Cause);

   function Deepest_Mode return String is (Deepest'Image);

   ------------------------------------------------------------------
   --  The log, in POWMAN's eight scratch words
   ------------------------------------------------------------------

   procedure Load (L : out Sentinel_Log.Log; Found : out Boolean) is
      W : Sentinel_Log.Words;
   begin
      for I in W'Range loop
         W (I) := Sentinel_Log.Word
           (Power.Retained (Power.Retained_Index (I)));
      end loop;
      Found := Sentinel_Log.Valid (W);
      L := (if Found then Sentinel_Log.Decode (W) else (others => <>));
   end Load;

   procedure Store (L : Sentinel_Log.Log) is
      W : constant Sentinel_Log.Words := Sentinel_Log.Encode (L);
   begin
      for I in W'Range loop
         Power.Retain (Power.Retained_Index (I), Power.Word (W (I)));
      end loop;
   end Store;

   ------------------------------------------------------------------
   --  Watchdog, button, temperature
   ------------------------------------------------------------------

   procedure Start_Watchdog (T : Timeout_Ms) is
      Stat : Keel.Status;
   begin
      Dog.Start (T, Stat);
      Check (Stat, "watchdog");
   end Start_Watchdog;

   procedure Feed is
   begin
      Dog.Feed;
   end Feed;

   function Hang_Requested return Boolean is
     (Get (Button) = Low
      or else Seen (Button).Falling
      or else Power.Last_Wake = Power.Wake_Pin);

   --  clk_adc and the converter run only for a reading: 16 samples
   --  of the sensor, averaged
   procedure Read_Temperature
     (C : out Sentinel_Log.Centi; Stat : out Keel.Status)
   is
      Samples : constant := 16;
      Total   : Natural := 0;
      Value   : Code;
   begin
      C := 0;
      Start_ADC_Clock (ADC_PLL, Stat);
      if Stat /= Keel.Ok then
         return;
      end if;
      Enable (Stat);
      if Stat = Keel.Ok and then not Is_Claimed (Temperature_Sensor)
      then
         Claim (Temperature_Sensor, Stat);
      end if;
      for I in 1 .. Samples loop
         exit when Stat /= Keel.Ok;
         Read (Temperature_Sensor, Value, Stat);
         Total := Total + Value;
      end loop;
      if Stat = Keel.Ok then
         C := Integer
           (Temperature
              (Sensor, To_Volts (Converter,
                                 Mean (Converter, Total, Samples)))
            * 100);
      end if;
      if Keel.ADC.RP2350.Is_Enabled then
         Disable;
      end if;
      Stop_ADC_Clock;
   end Read_Temperature;

   function Stamp return String is (Image (Split (AON.Now)));

   function Now return Time is (Keel.Time.Bare.Clock);

   procedure Wait_Until (Deadline : Time) is
   begin
      Power.Wait_Until (Deadline);
   end Wait_Until;

   procedure Put_Line (Text : String) is
   begin
      Keel.Trace.Put_Line (Text);
   end Put_Line;
end Board;
