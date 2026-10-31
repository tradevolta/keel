--  SPDX-License-Identifier: Apache-2.0
--  The reaction-time game: press A or B to start; after a random
--  delay the Go lamp lights; the first press after it wins.
with Board;
with Game; use Game;

procedure Reaction_Time is
   S       : State;
   E       : Event;
   Elapsed : Natural := 0;   --  ms since Initialize

   --  " 12.345 s", for the start of each console line
   function Stamp return String is
      Ms : constant String := Natural'Image (1_000 + Elapsed mod 1_000);
   begin
      return Natural'Image (Elapsed / 1_000) & "."
        & Ms (Ms'Last - 2 .. Ms'Last) & " s  ";
   end Stamp;
begin
   Board.Initialize;
   Board.Put_Line ("reaction_time: press A or B to start");
   loop
      Board.Next_Tick;
      Elapsed := Elapsed + 1;
      Step (S, Board.Presses, Board.Clock, E);
      Board.Show (Lit (S));
      if E.Kind /= None then
         Board.Put_Line (Stamp & Message (E));
      end if;
   end loop;
end Reaction_Time;
