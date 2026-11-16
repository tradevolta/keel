--  SPDX-License-Identifier: Apache-2.0
--  A fake board for the host: the console is standard input and
--  output, and the rest is a model with no hardware behind it. The
--  LED and the PWM output only remember what they were told; there
--  is no ADC and no temperature sensor; the clocks are the Pico's
--  settings, not measurements, and the divisor is the one the real
--  driver would solve for. Time moves a millisecond per Idle, so a
--  run gives the same log stamps every time. At the end of the
--  input, the program ends.
with Ada.Text_IO;
with Ada.Text_IO.Text_Streams;
with GNAT.OS_Lib;
with Keel.Bus.UART;     use Keel.Bus.UART;
with Keel.Bus.UART.Chip_Limits;

package body Board is
   use Ada.Text_IO;

   Input  : constant Text_Streams.Stream_Access :=
     Text_Streams.Stream (Standard_Input);
   Output : constant Text_Streams.Stream_Access :=
     Text_Streams.Stream (Standard_Output);

   At_End : Boolean := False;
   Ms     : Natural := 0;
   Tally  : Counts;
   LED    : Boolean := False;

   Sys  : constant := 150_000_000;
   Baud : constant := 115_200;
   D    : Divisor := 0;

   procedure Initialize is
      Found : Boolean;
   begin
      Solve (Chip_Limits.RP2350_PL011, Sys, Baud, D, Found);
      pragma Assert (Found);
   end Initialize;

   function Name return String is ("host (fake board)");

   procedure Write (Text : String) is
   begin
      String'Write (Output, Text);
      Tally.Sent := Tally.Sent + Text'Length;
   end Write;

   procedure Read (C : out Character; Got : out Boolean) is
   begin
      C := ASCII.NUL;
      Got := False;
      if not At_End then
         Character'Read (Input, C);
         Got := True;
         Tally.Received := Tally.Received + 1;
      end if;
   exception
      when End_Error =>
         At_End := True;
   end Read;

   function Space return Natural is (Natural'Last);

   function Console_Name return String is
     ("standard input and output, as UART0 at" & Baud'Image & " 8N1");
   function Console_Mode return Keel.Bus.UART.Mode is (Polled);
   function Console_Counts return Counts is (Tally);
   function Console_Baud return Natural is
     (Natural (Actual (Chip_Limits.RP2350_PL011, Sys, D)));
   function Console_Divisor return Natural is (D);

   function Uptime_Ms return Natural is (Ms);

   procedure Idle is
   begin
      if At_End then
         Flush (Standard_Output);
         GNAT.OS_Lib.OS_Exit (0);
      end if;
      Ms := Ms + 1;
   end Idle;

   procedure Pin
     (Pin_Name : String; Act : Pin_Action; Level : out Boolean;
      Stat : out Status) is
   begin
      Level := False;
      Stat := Ok;
      if Pin_Name = "15" then
         case Act is
            when On     => LED := True;
            when Off    => LED := False;
            when Toggle => LED := not LED;
            when Read   => null;
         end case;
         Level := LED;
      else
         Stat := Not_Supported;
      end if;
   end Pin;

   function Pin_Names return String is ("15 (a pretend LED)");

   procedure Set_Duty (Pin_Name : String; P : Percent; Stat : out Status)
   is
      pragma Unreferenced (P);
   begin
      Stat := (if Pin_Name = "14" then Ok else Not_Supported);
   end Set_Duty;

   function PWM_Names return String is ("14 (pretend)");

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

   function ADC_Inputs return String is ("none on the host");

   procedure Read_Temperature (Centi : out Integer; Stat : out Status)
   is
   begin
      Centi := 0;
      Stat := Not_Supported;
   end Read_Temperature;

   function Sys_Hz return Natural is (Sys);
   function Peri_Hz return Natural is (Sys);
   function Measured_kHz return Natural is (0);

   function Cause return Keel.Watchdog.Reset_Cause is
     (Keel.Watchdog.Power_On);
   function Reset_Flags return Natural is (0);

   procedure Reboot is
   begin
      Flush (Standard_Output);
      GNAT.OS_Lib.OS_Exit (0);
   end Reboot;
end Board;
