--  SPDX-License-Identifier: Apache-2.0
--  keelsh: Keel's shell on a UART console. The main loop polls the
--  shell, logs when the console's error counts grow, and idles.
with Board;
with Commands;      use Commands;
with Console_Log;   use Console_Log;
with Console_Shell;
with Keel;
with Keel.Bus.UART; use Keel.Bus.UART;

procedure Keelsh is
   Seen : Counts := Board.Console_Counts;
   Beat : Natural := 0;

   procedure Check_Counts is
      Now : constant Counts := Board.Console_Counts;
   begin
      if Now.Overruns /= Seen.Overruns
        or else Now.Dropped /= Seen.Dropped
      then
         Log.Warn ("uart: " & Image (Now.Overruns) & " overruns, "
                   & Image (Now.Dropped) & " dropped");
      end if;
      if Now.Framing /= Seen.Framing or else Now.Parity /= Seen.Parity
        or else Now.Breaks /= Seen.Breaks
      then
         Log.Warn ("uart: " & Image (Now.Framing) & " framing, "
                   & Image (Now.Parity) & " parity, "
                   & Image (Now.Breaks) & " breaks");
      end if;
      Seen := Now;
   end Check_Counts;
begin
   Board.Initialize;
   Seen := Board.Console_Counts;
   Register_All;
   Console_Shell.Start ("keelsh " & Keel.Version & " on " & Board.Name
                        & ", " & Board.Console_Name);
   loop
      Console_Shell.Poll;
      Check_Counts;
      --  At debug level, a line every 10 s shows the log running
      if Board.Uptime_Ms / 10_000 /= Beat then
         Beat := Board.Uptime_Ms / 10_000;
         Log.Debug ("up " & Image (Beat * 10) & " s");
      end if;
      Board.Idle;
   end loop;
end Keelsh;
