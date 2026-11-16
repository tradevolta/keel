--  SPDX-License-Identifier: Apache-2.0
--  A writer for Keel.Log.Logger over a console. A log line that
--  would have to wait for room is dropped whole and counted, so
--  logging never stalls the code that logs, and the console never
--  shows half a line. A polled console has room for anything.
with Keel.Bus.UART;

generic
   with package Console is new Keel.Bus.UART.Text_Signature (<>);
package Keel.Log.UART_Sink is
   procedure Write (Text : String);

   --  Lines dropped since start, stopping at Natural'Last
   function Dropped return Natural;
end Keel.Log.UART_Sink;
