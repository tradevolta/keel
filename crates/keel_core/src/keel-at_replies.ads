--  SPDX-License-Identifier: Apache-2.0
--  Keel.AT_Replies: the lines a modem sends back to AT commands
--  (ITU-T V.250, 3GPP TS 27.007, Espressif's ESP-AT). A command such
--  as AT+CWJAP? is answered by lines of information, "+CWJAP:...",
--  then one final result: OK, ERROR, or "+CME ERROR: <n>". Lines can
--  arrive in between that belong to no command, unsolicited results
--  such as "+IPD,..." or "WIFI GOT IP". Classify sorts a line; a
--  driver waits for a final one. ("at" is a reserved word in Ada,
--  so the package can't be called Keel.AT.)
package Keel.AT_Replies
  with Pure, SPARK_Mode
is
   type Kind is
     (Blank,        --  an empty line: modems put them around results
      Echo,         --  the command itself, sent back with ATE1
      Ok,           --  the final result: success
      Error,        --  the final result: failure, no reason given
      Error_Code,   --  the final result: +CME ERROR: or +CMS ERROR:
      Information,  --  "+NAME:..." for the command in progress
      Unsolicited,  --  "+NAME..." for anything else
      Prompt,       --  ">": the modem waits for data
      Text);        --  anything else

   function Is_Final (K : Kind) return Boolean is
     (K in Ok | Error | Error_Code);

   function Starts_With (S, Prefix : String) return Boolean is
     (S'Length >= Prefix'Length
      and then S (S'First .. S'First - 1 + Prefix'Length) = Prefix);

   --  Line is "<Command>:...", the information for Command
   function Answers (Line, Command : String) return Boolean is
     (Command'Length > 0
      and then Line'Length > Command'Length
      and then Starts_With (Line, Command)
      and then Line (Line'First + Command'Length) = ':');

   function Has_Error_Code (Line : String) return Boolean is
     (Starts_With (Line, "+CME ERROR:")
      or else Starts_With (Line, "+CMS ERROR:"));

   --  Line has its CR LF removed. Command is the name of the command
   --  in progress, such as "+CWJAP", or "" if there is none.
   function Classify (Line : String; Command : String) return Kind
     with Pre  => Command'Length < 32,
          Post => (Classify'Result = Ok) = (Line = "OK")
                  and then (Classify'Result = Error) = (Line = "ERROR")
                  and then (Classify'Result = Error_Code)
                           = Has_Error_Code (Line)
                  and then (if Classify'Result = Information
                            then Answers (Line, Command));

   --  The number in "+CME ERROR: 30". Found is False if there's no
   --  number, or it has more than six digits.
   procedure Error_Number
     (Line : String; N : out Natural; Found : out Boolean)
     with Pre  => Has_Error_Code (Line),
          Post => (if Found then N <= 999_999);
end Keel.AT_Replies;
