--  SPDX-License-Identifier: Apache-2.0
--  Keel.CLI: a command shell for a serial console. Keel.CLI.Lines is
--  the line discipline (echo, rub-out, CR LF, Ctrl-C), Keel.CLI.Words
--  splits a line into words and reads numbers, Keel.CLI.Shell holds
--  the command table and runs commands. Lines and Words are SPARK,
--  proved free of run-time errors with their contracts.
package Keel.CLI
  with Pure, SPARK_Mode
is
   --  The longest line the shell takes, and the most words in it
   Max_Line  : constant := 96;
   Max_Words : constant := 8;

   --  The control characters a terminal sends and the shell answers
   Ctrl_C : constant Character := Character'Val (3);
   Bell   : constant Character := Character'Val (7);
   BS     : constant Character := Character'Val (8);
   LF     : constant Character := Character'Val (10);
   CR     : constant Character := Character'Val (13);
   Ctrl_U : constant Character := Character'Val (21);
   ESC    : constant Character := Character'Val (27);
   DEL    : constant Character := Character'Val (127);

   --  The end of a line, as a terminal wants it
   CRLF : constant String := CR & LF;
end Keel.CLI;
