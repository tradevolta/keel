--  SPDX-License-Identifier: Apache-2.0
--  Chapter 3: hand-written overlays for four RP2350 register blocks.
--  Types only, no addresses, so the same specs compile for the host
--  (gnat_native) and for the RP2350 (gnat_arm_elf).
package RP2350
  with Pure
is
   type UInt2  is mod 2**2  with Size => 2;
   type UInt3  is mod 2**3  with Size => 3;
   type UInt7  is mod 2**7  with Size => 7;
   type UInt10 is mod 2**10 with Size => 10;
   type UInt23 is mod 2**23 with Size => 23;

   --  A register whose fields this chapter leaves raw.
   type Register is mod 2**32
     with Size => 32, Volatile_Full_Access;

   type Pin_Id is range 0 .. 47;            --  GPIO0 .. GPIO47
   subtype Low_Pin is Pin_Id range 0 .. 31; --  in SIO GPIO_OUT etc.
end RP2350;
