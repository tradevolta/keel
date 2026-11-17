--  The console
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
