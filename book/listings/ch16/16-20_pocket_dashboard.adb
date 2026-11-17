--  SPDX-License-Identifier: Apache-2.0
--  The pocket dashboard: Chapter 15's shell, and a frame on the
--  display every time round the loop. Show returns once the frame is
--  drawn and the one before it is sent, so the loop runs as fast as
--  the slower of the two.
with Board;
with Commands;
with Console_Log;     use Console_Log;
with Console_Shell;
with Dashboard;
with Display;
with Keel;            use Keel;
with Screen_Commands;

procedure Pocket_Dashboard is
   R    : Dashboard.Readings;
   Stat : Status;
begin
   Board.Initialize;
   Commands.Register_All;
   Screen_Commands.Register;
   Display.Initialize (Stat);
   Console_Shell.Start ("pocket dashboard, keel " & Keel.Version
                        & " on " & Board.Name & ", " & Display.Name);
   if Stat /= Ok then
      Log.Error ("display: " & Stat'Image);
   end if;
   loop
      Console_Shell.Poll;
      Screen_Commands.Update (R);
      if Display.Is_Ready and then Screen_Commands.Running then
         Display.Show (R);
      else
         Board.Idle;
      end if;
   end loop;
end Pocket_Dashboard;
