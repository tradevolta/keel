--  SPDX-License-Identifier: Apache-2.0
with Board;
with Console_Log;     use Console_Log;
with Console_Shell;   use Console_Shell;
with Keel;            use Keel;
with Keel.Bus.UART;   use Keel.Bus.UART;
with Keel.CLI.Words;  use Keel.CLI.Words;
with Keel.Log;
with Keel.NMEA;

package body Commands is

   function Image (N : Integer) return String is
      S : constant String := N'Image;
   begin
      return (if N < 0 then S else S (S'First + 1 .. S'Last));
   end Image;

   function Hex (N : Natural) return String is
      Digits_Of : constant String := "0123456789abcdef";
      Result    : String (1 .. 8);
      V         : Natural := N;
      First     : Positive := Result'Last;
   begin
      for I in reverse Result'Range loop
         Result (I) := Digits_Of (V mod 16 + 1);
         V := V / 16;
         First := I;
         exit when V = 0;
      end loop;
      return "0x" & Result (First .. Result'Last);
   end Hex;

   function Lower (S : String) return String is
      R : String := S;
   begin
      for C of R loop
         if C in 'A' .. 'Z' then
            C := Character'Val (Character'Pos (C) + 32);
         end if;
      end loop;
      return R;
   end Lower;

   --  gpio <pin> [on|off|toggle|read]
   procedure Gpio (Args : Arguments) is
      Act   : Board.Pin_Action := Board.Read;
      Level : Boolean;
      Stat  : Status;
   begin
      if Count (Args) not in 2 .. 3 then
         Show_Usage ("gpio");
         return;
      elsif Count (Args) = 3 then
         declare
            W : constant String := Word (Args, 3);
         begin
            if W = "on" then
               Act := Board.On;
            elsif W = "off" then
               Act := Board.Off;
            elsif W = "toggle" then
               Act := Board.Toggle;
            elsif W /= "read" then
               Show_Usage ("gpio");
               return;
            end if;
         end;
      end if;
      Board.Pin (Word (Args, 2), Act, Level, Stat);
      if Stat /= Ok then
         Put_Line ("gpio: can't " & Lower (Act'Image) & " "
                   & Word (Args, 2) & "; pins: " & Board.Pin_Names);
      else
         Put_Line (Word (Args, 2) & ": "
                   & (if Level then "high" else "low"));
      end if;
   end Gpio;

   --  pwm <pin> <percent>
   procedure Pwm (Args : Arguments) is
      N    : Number;
      Good : Boolean;
      Stat : Status;
   begin
      if Count (Args) /= 3 then
         Show_Usage ("pwm");
         return;
      end if;
      To_Number (Word (Args, 3), N, Good);
      if not Good or else N not in Board.Percent then
         Put_Line ("pwm: the duty is a whole percent, 0 to 100");
         return;
      end if;
      Board.Set_Duty (Word (Args, 2), N, Stat);
      if Stat /= Ok then
         Put_Line ("pwm: no PWM on " & Word (Args, 2)
                   & "; outputs: " & Board.PWM_Names);
      else
         Put_Line (Word (Args, 2) & ": " & Image (N) & "% at 1 kHz");
      end if;
   end Pwm;

   --  adc <input>|temp
   procedure Adc (Args : Arguments) is
      N        : Number;
      Good     : Boolean;
      Code, MV : Natural;
      Centi    : Integer;
      Stat     : Status;
   begin
      if Count (Args) /= 2 then
         Show_Usage ("adc");
         return;
      elsif Word (Args, 2) = "temp" then
         Board.Read_Temperature (Centi, Stat);
         if Stat /= Ok then
            Put_Line ("adc: no temperature sensor driver here");
         else
            Put_Line ("temp: " & Image (Centi / 100) & "."
                      & Image (abs Centi mod 100 / 10)
                      & Image (abs Centi mod 10) & " C");
         end if;
         return;
      end if;
      To_Number (Word (Args, 2), N, Good);
      if Good and then N >= 0 then
         Board.Read_ADC (N, Code, MV, Stat);
      else
         Stat := Not_Supported;
      end if;
      if Stat /= Ok then
         Put_Line ("adc: no input " & Word (Args, 2) & "; inputs: "
                   & Board.ADC_Inputs);
      else
         Put_Line ("adc " & Image (N) & ": " & Image (Code) & " ("
                   & Image (MV) & " mV)");
      end if;
   end Adc;

   --  clock
   procedure Clock (Args : Arguments) is
      kHz : constant Natural := Board.Measured_kHz;
   begin
      if Count (Args) /= 1 then
         Show_Usage ("clock");
         return;
      end if;
      Put_Line ("clk_sys  " & Image (Board.Sys_Hz) & " Hz"
                & (if kHz = 0 then ""
                   else ", counted " & Image (kHz) & " kHz"));
      Put_Line ("clk_peri " & Image (Board.Peri_Hz) & " Hz");
      Put_Line ("console  " & Board.Console_Name);
      Put_Line ("divisor  " & Image (Board.Console_Divisor)
                & ", making " & Image (Board.Console_Baud) & " baud");
   end Clock;

   --  reset-reason
   procedure Reset_Reason (Args : Arguments) is
   begin
      if Count (Args) /= 1 then
         Show_Usage ("reset-reason");
         return;
      end if;
      Put_Line (Lower (Board.Cause'Image) & " (flags "
                & Hex (Board.Reset_Flags) & ")");
   end Reset_Reason;

   --  reboot
   procedure Reboot (Args : Arguments) is
   begin
      if Count (Args) /= 1 then
         Show_Usage ("reboot");
         return;
      end if;
      Put_Line ("rebooting");
      Board.Reboot;
   end Reboot;

   --  uart
   procedure Uart (Args : Arguments) is
      C : constant Counts := Board.Console_Counts;
   begin
      if Count (Args) /= 1 then
         Show_Usage ("uart");
         return;
      end if;
      Put_Line ("mode " & Lower (Board.Console_Mode'Image)
                & ", received " & Image (C.Received)
                & ", sent " & Image (C.Sent));
      Put_Line ("overruns " & Image (C.Overruns)
                & ", framing " & Image (C.Framing)
                & ", parity " & Image (C.Parity)
                & ", breaks " & Image (C.Breaks)
                & ", dropped " & Image (C.Dropped));
   end Uart;

   --  nmea <sentence>
   procedure Nmea (Args : Arguments) is
      use Keel.NMEA;
   begin
      if Count (Args) /= 2 then
         Show_Usage ("nmea");
         return;
      end if;
      declare
         S : constant String := Word (Args, 2);
         V : constant Verdict := Check (S);
         First, Last : Natural;
         Found       : Boolean;
      begin
         Put_Line (Lower (V'Image));
         if V = Valid then
            for N in 0 .. 19 loop
               Field (S, N, First, Last, Found);
               exit when not Found;
               Put_Line ("  " & Image (N) & ": " & S (First .. Last));
            end loop;
         end if;
      end;
   end Nmea;

   --  log [debug|info|warn|error]
   procedure Log_Level (Args : Arguments) is
   begin
      if Count (Args) = 2 then
         for L in Keel.Log.Level loop
            if Lower (L'Image) = Word (Args, 2) then
               Console_Log.Log.Set_Threshold (L);
               Console_Log.Log.Put (L, "log: from " & Word (Args, 2) & " up");
               return;
            end if;
         end loop;
      end if;
      if Count (Args) /= 1 then
         Show_Usage ("log");
         return;
      end if;
      Put_Line ("log: from " & Lower (Console_Log.Log.Threshold'Image)
                & " up, " & Image (Sink.Dropped) & " lines dropped");
   end Log_Level;

   procedure Register_All is
      procedure Add (Name, Usage : String; Run : not null Handler) is
         Stat : Status;
      begin
         Register (Name, Usage, Run, Stat);
         pragma Assert (Stat = Ok);
      end Add;
   begin
      Add ("gpio", "gpio <pin> [on|off|toggle|read]", Gpio'Access);
      Add ("pwm", "pwm <pin> <percent>", Pwm'Access);
      Add ("adc", "adc <input>|temp", Adc'Access);
      Add ("clock", "clock", Clock'Access);
      Add ("reset-reason", "reset-reason", Reset_Reason'Access);
      Add ("reboot", "reboot", Reboot'Access);
      Add ("uart", "uart", Uart'Access);
      Add ("nmea", "nmea <sentence>", Nmea'Access);
      Add ("log", "log [debug|info|warn|error]", Log_Level'Access);
   end Register_All;
end Commands;
