--  SPDX-License-Identifier: Apache-2.0
--  Keel.CLI.Lines: the line discipline. A terminal sends what you
--  type one character at a time and shows nothing itself; the
--  program echoes each character, rubs one out for Backspace or
--  Delete, ends the line on Enter, whether the terminal sends CR, LF
--  or CR LF, and throws it away on Ctrl-C or Ctrl-U. Escape
--  sequences, the arrow keys' ESC [ A and the rest, are swallowed
--  whole. Feed says what the terminal should see.
package Keel.CLI.Lines
  with Pure, SPARK_Mode
is
   subtype Line_Length is Natural range 0 .. Max_Line;

   type Editor is private
     with Default_Initial_Condition =>
       Length (Editor) = 0 and then not Is_Done (Editor);

   function Length (Ed : Editor) return Line_Length;

   --  A whole line is waiting for the program
   function Is_Done (Ed : Editor) return Boolean;

   --  The line so far, from 1
   function Text (Ed : Editor) return String
     with Post => Text'Result'First = 1
                  and then Text'Result'Length = Length (Ed);

   --  What to send back for one character
   type Action is
     (Nothing,   --  send nothing
      Echo,      --  send the character
      Rub_Out,   --  send BS, space, BS
      Line_End,  --  send CR LF: the line is done
      Cancel,    --  send "^C" and CR LF: the line is gone
      Ring);     --  send Bell: the line is full

   procedure Feed (Ed : in out Editor; C : Character; Act : out Action)
     with Pre  => not Is_Done (Ed),
          Post =>
            (case Act is
               when Echo =>
                 C in ' ' .. '~'
                 and then Text (Ed) = Text (Ed'Old) & C,
               when Rub_Out =>
                 Length (Ed'Old) > 0
                 and then Text (Ed)
                          = Text (Ed'Old) (1 .. Length (Ed'Old) - 1),
               when Line_End =>
                 Is_Done (Ed) and then Text (Ed) = Text (Ed'Old),
               when Cancel =>
                 Length (Ed) = 0,
               when Ring | Nothing =>
                 Text (Ed) = Text (Ed'Old))
            and then (if Act /= Line_End then not Is_Done (Ed));

   --  Ready for the next line. A CR LF split across two lines still
   --  counts once: Clear remembers the CR.
   procedure Clear (Ed : in out Editor)
     with Post => Length (Ed) = 0 and then not Is_Done (Ed);

private
   --  Where an escape sequence has got to: ESC, then for CSI "[",
   --  parameters, and a final byte from @ to ~
   type Escape_State is (Plain, After_ESC, In_CSI);

   type Editor is record
      Buffer  : String (1 .. Max_Line) := [others => ' '];
      Last    : Line_Length := 0;
      Done    : Boolean := False;
      Last_CR : Boolean := False;
      Escape  : Escape_State := Plain;
   end record;

   function Length (Ed : Editor) return Line_Length is (Ed.Last);
   function Is_Done (Ed : Editor) return Boolean is (Ed.Done);
   function Text (Ed : Editor) return String is
     (Ed.Buffer (1 .. Ed.Last));
end Keel.CLI.Lines;
