--  SPDX-License-Identifier: Apache-2.0
--  The NUCLEO-G474RE board. The console is LPUART1 on PA2 and PA3,
--  which the board wires to the ST-LINK's virtual COM port, so the
--  USB cable that flashes the board carries the shell too (UM2505,
--  7.6.5). LD2 on PA5 is the output, B1 on PC13 the input, read as
--  it is. The PWM output is Chapter 10's red leg on D5 (PB4), TIM3's
--  channel 1. Keel has no STM32G4 ADC driver yet, so adc says so.
--  clk_sys is HSI16, 16 MHz, and PCLK1, the LPUART's clock, follows
--  it. The ST-LINK's port takes any rate the host asks for.
with Keel.Bus.UART;          use type Keel.Bus.UART.Mode;
with Keel.Bus.UART.STM32G4;  use Keel.Bus.UART.STM32G4;
with Keel.Clock;             use type Keel.Clock.Frequency;
with Keel.Clock.STM32G4;     use Keel.Clock.STM32G4;
with Keel.GPIO;              use Keel.GPIO;
with Keel.GPIO.STM32G4;      use Keel.GPIO.STM32G4;
with Keel.PWM;               use Keel.PWM;
with Keel.PWM.STM32G4;
with Keel.Time;              use Keel.Time;
with Keel.Time.Bare;
with Keel.Units;             use Keel.Units;
with Keel.Watchdog.STM32G4;

package body Board is
   package Dog renames Keel.Watchdog.STM32G4;
   package PWM renames Keel.PWM.STM32G4;

   Port : constant Keel.Bus.UART.STM32G4.Port_Id := LPUART1;
   Baud : constant := 115_200;

   LED    : Output_Pin (Port => A, Pin => 5);
   Button : Input_Pin (Port => C, Pin => 13);
   Dimmer : PWM.Output (PWM.TIM3, 1, B, 4);

   --  TIM3 on PB4 is AF2, as in Chapter 10
   Timer_AF : constant Alternate_Function := 2;

   Started : Keel.Time.Time := 0;

   procedure Check (Stat : Status) is
   begin
      if Stat /= Ok then
         loop
            null;
         end loop;
      end if;
   end Check;

   procedure Initialize is
      Stat    : Status;
      Dimming : Setting;
   begin
      Keel.Time.Bare.Start (Sys_Frequency);
      Started := Keel.Time.Bare.Clock;

      Open (Port, Baud, Stat, How => Keel.Bus.UART.Interrupt);
      Check (Stat);

      Claim (LED, (Initial => Low, others => <>), Stat);
      Check (Stat);
      Claim (Button, (Bias => Floating), Stat);
      Check (Stat);
      Solve (PWM.Timer_Limits, Hertz (Sys_Frequency), "1 kHz",
             Trailing_Edge, Dimming, Stat);
      Check (Stat);
      PWM.Claim (Dimmer, Dimming, Timer_AF, Stat);
      Check (Stat);
   end Initialize;

   function Name return String is ("NUCLEO-G474RE");

   ------------------------------------------------------------------
   --  The console
   ------------------------------------------------------------------

   procedure Write (Text : String) is
   begin
      Keel.Bus.UART.STM32G4.Write (Port, Text);
   end Write;

   procedure Read (C : out Character; Got : out Boolean) is
   begin
      Keel.Bus.UART.STM32G4.Read (Port, C, Got);
   end Read;

   function Space return Natural is
     (Keel.Bus.UART.STM32G4.Space (Port));

   function Console_Name return String is
     ("LPUART1 on PA2/PA3," & Baud'Image & " 8N1");
   function Console_Mode return Keel.Bus.UART.Mode is (Mode_Of (Port));
   function Console_Counts return Keel.Bus.UART.Counts is
     (Statistics (Port));
   function Console_Baud return Natural is
     (Natural (Keel.Bus.UART.Actual
                 (Keel.Bus.UART.STM32G4.Limits,
                  Keel.Bus.UART.Clock_Hz (Sys_Frequency),
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

   ------------------------------------------------------------------
   --  Pins, PWM, ADC
   ------------------------------------------------------------------

   procedure Pin
     (Pin_Name : String; Act : Pin_Action; Level : out Boolean;
      Stat : out Status) is
   begin
      Level := False;
      Stat := Ok;
      if Pin_Name = "pa5" then
         case Act is
            when On     => Set (LED, High);
            when Off    => Set (LED, Low);
            when Toggle =>
               Set (LED, (if Driven (LED) = High then Low else High));
            when Read   => null;
         end case;
         Level := Driven (LED) = High;
      elsif Pin_Name = "pc13" and then Act = Read then
         Level := Get (Button) = High;
      else
         Stat := Not_Supported;
      end if;
   end Pin;

   function Pin_Names return String is
     ("pa5 (LD2), pc13 (B1, read only)");

   procedure Set_Duty
     (Pin_Name : String; P : Percent; Stat : out Status)
   is
   begin
      if Pin_Name /= "pb4" then
         Stat := Not_Supported;
         return;
      end if;
      PWM.Set_Level
        (Dimmer, (Top (PWM.Setting_Of (Dimmer)) + 1) * P / 100);
      Stat := Ok;
   end Set_Duty;

   function PWM_Names return String is ("pb4");

   procedure Read_ADC
     (Input : Natural; Code, Millivolts : out Natural;
      Stat : out Status)
   is
      pragma Unreferenced (Input);
   begin
      Code := 0;
      Millivolts := 0;
      Stat := Not_Supported;
   end Read_ADC;

   function ADC_Inputs return String is ("none: no STM32G4 ADC driver");

   procedure Read_Temperature (Centi : out Integer; Stat : out Status)
   is
   begin
      Centi := 0;
      Stat := Not_Supported;
   end Read_Temperature;

   ------------------------------------------------------------------
   --  Clocks and resets
   ------------------------------------------------------------------

   function Sys_Hz return Natural is (Natural (Sys_Frequency));
   function Peri_Hz return Natural is (Natural (Sys_Frequency));
   function Measured_kHz return Natural is (0);

   function Cause return Keel.Watchdog.Reset_Cause is (Dog.Last_Cause);
   function Reset_Flags return Natural is (Dog.Reset_Flags);

   --  No reset request in Keel here: the IWDG at its shortest
   procedure Reboot is
      Stat : Status;
   begin
      Flush (Port);
      Dog.Start (1, Stat);
      loop
         null;
      end loop;
   end Reboot;
end Board;
