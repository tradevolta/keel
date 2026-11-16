--  SPDX-License-Identifier: Apache-2.0
--  Chapter 14 on the host: watchdog settings for both chips against
--  values worked by hand, the calendar against Ada.Calendar on every
--  day of its 400 years, the power policy's choices and a wait on a
--  fake clock, the INA219's words against the datasheet's examples,
--  and the sentinel's log through a full ring and its eight words.
with Ada.Text_IO;      use Ada.Text_IO;
with Ada.Calendar;
with Ada.Calendar.Arithmetic;
with Ada.Command_Line;
with Keel;             use type Keel.Status;
with Keel.Time;        use Keel.Time;
with Keel.Watchdog;    use Keel.Watchdog;
with Keel.Watchdog.Chip_Limits; use Keel.Watchdog.Chip_Limits;
with Keel.RTC;         use Keel.RTC;
with Keel.Power;       use Keel.Power;
with Keel.Drivers.INA219;
with Model_I2C;
with Sentinel_Log;     use Sentinel_Log;

procedure Power_Host is
   Failures : Natural := 0;

   procedure Check (Name : String; OK : Boolean) is
   begin
      Put_Line ((if OK then "ok:   " else "FAIL: ") & Name);
      if not OK then
         Failures := Failures + 1;
      end if;
   end Check;

   ------------------------------------------------------------------
   --  Watchdog settings
   ------------------------------------------------------------------

   procedure Solves
     (Name : String; L : Counter_Limits; T : Timeout_Ms;
      Shift : Natural; Reload : Natural)
   is
      S     : Setting;
      Found : Boolean;
   begin
      Solve (L, T, S, Found);
      Check (Name & T'Image & " ms: shift" & Shift'Image
             & ", reload" & Reload'Image,
             Found and then S.Shift = Shift and then S.Reload = Reload);
   end Solves;

   procedure Refuses (Name : String; L : Counter_Limits; T : Timeout_Ms)
   is
      S     : Setting;
      Found : Boolean;
   begin
      Solve (L, T, S, Found);
      Check (Name & T'Image & " ms: too long", not Found);
   end Refuses;

   ------------------------------------------------------------------
   --  The calendar
   ------------------------------------------------------------------

   procedure Calendar_Days is
      use Ada.Calendar;
      Epoch : constant Ada.Calendar.Time := Time_Of (1970, 1, 1, 0.0);
      Day   : Ada.Calendar.Time := Epoch;
      Bad   : Natural := 0;
      D     : Date_Time;
      N     : Long_Long_Integer;
   begin
      for I in 0 .. Long_Long_Integer (Cycle_Days) - 1 loop
         --  Ada.Calendar stops at 2399; the cycle at 2369
         D := (Year  => Ada.Calendar.Year (Day),
               Month => Ada.Calendar.Month (Day),
               Day   => Ada.Calendar.Day (Day),
               others => <>);
         N := Long_Long_Integer (Join (D)) / Ms_Per_Day;
         if N /= I or else Split (Join (D)) /= D then
            if Bad < 5 then
               Put_Line ("  day" & I'Image & ": " & Image (D)
                         & " joins to day" & N'Image);
            end if;
            Bad := Bad + 1;
         end if;
         Day := Ada.Calendar.Arithmetic."+" (Day, 1);
      end loop;
      Check ("calendar: all" & Cycle_Days'Image
             & " days, 1970 to 2369, match Ada.Calendar",
             Bad = 0);
   end Calendar_Days;

   ------------------------------------------------------------------
   --  The power policy on a fake clock: Enter records the mode and
   --  moves the clock to the deadline, as a wait with no interrupt
   --  would
   ------------------------------------------------------------------

   Fake_Now : Keel.Time.Time := 0;
   type Mode_Counts is array (Keel.Power.Mode) of Natural;
   Entered  : Mode_Counts := [others => 0];
   The_Rule : Policy;

   function Fake_Clock return Keel.Time.Time is (Fake_Now);
   procedure Fake_Enter
     (M : Keel.Power.Mode; Deadline : Keel.Time.Time) is
   begin
      Entered (M) := Entered (M) + 1;
      if M = Run then
         Fake_Now := Fake_Now + Microseconds (100);
      else
         Fake_Now := Deadline;
      end if;
   end Fake_Enter;
   function Fake_Current return Policy is (The_Rule);

   package Fake_Idle is new Idle (Fake_Clock, Fake_Enter, Fake_Current);

   Costs_Here : constant Costs :=
     [Run => 0, Sleep => 0, Dormant => 20_000, Power_Down => 500_000];

   ------------------------------------------------------------------
   --  The INA219 on the model bus
   ------------------------------------------------------------------

   package Meter is new Keel.Drivers.INA219
     (Model_I2C.Bus, Model_I2C.Read_Register,
      Model_I2C.Write_Register);

   Bus  : Model_I2C.Bus;
   Stat : Keel.Status;
   uV   : Integer;
   mV   : Natural;
   New_Value : Boolean;

   L, M : Log;
   W    : Words;
begin
   --  RP2350: 1 MHz ticks, no prescaler, a 24-bit count
   Solves ("rp2350", RP2350_Watchdog, 1, 0, 1_000);
   Solves ("rp2350", RP2350_Watchdog, 12_000, 0, 12_000_000);
   Solves ("rp2350", RP2350_Watchdog, 16_777, 0, 16_777_000);
   Refuses ("rp2350", RP2350_Watchdog, 16_778);
   --  STM32G4 IWDG: 32 kHz LSI, prescaler 4 to 256, counts
   --  Reload + 1. 12 s is 384 000 ticks: 3 000 at /128.
   Solves ("stm32g4", STM32G4_IWDG, 1, 2, 7);
   Solves ("stm32g4", STM32G4_IWDG, 500, 2, 3_999);
   Solves ("stm32g4", STM32G4_IWDG, 513, 3, 2_051);
   Solves ("stm32g4", STM32G4_IWDG, 12_000, 7, 2_999);
   Solves ("stm32g4", STM32G4_IWDG, 32_768, 8, 4_095);
   Refuses ("stm32g4", STM32G4_IWDG, 32_769);

   --  The calendar
   Calendar_Days;
   Check ("calendar: 2000-03-01 is day 11 017",
          Join ((Year => 2000, Month => 3, Day => 1, others => <>))
            = 11_017 * Ms_Per_Day);
   Check ("calendar: the last millisecond",
          Split (Epoch_Ms'Last)
            = (2369, 12, 31, 23, 59, 59, 999));
   Check ("calendar: image",
          Image ((2026, 11, 15, 21, 4, 5, 678))
            = "2026-11-15 21:04:05");
   Check ("calendar: 2100 is not a leap year, 2000 is",
          not Is_Leap (2100) and then Is_Leap (2000)
          and then Days_In_Month (2100, 2) = 28);

   --  Choose
   Check ("policy: 10 s, deepest Power_Down: Power_Down",
          Choose ((Power_Down, Costs_Here), Milliseconds (10_000))
            = Power_Down);
   Check ("policy: 100 ms: Dormant",
          Choose ((Power_Down, Costs_Here), Milliseconds (100))
            = Dormant);
   Check ("policy: 10 ms: Sleep",
          Choose ((Power_Down, Costs_Here), Milliseconds (10))
            = Sleep);
   Check ("policy: 10 s, deepest Sleep: Sleep",
          Choose ((Sleep, Costs_Here), Milliseconds (10_000)) = Sleep);
   Check ("policy: deepest Run: Run",
          Choose ((Run, Costs_Here), Milliseconds (10_000)) = Run);
   Check ("policy: a negative budget: Run",
          Choose ((Power_Down, Costs_Here), -1) = Run);

   --  Idle: a 1 s wait under Dormant enters Dormant once
   The_Rule := (Dormant, Costs_Here);
   Fake_Idle.Wait_Until (Fake_Now + Milliseconds (1_000));
   Check ("idle: 1 s under Dormant: one Dormant, at the deadline",
          Entered = Mode_Counts'[Dormant => 1, others => 0]
          and then Fake_Now = 1_000_000);
   --  A 10 ms wait with Dormant allowed sleeps instead
   Entered := [others => 0];
   Fake_Idle.Wait_Until (Fake_Now + Milliseconds (10));
   Check ("idle: 10 ms under Dormant: Sleep",
          Entered = Mode_Counts'[Sleep => 1, others => 0]);
   --  Deepest Run spins
   Entered := [others => 0];
   The_Rule := (Run, Costs_Here);
   Fake_Idle.Wait_Until (Fake_Now + Microseconds (1_000));
   Check ("idle: 1 ms under Run: ten turns of 100 us",
          Entered = Mode_Counts'[Run => 10, others => 0]);
   --  A deadline already past returns at once
   Entered := [others => 0];
   Fake_Idle.Wait_Until (0);
   Check ("idle: a past deadline enters nothing",
          Entered = Mode_Counts'[others => 0]);

   --  INA219: SBOS448G 8.6.3.1's examples and the reset value
   Check ("ina219: reset configuration 399Fh",
          Meter.Encode ((others => <>)) = 16#399F#);
   --  The meter's: 32 V bus range, 40 mV shunt range, 128 shunt
   --  samples, shunt only
   Check ("ina219: the meter's configuration is 21FDh",
          Meter.Encode
            ((Gain   => Meter.Div_1_40mV,
              Sh_ADC => Meter.Average_128,
              Mode   => Meter.Continuous_Shunt,
              others => <>))
            = 16#21FD#);
   Check ("ina219: 7D00h is +320 mV, 8300h is -320 mV",
          Meter.Shunt_uV (16#7D00#) = 320_000
          and then Meter.Shunt_uV (16#8300#) = -320_000);
   Check ("ina219: 0FA0h is +40 mV, F060h is -40 mV",
          Meter.Shunt_uV (16#0FA0#) = 40_000
          and then Meter.Shunt_uV (16#F060#) = -40_000);
   Check ("ina219: one count through 0.1 ohm is 100 uA",
          Meter.Current_uA (Meter.Shunt_uV (1), 100) = 100);
   Check ("ina219: bus 1F40h << 3 is 32 000 mV",
          Meter.Bus_mV (16#1F40# * 8) = 32_000
          and then Meter.Ready (16#1F40# * 8 + 2)
          and then not Meter.Overflow (16#1F40# * 8 + 2));
   Meter.Configure (Bus, (others => <>), Stat);
   Check ("ina219: configure writes register 0",
          Stat = Keel.Ok and then Bus.Regs (0) = 16#399F#);
   Bus.Regs (1) := 16#FFF6#;    --  -10 counts
   Meter.Read_Shunt (Bus, uV, Stat);
   Check ("ina219: FFF6h reads -100 uV",
          Stat = Keel.Ok and then uV = -100);
   Bus.Regs (2) := 3_000 * 8 + 2;
   Meter.Read_Bus (Bus, mV, New_Value, Stat);
   Check ("ina219: a fresh 12 000 mV",
          Stat = Keel.Ok and then mV = 12_000 and then New_Value);
   Meter.Read_Shunt (Bus, uV, Stat, Address => 16#41#);
   Check ("ina219: nobody at 0x41: Timeout", Stat = Keel.Timeout);

   --  The log: 15 readings into 12 slots keep the last 12
   for I in 1 .. 15 loop
      Push (L, Centi (I * 100 - 750));
   end loop;
   Check ("log: 15 pushes hold 12, taken 15",
          L.Held = Capacity and then L.Taken = 15);
   Check ("log: oldest is the 4th, newest the 15th",
          Nth (L, 1) = 4 * 100 - 750
          and then Nth (L, 12) = 15 * 100 - 750
          and then Latest (L) = 750);
   L.Recoveries := 3;
   L.Last_Cause := Reset_Cause'Pos (Watchdog_Timeout);
   W := Encode (L);
   M := Decode (W);
   Check ("log: eight words and back", Valid (W) and then M = L);
   Check ("log: word 0 is 5E17h, next 4, 12 held",
          W (0) = 16#5E17_0000# + 3 * 256 + 12);
   W (0) := W (0) xor 16#0001_0000#;
   Check ("log: a damaged mark is not a log", not Valid (W));
   W := [others => 0];
   Check ("log: power-on zeros are not a log", not Valid (W));
   Check ("log: a fresh log packs and unpacks",
          Decode (Encode ((others => <>))) = (others => <>));

   New_Line;
   if Failures = 0 then
      Put_Line ("power_host: all passed");
   else
      Put_Line ("power_host:" & Failures'Image & " FAILED");
      Ada.Command_Line.Set_Exit_Status (Ada.Command_Line.Failure);
   end if;
end Power_Host;
