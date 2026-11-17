--  SPDX-License-Identifier: Apache-2.0
--  The Pico 2 W board. The Debug Probe's UART port (the "U" cable)
--  goes to GP0 (pin 1, UART0 TX), GP1 (pin 2, UART0 RX) and GND
--  (pin 3): the probe's RX to GP0, its TX to GP1. The LED on GP15
--  (pin 20) and its 220 ohm resistor are Chapter 1's; the button
--  joins GP16 (pin 21) to GND against the pin's pull-up. A second
--  LED, through 220 ohm, on GP14 (pin 19) is the PWM output. ADC
--  inputs 0 to 2 are GP26 to GP28; Chapter 11's LDR divider on GP26
--  gives input 0 something to read. clk_sys is 150 MHz from
--  pll_sys, and clk_peri, the UART's clock, follows it.
with Ch15_Keelsh_Config; use Ch15_Keelsh_Config;
with Keel.ADC;              use Keel.ADC;
with Keel.ADC.RP2350;
with Keel.Bus.UART;         use type Keel.Bus.UART.Mode;
with Keel.Bus.UART.RP2350;  use Keel.Bus.UART.RP2350;
with Keel.Clock;            use type Keel.Clock.Frequency;
with Keel.Clock.RP2350;     use Keel.Clock.RP2350;
with Keel.DMA.RP2350;
with Keel.GPIO;             use Keel.GPIO;
with Keel.GPIO.RP2350;      use Keel.GPIO.RP2350;
with Keel.PWM;              use Keel.PWM;
with Keel.PWM.RP2350;
with Keel.Time;             use Keel.Time;
with Keel.Time.Bare;
with Keel.Units;            use Keel.Units;
with Keel.Watchdog.RP2350;
with RP2350_SVD;            use type RP2350_SVD.Byte;
with RP2350_SVD.QMI;        use RP2350_SVD.QMI;

