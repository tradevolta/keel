--  SPDX-License-Identifier: Apache-2.0
--  Hand-written (not generated): the RP2350's atomic register aliases
--  as typed procedures. Every peripheral on the APB and AHB buses
--  decodes three more copies of each register (RP2350 datasheet,
--  section 2.1.3): a write to +0x1000 XORs, to +0x2000 sets and to
--  +0x3000 clears the bits written, in one bus write. SIO is the
--  exception: it has its own SET, CLR and XOR registers.
generic
   --  A register type from gen/
   type Register is private;
package RP2350_SVD.Atomic
  with Preelaborate
is
   --  All fields zero: the starting point for a mask, so that
   --  (No_Bits with delta ISO => True) names one bit. A register's
   --  default value is its reset value, which is not a mask.
   function No_Bits return Register
     with Inline;

   --  Set, clear or toggle in Reg the bits that are 1 in Bits. Other
   --  bits do not change, even if another bus master writes Reg at
   --  the same time. Reg is passed by reference (it is aliased), so
   --  Reg'Address is the register's own address.
   procedure Set (Reg : aliased in out Register; Bits : Register)
     with Inline;
   procedure Clear (Reg : aliased in out Register; Bits : Register)
     with Inline;
   procedure Toggle (Reg : aliased in out Register; Bits : Register)
     with Inline;
end RP2350_SVD.Atomic;
