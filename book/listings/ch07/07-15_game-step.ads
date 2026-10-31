--  One millisecond. Pressed: the players whose button went down
--  in this millisecond. Seed: any number that varies from press
--  to press; the press that starts a round picks its delay.
procedure Step
  (S       : in out State;
   Pressed : Players;
   Seed    : Natural;
   E       : out Event);
