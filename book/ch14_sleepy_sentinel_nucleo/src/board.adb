--  SPDX-License-Identifier: Apache-2.0
--  The NUCLEO-G474RE board. The IWDG is the watchdog and RCC_CSR
--  the reset reason; the log lives in TAMP_BKP0R to BKP7R, which a
--  reset leaves alone. The G474 has a temperature sensor, but Keel
--  has no STM32G4 ADC driver yet, so the reading is Chapter 13's
--  DS18B20 on PA8 (Arduino D7), with its 4.7 kohm pull-up. The hang
--  button goes from PB0 (Arduino A3) to GND, against a pull-up, as
--  in Chapter 7. There is no calendar here: Stamp counts from the
--  same first moment as the Pico's, but starts again at each reset.
--  clk_sys is HSI16, 16 MHz, with no PLL. The console is RTT.
with Interfaces;          use Interfaces;
with Keel.Clock;         use type Keel.Clock.Frequency;
with Keel.Clock.STM32G4;  use Keel.Clock.STM32G4;
with Keel.Cortex_M;
with Keel.Drivers.DS18B20;
with Keel.GPIO;           use Keel.GPIO;
with Keel.GPIO.STM32G4;   use Keel.GPIO.STM32G4;
with Keel.OneWire;        use Keel.OneWire;
with Keel.OneWire.Bit_Bang;
with Keel.OneWire.Protocol;
with Keel.Power;          use Keel.Power;
with Keel.Power.STM32G4;
with Keel.RTC;            use Keel.RTC;
with Keel.Time.Bare;
with Keel.Trace;
with Keel.Watchdog.STM32G4;

package body Board is
   use type Keel.Status;
   package Power renames Keel.Power.STM32G4;
   package Dog renames Keel.Watchdog.STM32G4;

   Button : Input_Pin (Port => B, Pin => 0);
   Line   : Output_Pin (Port => A, Pin => 8);

   First_Time : constant Date_Time :=
     (Year => 2026, Month => 11, Day => 15, Hour => 21,
      others => 0);

   --  Chapter 13's bit-banged bus, timed on the cycle counter
   procedure Wait_Us (N : Positive) is
      Start : constant Unsigned_32 := Keel.Cortex_M.DWT_CYCCNT;
      Ticks : constant Unsigned_32 :=
        Unsigned_32 (N) * Unsigned_32 (Sys_Frequency / 1_000_000);
   begin
      loop
         exit when Keel.Cortex_M.DWT_CYCCNT - Start >= Ticks;
      end loop;
   end Wait_Us;

   package Wire_Bus is new Keel.OneWire.Bit_Bang
     (Line => Output_Pin, Set => Set, Sense => Sense,
      Wait_Us => Wait_Us,
      Hold => Keel.Cortex_M.Disable_Interrupts,
      Let_Go => Keel.Cortex_M.Enable_Interrupts);
   package Wire is new Bus_Signature
     (Output_Pin, Wire_Bus.Reset, Wire_Bus.Touch);
   package Protocol is new Keel.OneWire.Protocol (Wire);
   package Sensor is new Keel.Drivers.DS18B20 (Wire);

   Probe     : ROM_Code := [others => 0];
   Has_Probe : Boolean := False;

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
      State : Protocol.Search_State := Protocol.Fresh_Search;
      ROM   : ROM_Code;
      Found : Boolean;
      Bus   : Keel.OneWire.Status;
   begin
      Keel.Trace.Initialize;
      Keel.Time.Bare.Start (Sys_Frequency);
      Keel.Cortex_M.DEMCR := (TRCENA => True);
      Keel.Cortex_M.DWT_Ctrl := (CYCCNTENA => True);
      Power.Initialize;

      Claim (Button, (Bias => Pull_Up), Stat);
      Check (Stat, "button on PB0");
      Claim_Open_Drain (Line, (Initial => High, Slew => Slow), Stat);
      Check (Stat, "1-Wire on PA8");
      loop
         Protocol.Next (Line, State, ROM, Found, Bus);
         exit when not Found;
         if Family (ROM) = Sensor.Family_Code then
            Probe := ROM;
            Has_Probe := True;
            exit;
         end if;
      end loop;
   end Initialize;

   function Cause return Reset_Cause is (Dog.Last_Cause);

   function Deepest_Mode return String is
     (Power.Current.Deepest'Image);

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

   procedure Start_Watchdog (T : Timeout_Ms) is
      Stat : Keel.Status;
   begin
      Dog.Start (T, Stat);
      Check (Stat, "IWDG");
   end Start_Watchdog;

   procedure Feed is
   begin
      Dog.Feed;
   end Feed;

   function Hang_Requested return Boolean is (Get (Button) = Low);

   procedure Read_Temperature
     (C : out Sentinel_Log.Centi; Stat : out Keel.Status)
   is
      Bus : Keel.OneWire.Status;
      Raw : Sensor.Raw_Temperature;
   begin
      C := 0;
      Stat := Keel.Timeout;
      if not Has_Probe then
         return;
      end if;
      Sensor.Start_Conversion (Line, Bus);
      if Bus /= Ok then
         return;
      end if;
      Keel.Time.Bare.Wait_Until
        (Keel.Time.Bare.Clock + Sensor.Conversion_Time);
      Sensor.Read (Line, Probe, Raw, Bus);
      if Bus = Ok and then Raw in Sensor.Rated then
         C := Sensor.Hundredths (Raw);
         Stat := Keel.Ok;
      end if;
   end Read_Temperature;

   --  Milliseconds since the start, after First_Time
   function Stamp return String is
     (Image (Split (Join (First_Time)
                    + Epoch_Ms (Keel.Time.Bare.Clock / 1_000))));

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
