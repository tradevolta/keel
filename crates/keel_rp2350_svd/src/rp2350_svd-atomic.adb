--  SPDX-License-Identifier: Apache-2.0
with Ada.Unchecked_Conversion;
with System.Storage_Elements; use System.Storage_Elements;

package body RP2350_SVD.Atomic is

   function To_Register is
     new Ada.Unchecked_Conversion (UInt32, Register);

   function No_Bits return Register is (To_Register (0));

   XOR_Offset : constant := 16#1000#;
   Set_Offset : constant := 16#2000#;
   Clr_Offset : constant := 16#3000#;

   procedure Write_Alias
     (Reg    : aliased in out Register;
      Offset : Storage_Offset;
      Bits   : Register)
     with Inline
   is
      --  The alias has the register's type, so the store is the same
      --  single 32-bit write (Volatile_Full_Access) the type demands.
      Alias : Register
        with Import, Address => Reg'Address + Offset;
   begin
      Alias := Bits;
   end Write_Alias;

   procedure Set (Reg : aliased in out Register; Bits : Register) is
   begin
      Write_Alias (Reg, Set_Offset, Bits);
   end Set;

   procedure Clear (Reg : aliased in out Register; Bits : Register) is
   begin
      Write_Alias (Reg, Clr_Offset, Bits);
   end Clear;

   procedure Toggle (Reg : aliased in out Register; Bits : Register) is
   begin
      Write_Alias (Reg, XOR_Offset, Bits);
   end Toggle;
end RP2350_SVD.Atomic;
