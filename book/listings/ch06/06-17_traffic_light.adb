--  SPDX-License-Identifier: Apache-2.0
--  Project 6: the register-level traffic light.
with Board;
with Traffic; use Traffic;

procedure Traffic_Light is
   State : Aspect := Stop;
begin
   Board.Initialize;
   loop
      Board.Show (Lit (State));
      Board.Wait (Hold (State));
      State := Next (State);
   end loop;
end Traffic_Light;
