--  SPDX-License-Identifier: Apache-2.0
with Keel.CLI.Lines;

package body Keel.CLI.Shell is
   use Keel.CLI.Words;

   type Command is record
      Name      : String (1 .. Max_Name) := [others => ' '];
      Name_Last : Natural := 0;
      Usage     : String (1 .. Max_Usage) := [others => ' '];
      Use_Last  : Natural := 0;
      Run       : Handler := null;
   end record;

   Table : array (1 .. Max_Commands) of Command;
   Used  : Natural range 0 .. Max_Commands := 0;
   Ed    : Keel.CLI.Lines.Editor;

   function Find (Name : String) return Natural is
   begin
      for I in 1 .. Used loop
         if Table (I).Name (1 .. Table (I).Name_Last) = Name then
            return I;
         end if;
      end loop;
      return 0;
   end Find;

   procedure Register
     (Name  : String;
      Usage : String;
      Run   : not null Handler;
      Stat  : out Status) is
   begin
      if Used = Max_Commands or else Name = "help"
        or else Find (Name) /= 0
      then
         Stat := In_Use;
         return;
      end if;
      Used := Used + 1;
      Table (Used).Name (1 .. Name'Length) := Name;
      Table (Used).Name_Last := Name'Length;
      Table (Used).Usage (1 .. Usage'Length) := Usage;
      Table (Used).Use_Last := Usage'Length;
      Table (Used).Run := Run;
      Stat := Ok;
   end Register;

   procedure Put (Text : String) is
   begin
      Console.Write (Text);
   end Put;

   procedure Put_Line (Text : String) is
   begin
      Console.Write (Text & CRLF);
   end Put_Line;

   procedure Show_Usage (Name : String) is
      I : constant Natural := Find (Name);
   begin
      if I /= 0 then
         Put_Line ("usage: " & Table (I).Usage (1 .. Table (I).Use_Last));
      end if;
   end Show_Usage;

   procedure Help is
   begin
      Put_Line ("commands:");
      Put_Line ("  help");
      for I in 1 .. Used loop
         Put_Line ("  " & Table (I).Usage (1 .. Table (I).Use_Last));
      end loop;
   end Help;

   procedure Run (Line : String) is
      Args : Arguments;
   begin
      Split (Line, Args);
      if Count (Args) = 0 then
         return;
      elsif Too_Many (Args) then
         Put_Line ("too many words: at most" & Max_Words'Image);
      elsif Word (Args, 1) = "help" then
         Help;
      else
         declare
            I : constant Natural := Find (Word (Args, 1));
         begin
            if I = 0 then
               Put_Line ("unknown command: " & Word (Args, 1)
                         & " (try help)");
            else
               Table (I).Run (Args);
            end if;
         end;
      end if;
   end Run;

   procedure Start (Banner : String) is
   begin
      Put_Line (Banner);
      Put_Line ("type help for commands");
      Put (Prompt);
   end Start;

   procedure Poll is
      use Keel.CLI.Lines;
      C   : Character;
      Got : Boolean;
      Act : Action;
   begin
      loop
         Console.Read (C, Got);
         exit when not Got;
         Feed (Ed, C, Act);
         case Act is
            when Nothing  => null;
            when Echo     => Put ([C]);
            when Rub_Out  => Put (BS & ' ' & BS);
            when Ring     => Put ([Bell]);
            when Cancel   => Put ("^C" & CRLF & Prompt);
            when Line_End =>
               Put (CRLF);
               Run (Text (Ed));
               Clear (Ed);
               Put (Prompt);
               --  One line a call, so the main loop gets a turn
               exit;
         end case;
      end loop;
   end Poll;
end Keel.CLI.Shell;
