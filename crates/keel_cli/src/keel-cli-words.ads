--  SPDX-License-Identifier: Apache-2.0
--  Keel.CLI.Words: a line as words, split on spaces, and the numbers
--  in them. A command handler gets Arguments: word 1 is the command's
--  name, words 2 onward its arguments.
package Keel.CLI.Words
  with Pure, SPARK_Mode
is
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

private
   type Bounds is record
      First : Positive := 1;
      Last  : Natural  := 0;
   end record;
   type Bounds_Array is array (1 .. Max_Words) of Bounds;

   type Arguments is record
      Line  : String (1 .. Max_Line) := [others => ' '];
      Count : Word_Count := 0;
      Words : Bounds_Array := [others => <>];
      More  : Boolean := False;
   end record
     with Predicate =>
       (for all I in 1 .. Count =>
          Words (I).First <= Words (I).Last
          and then Words (I).Last <= Max_Line
          and then (for all J in Words (I).First .. Words (I).Last =>
                      Line (J) /= ' '));

   function Count (A : Arguments) return Word_Count is (A.Count);
   function Too_Many (A : Arguments) return Boolean is (A.More);
   function Word (A : Arguments; N : Positive) return String is
     (A.Line (A.Words (N).First .. A.Words (N).Last));
end Keel.CLI.Words;
