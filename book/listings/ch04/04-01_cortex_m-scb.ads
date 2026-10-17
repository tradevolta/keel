--  CPACR: who may use each coprocessor. CP10 and CP11 are the FPU.
type Access_Right is (Denied, Privileged, Reserved, Full)
  with Size => 2;
type Coprocessor_Rights is array (0 .. 7) of Access_Right
  with Component_Size => 2, Size => 16;

type CPACR_Register is record
   CP : Coprocessor_Rights;
   CP10 : Access_Right;
   CP11 : Access_Right;
end record
  with Volatile_Full_Access, Size => 32;

for CPACR_Register use record
   CP at 0 range 0 .. 15;
   CP10 at 0 range 20 .. 21;
   CP11 at 0 range 22 .. 23;
end record;

--  The System Control Block from 0xE000_ED00, with gaps.
type SCB_Registers is record
   VTOR : System.Address with Atomic;
   CFSR : Word with Atomic;
   HFSR : Word with Atomic;
   MMFAR : Word with Atomic;
   BFAR : Word with Atomic;
   CPACR : CPACR_Register;
end record;

for SCB_Registers use record
   VTOR at 16#08# range 0 .. 31;
   CFSR at 16#28# range 0 .. 31;
   HFSR at 16#2C# range 0 .. 31;
   MMFAR at 16#34# range 0 .. 31;
   BFAR at 16#38# range 0 .. 31;
   CPACR at 16#88# range 0 .. 31;
end record;

SCB : SCB_Registers
  with Import, Address => System'To_Address (16#E000_ED00#);
