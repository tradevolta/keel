--  SPDX-License-Identifier: Apache-2.0
with System.Storage_Elements; use System.Storage_Elements;

package body RP2350_SVD.POWMAN_Words is

   Set_Alias   : constant := 16#2000#;
   Clear_Alias : constant := 16#3000#;

   procedure Store (Address : System.Address; Value : UInt32)
     with Inline
   is
      R : UInt32
        with Import, Volatile, Address => Address;
   begin
      R := Value;
   end Store;

   function Key (Reg : Offset) return UInt32 is
     (if Reg in Protected_Offset then Password else 0);

   function Read (Reg : Offset) return UInt32 is
      R : constant UInt32
        with Import, Volatile,
             Address => POWMAN_Base + Storage_Offset (Reg);
   begin
      return R;
   end Read;

   procedure Write (Reg : Offset; Value : UInt32) is
   begin
      Store (POWMAN_Base + Storage_Offset (Reg), Key (Reg) or Value);
   end Write;

   procedure Set_Bits (Reg : Offset; Bits : UInt32) is
   begin
      Store (POWMAN_Base + Storage_Offset (Reg) + Set_Alias,
             Key (Reg) or Bits);
   end Set_Bits;

   procedure Clear_Bits (Reg : Offset; Bits : UInt32) is
   begin
      Store (POWMAN_Base + Storage_Offset (Reg) + Clear_Alias,
             Key (Reg) or Bits);
   end Clear_Bits;
end RP2350_SVD.POWMAN_Words;
