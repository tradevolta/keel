--  SPDX-License-Identifier: Apache-2.0
with System.Machine_Code; use System.Machine_Code;

package body Keel.Cortex_M is
   procedure DSB is
   begin
      Asm ("dsb", Volatile => True, Clobber => "memory");
   end DSB;

   procedure ISB is
   begin
      Asm ("isb", Volatile => True, Clobber => "memory");
   end ISB;

   procedure NOP is
   begin
      Asm ("nop", Volatile => True);
   end NOP;

   procedure WFI is
   begin
      Asm ("wfi", Volatile => True);
   end WFI;
end Keel.Cortex_M;
