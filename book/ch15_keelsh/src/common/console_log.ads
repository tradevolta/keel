--  SPDX-License-Identifier: Apache-2.0
--  The log, on the same console: a line that would wait for room is
--  dropped and counted instead
with Board;
with Keel.Log.Logger;
with Keel.Log.UART_Sink;

package Console_Log is
   package Sink is new Keel.Log.UART_Sink (Board.Console);
   package Log is new Keel.Log.Logger (Sink.Write, Board.Uptime_Ms);
end Console_Log;
