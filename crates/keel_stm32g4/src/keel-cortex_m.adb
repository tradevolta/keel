--  SPDX-License-Identifier: Apache-2.0
with System.Machine_Code; use System.Machine_Code;
with Interfaces; use type Interfaces.Unsigned_32;

package body Keel.Cortex_M is
   procedure DSB is
   begin
      Asm ("dsb", Volatile => True, Clobber => "memory");
   end DSB;

   procedure DMB is
   begin
      Asm ("dmb", Volatile => True, Clobber => "memory");
   end DMB;

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

   procedure Disable_Interrupts is
   begin
      Asm ("cpsid i", Volatile => True, Clobber => "memory");
   end Disable_Interrupts;

   procedure Enable_Interrupts is
   begin
      Asm ("cpsie i", Volatile => True, Clobber => "memory");
   end Enable_Interrupts;

   function Interrupts_Disabled return Boolean is
      Mask : Word;
   begin
      Asm ("mrs %0, primask",
           Outputs => Word'Asm_Output ("=r", Mask),
           Volatile => True);
      return (Mask and 1) = 1;
   end Interrupts_Disabled;

   function Stack_Pointer return System.Address is
      SP : System.Address;
   begin
      Asm ("mov %0, sp",
           Outputs => System.Address'Asm_Output ("=r", SP),
           Volatile => True);
      return SP;
   end Stack_Pointer;
end Keel.Cortex_M;
