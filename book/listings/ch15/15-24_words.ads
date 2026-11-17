subtype Word_Count is Natural range 0 .. Max_Words;

type Arguments is private;

function Count (A : Arguments) return Word_Count;

--  More words than Max_Words: the rest were left out
function Too_Many (A : Arguments) return Boolean;

function Word (A : Arguments; N : Positive) return String
  with Pre  => N <= Count (A),
       Post => Word'Result'Length in 1 .. Max_Line
               and then (for all C of Word'Result => C /= ' ');

procedure Split (Line : String; A : out Arguments)
  with Pre => Line'Length <= Max_Line;

--  A whole number in decimal, with an optional minus sign, from
--  -999 999 999 to 999 999 999. OK is False for anything else.
subtype Number is Integer range -999_999_999 .. 999_999_999;
procedure To_Number (S : String; N : out Number; OK : out Boolean);
