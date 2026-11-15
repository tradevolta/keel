--  SPDX-License-Identifier: Apache-2.0
package body Too_Soon
  with SPARK_Mode
is
   procedure Read_Early (First : out Unsigned_32) is
   begin
      Lend (Copy, Pending);
      First := Get (Copy, 0);
   end Read_Early;

   procedure Forge (First : out Unsigned_32) is
      Mine : Receipt;
   begin
      Lend (Copy, Pending);
      Reclaim (Copy, Mine);
      First := Get (Copy, 0);
   end Forge;
end Too_Soon;
