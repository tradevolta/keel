--  SPDX-License-Identifier: Apache-2.0
--  Keel.Log: a log line is a time stamp, a level and a message,
--  such as "[     12.345] INFO  adc 0: 1650 mV",
--  ending in CR LF. Line builds it, proved free of run-time errors
--  with its length known; Keel.Log.Logger filters by level and
--  writes; Keel.Log.UART_Sink is a writer that drops a whole line
--  rather than wait for room.
package Keel.Log
  with Pure, SPARK_Mode
is
   type Level is (Debug, Info, Warn, Error);

   --  Five characters each, so messages line up
   function Label (L : Level) return String
     with Post => Label'Result'Length = 5;

   --  "[sssssss.mmm]": seconds and milliseconds since start. Seven
   --  digits of seconds hold Natural'Last milliseconds, 24.8 days,
   --  where a millisecond count in a Natural wraps.
   Stamp_Length : constant := 13;
   function Stamp (Ms : Natural) return String
     with Post => Stamp'Result'Length = Stamp_Length
                  and then Stamp'Result'First = 1;

   Max_Message : constant := 80;

   --  Stamp, space, label, space, message, CR LF
   Overhead : constant := Stamp_Length + 1 + 5 + 1 + 2;
   function Line (Ms : Natural; L : Level; Message : String)
     return String
     with Pre  => Message'Length <= Max_Message,
          Post => Line'Result'Length = Overhead + Message'Length;
end Keel.Log;
