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
