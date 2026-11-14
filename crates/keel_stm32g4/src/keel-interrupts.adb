--  SPDX-License-Identifier: Apache-2.0
with System;
with Interfaces; use Interfaces;
with Keel.Cortex_M;

package body Keel.Interrupts is

   --  PM0214, 4.3 (NVIC), the same registers as on Armv8-M: one
   --  bit per interrupt in a row of words. Writing 1 to a set or
   --  clear register acts; 0 does nothing, so one store never
   --  disturbs the other interrupts.
   type Bit_Words is array (0 .. 15) of Unsigned_32
     with Volatile_Components;
   --  One priority byte per interrupt; byte access is allowed
   type Priority_Bytes is array (IRQ) of Unsigned_8
     with Volatile_Components;

   ISER : Bit_Words
     with Import, Address => System'To_Address (16#E000_E100#);
   ICER : Bit_Words
     with Import, Address => System'To_Address (16#E000_E180#);
   ISPR : Bit_Words
     with Import, Address => System'To_Address (16#E000_E200#);
   ICPR : Bit_Words
     with Import, Address => System'To_Address (16#E000_E280#);
   IPR : Priority_Bytes
     with Import, Address => System'To_Address (16#E000_E400#);

   function Word (N : IRQ) return Natural is (Natural (N) / 32);
   function Mask (N : IRQ) return Unsigned_32 is
     (Shift_Left (1, Natural (N) mod 32));

   procedure Set_Priority (N : IRQ; P : Priority) is
   begin
      IPR (N) := Unsigned_8 (P) * 16;
   end Set_Priority;

   function Priority_Of (N : IRQ) return Priority is
     (Priority (IPR (N) / 16));

   procedure Enable (N : IRQ) is
   begin
      ISER (Word (N)) := Mask (N);
   end Enable;

   --  After the store, the interrupt may still be taken once if it
   --  was already on its way: the barriers make sure it is not.
   procedure Disable (N : IRQ) is
   begin
      ICER (Word (N)) := Mask (N);
      Keel.Cortex_M.DSB;
      Keel.Cortex_M.ISB;
   end Disable;

   function Is_Enabled (N : IRQ) return Boolean is
     ((ISER (Word (N)) and Mask (N)) /= 0);

   procedure Set_Pending (N : IRQ) is
   begin
      ISPR (Word (N)) := Mask (N);
   end Set_Pending;

   procedure Clear_Pending (N : IRQ) is
   begin
      ICPR (Word (N)) := Mask (N);
   end Clear_Pending;

   function Is_Pending (N : IRQ) return Boolean is
     ((ISPR (Word (N)) and Mask (N)) /= 0);
end Keel.Interrupts;
