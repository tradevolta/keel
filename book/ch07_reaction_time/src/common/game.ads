--  SPDX-License-Identifier: Apache-2.0
--  The reaction-time game as a state machine that advances one
--  millisecond per Step. No pins and no clock in here: a board feeds
--  in the presses and shows the lamps, so the same game runs on the
--  Pico 2 W, the NUCLEO-G474RE and the host.
package Game
  with Pure
is
   type Player is (A, B);
   type Players is array (Player) of Boolean;
   Nobody : constant Players := [others => False];

   type Milliseconds is range 0 .. 10_000;

   --  Idle: waiting for a press to start. Waiting: the random
   --  delay. Go: the Go lamp is lit. Done: the result is shown.
   type Phase is (Idle, Waiting, Go, Done);

   type Lamps is record
      Go     : Boolean := False;
      Winner : Players := Nobody;
   end record;

   type Event_Kind is (None, Started, False_Start, Winner, No_Press);

   --  Who: the early presser (False_Start) or the winners (Winner;
   --  both on a tie). Time: the reaction time of a Winner.
   type Event is record
      Kind : Event_Kind   := None;
      Who  : Players      := Nobody;
      Time : Milliseconds := 0;
   end record;

   type State is private;

   function Current (S : State) return Phase;
   function Lit (S : State) return Lamps;

   --  One millisecond. Pressed: the players whose button went down
   --  in this millisecond. Seed: any number that varies from press
   --  to press; the press that starts a round picks its delay.
   procedure Step
     (S       : in out State;
      Pressed : Players;
      Seed    : Natural;
      E       : out Event);

   --  One line for the console, "" for None
   function Message (E : Event) return String;

   Shortest_Delay : constant Milliseconds := 1_000;
   Longest_Delay  : constant Milliseconds := 4_000;
   Time_Limit     : constant Milliseconds := 2_000;
   Show_Time      : constant Milliseconds := 2_000;

private
   type State is record
      Now   : Phase        := Idle;
      Left  : Milliseconds := 0;    --  time left in this phase
      Taken : Milliseconds := 0;    --  time since Go
      Shown : Lamps;
   end record;

   function Current (S : State) return Phase is (S.Now);
   function Lit (S : State) return Lamps is (S.Shown);
end Game;
