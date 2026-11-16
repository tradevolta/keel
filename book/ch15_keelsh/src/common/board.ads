--  SPDX-License-Identifier: Apache-2.0
--  What keelsh needs from a board: a console on a UART, a few pins
--  to drive and read, a PWM output, the ADC, the clocks, and why the
--  chip last started. Pins are named as the board's silk screen
--  names them, "15" on the Pico, "pa5" on the NUCLEO; Pin_Names says
--  which the board offers. The body has its wiring in its comments.
with Keel;          use Keel;
with Keel.Bus.UART;
with Keel.Watchdog;

package Board is
   --  Start the clocks, the time base, the console and the pins.
   --  Stops the program if any of them fails.
   procedure Initialize;

   function Name return String;

   ------------------------------------------------------------------
   --  The console
   ------------------------------------------------------------------
   procedure Write (Text : String);
   procedure Read (C : out Character; Got : out Boolean);
   function Space return Natural;
   package Console is new Keel.Bus.UART.Text_Signature
     (Write, Read, Space);

   --  "UART0 on GP0/GP1, 115200 8N1"
   function Console_Name return String;
   function Console_Mode return Keel.Bus.UART.Mode;
   function Console_Counts return Keel.Bus.UART.Counts;
   --  The baud rate the divider really makes, and the divisor
   function Console_Baud return Natural;
   function Console_Divisor return Natural;

   --  Milliseconds since Initialize
   function Uptime_Ms return Natural;

   --  Between polls: nothing for a polled console, which must be
   --  read before its FIFO fills; a millisecond's wait otherwise
   procedure Idle;

   ------------------------------------------------------------------
   --  Pins, PWM, ADC
   ------------------------------------------------------------------
   type Pin_Action is (On, Off, Toggle, Read);

   --  Level is the pin's level after Act. Not_Supported: the board
   --  has no such pin, or it can't do Act (an input can only Read).
   procedure Pin
     (Pin_Name : String; Act : Pin_Action; Level : out Boolean;
      Stat : out Status);
   function Pin_Names return String;

   subtype Percent is Natural range 0 .. 100;
   procedure Set_Duty (Pin_Name : String; P : Percent; Stat : out Status);
   function PWM_Names return String;

   --  An ADC input's reading and its voltage. Not_Supported: there
   --  is no such input, or no ADC driver for this chip.
   procedure Read_ADC
     (Input : Natural; Code, Millivolts : out Natural;
      Stat : out Status);
   function ADC_Inputs return String;

   --  The chip's own temperature in hundredths of a degree
   procedure Read_Temperature (Centi : out Integer; Stat : out Status);

   ------------------------------------------------------------------
   --  Clocks and resets
   ------------------------------------------------------------------
   function Sys_Hz return Natural;
   function Peri_Hz return Natural;
   --  clk_sys counted against the crystal, 0 if the chip can't
   function Measured_kHz return Natural;

   function Cause return Keel.Watchdog.Reset_Cause;
   function Reset_Flags return Natural;
   procedure Reboot
     with No_Return;
end Board;
