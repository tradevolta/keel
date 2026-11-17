--  SPDX-License-Identifier: Apache-2.0
--  The shell, on the board's console
with Board;
with Keel.CLI.Shell;

package Console_Shell is new Keel.CLI.Shell
  (Console => Board.Console, Prompt => "keelsh> ");
