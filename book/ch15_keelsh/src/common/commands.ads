--  SPDX-License-Identifier: Apache-2.0
--  keelsh's commands, each a handler in the shell's table
package Commands is
   --  Put every command in the shell's table
   procedure Register_All;

   --  Decimal without Ada's leading space, and hex with "0x"
   function Image (N : Integer) return String;
   function Hex (N : Natural) return String;
end Commands;
