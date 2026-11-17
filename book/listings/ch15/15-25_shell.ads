--  SPDX-License-Identifier: Apache-2.0
--  Keel.CLI.Shell: a command shell over a console. Register commands,
--  call Start once, then Poll from the main loop: Poll takes what has
--  arrived, echoes it through Keel.CLI.Lines, and when a line ends,
--  runs its command. "help" is built in. Poll never waits, so the
--  main loop keeps doing its other work between keystrokes.
with Keel.Bus.UART;
with Keel.CLI.Words;

generic
   with package Console is new Keel.Bus.UART.Text_Signature (<>);
   Prompt : String := "> ";
package Keel.CLI.Shell is
   type Handler is access procedure (Args : Keel.CLI.Words.Arguments);

   Max_Commands : constant := 16;
   Max_Name     : constant := 12;
   Max_Usage    : constant := 60;

   --  Name is what you type; Usage, which starts with Name, is what
   --  help shows. In_Use: the name is taken or the table is full.
   procedure Register
     (Name  : String;
      Usage : String;
      Run   : not null Handler;
      Stat  : out Status)
     with Pre => Name'Length in 1 .. Max_Name
                 and then Usage'Length in 1 .. Max_Usage;

   --  The banner and the first prompt
   procedure Start (Banner : String);

   --  Everything that has arrived, up to the end of one line
   procedure Poll;

   --  For handlers: text, and text with CR LF
   procedure Put (Text : String);
   procedure Put_Line (Text : String);

   --  "usage: " and the command's usage line
   procedure Show_Usage (Name : String);
end Keel.CLI.Shell;