package body Board is
   package ADC renames Keel.ADC.RP2350;
   package Dog renames Keel.Watchdog.RP2350;
   package PWM renames Keel.PWM.RP2350;

   Port : constant Port_Id := UART0;
   Baud : constant := 115_200;

   LED    : Output_Pin (15);
   Button : Input_Pin (16);
   Dimmer : PWM.Output (14);

   Started : Keel.Time.Time := 0;

   --  The flash's limit, as in Chapter 10
   Flash_Max : constant Keel.Clock.Frequency := 133_000_000;
   Target    : constant Keel.Clock.Frequency := 150_000_000;

   function Flash_Divisor return Keel.Clock.Frequency is
     (if QMI_Periph.M0_TIMING.CLKDIV = 0 then 256
      else Keel.Clock.Frequency (QMI_Periph.M0_TIMING.CLKDIV));

   --  Before the console runs there is nowhere to say what failed:
   --  stop, and let the debugger show where
   procedure Check (Stat : Status) is
   begin
      if Stat /= Ok then
         loop
            null;
         end loop;
      end if;
   end Check;

   --  The build's UART_Mode, as a Keel.Bus.UART.Mode
   How : constant Keel.Bus.UART.Mode :=
     Keel.Bus.UART.Mode'Val (UART_Mode_Kind'Pos (UART_Mode));

   procedure Initialize is
      Stat    : Status;
      PLL     : Keel.Clock.PLL_Config;
      Found   : Boolean;
      Dimming : Setting;
   begin
      Start_Crystal (Stat);
      Check (Stat);
      Keel.Clock.Solve (PLL_SYS, Crystal, Target, False, PLL, Found);
      if Found and then Target / Flash_Divisor <= Flash_Max then
         Run_From_PLL (PLL, Stat);
         Check (Stat);
      end if;
      Keel.Time.Bare.Start (Crystal);
      Started := Keel.Time.Bare.Clock;
      Keel.GPIO.RP2350.Enable;
      Keel.PWM.RP2350.Enable;
      Keel.DMA.RP2350.Enable;

      --  The console first, so that it can report the rest
      Open (Port, TX => 0, RX => 1, Baud => Baud, Stat => Stat,
            How => How);
      Check (Stat);

      Claim (LED, (Initial => Low, others => <>), Stat);
      Check (Stat);
      Claim (Button, (Bias => Pull_Up), Stat);
      Check (Stat);
      Solve (PWM.Slice_Limits, Hertz (Sys_Frequency), "1 kHz",
             Trailing_Edge, Dimming, Stat);
      Check (Stat);
      PWM.Claim (Dimmer, Dimming, Stat);
      Check (Stat);

      --  clk_adc: 48 MHz from pll_usb, as in Chapter 11
      Keel.Clock.Solve (PLL_SYS, Crystal, 48_000_000, False, PLL,
                        Found);
      Check (if Found then Ok else Not_Supported);
      Start_ADC_Clock (PLL, Stat);
      Check (Stat);
      ADC.Enable (Stat);
      Check (Stat);
      for Ch in ADC.Channel range 0 .. 2 loop
         ADC.Claim (Ch, Stat);
         Check (Stat);
      end loop;
      ADC.Claim (ADC.Temperature_Sensor, Stat);
      Check (Stat);
   end Initialize;

   function Name return String is ("Pico 2 W");

   --  The console

   procedure Write (Text : String) is
   begin
      Keel.Bus.UART.RP2350.Write (Port, Text);
   end Write;

   procedure Read (C : out Character; Got : out Boolean) is
   begin
      Keel.Bus.UART.RP2350.Read (Port, C, Got);
   end Read;

   function Space return Natural is (Keel.Bus.UART.RP2350.Space (Port));

   function Console_Name return String is
     ("UART0 on GP0/GP1," & Baud'Image & " 8N1");
   function Console_Mode return Keel.Bus.UART.Mode is (Mode_Of (Port));
   function Console_Counts return Keel.Bus.UART.Counts is
     (Statistics (Port));
   function Console_Baud return Natural is
     (Natural (Keel.Bus.UART.Actual
                 (Keel.Bus.UART.RP2350.Limits,
                  Keel.Bus.UART.Clock_Hz (Peri_Frequency),
                  Divisor_Of (Port))));
   function Console_Divisor return Natural is (Divisor_Of (Port));

   function Uptime_Ms return Natural is
     (Natural (((Keel.Time.Bare.Clock - Started) / 1_000)
               mod (Time_Span (Natural'Last) + 1)));

   procedure Idle is
   begin
      if Mode_Of (Port) /= Keel.Bus.UART.Polled then
         Keel.Time.Bare.Wait_Until
           (Keel.Time.Bare.Clock + Milliseconds (1));
      end if;
   end Idle;

   --  Pins, PWM, ADC

   procedure Pin
     (Pin_Name : String; Act : Pin_Action; Level : out Boolean;
      Stat : out Status) is
   begin
      Level := False;
      Stat := Ok;
      if Pin_Name = "15" then
         case Act is
            when On     => Set (LED, High);
            when Off    => Set (LED, Low);
            when Toggle =>
               Set (LED, (if Driven (LED) = High then Low else High));
            when Read   => null;
         end case;
         Level := Driven (LED) = High;
      elsif Pin_Name = "16" and then Act = Read then
         Level := Get (Button) = High;
      else
         Stat := Not_Supported;
      end if;
   end Pin;

   function Pin_Names return String is
     ("15 (LED), 16 (button, read only)");

   procedure Set_Duty
     (Pin_Name : String; P : Percent; Stat : out Status)
   is
   begin
      if Pin_Name /= "14" then
         Stat := Not_Supported;
         return;
      end if;
      PWM.Set_Level
        (Dimmer, (Top (PWM.Setting_Of (Dimmer)) + 1) * P / 100);
      Stat := Ok;
   end Set_Duty;

   function PWM_Names return String is ("14");

   procedure Read_ADC
     (Input : Natural; Code, Millivolts : out Natural;
      Stat : out Status)
   is
      Value : Keel.ADC.Code := 0;
   begin
      Code := 0;
      Millivolts := 0;
      if Input > 2 then
         Stat := Not_Supported;
         return;
      end if;
      ADC.Read (ADC.Channel (Input), Value, Stat);
      if Stat = Ok then
         Code := Value;
         Millivolts := Natural
           (Long_Float (To_Volts (ADC.Converter, Value)) * 1000.0);
      end if;
   end Read_ADC;

   function ADC_Inputs return String is ("0 to 2 (GP26 to GP28)");

   procedure Read_Temperature (Centi : out Integer; Stat : out Status)
   is
      Value : Keel.ADC.Code := 0;
   begin
      Centi := 0;
      ADC.Read (ADC.Temperature_Sensor, Value, Stat);
      if Stat = Ok then
         Centi := Integer
           (Temperature (ADC.Sensor, To_Volts (ADC.Converter, Value))
            * 100);
      end if;
   end Read_Temperature;

   --  Clocks and resets

   function Sys_Hz return Natural is (Natural (Sys_Frequency));
   function Peri_Hz return Natural is (Natural (Peri_Frequency));
   function Measured_kHz return Natural is (Measure_Sys_kHz);

   function Cause return Keel.Watchdog.Reset_Cause is (Dog.Last_Cause);
   function Reset_Flags return Natural is (Dog.Chip_Reset_Flags);

   procedure Reboot is
   begin
      Flush (Port);
      Dog.Force;
      loop
         null;
      end loop;
   end Reboot;
end Board;
