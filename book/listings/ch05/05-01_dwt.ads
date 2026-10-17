--  The DWT cycle counter counts core clock cycles once both
--  DEMCR.TRCENA and DWT_CTRL.CYCCNTENA are set.
type DEMCR_Register is record
   TRCENA : Boolean;
end record
  with Volatile_Full_Access, Size => 32;

for DEMCR_Register use record
   TRCENA at 0 range 24 .. 24;
end record;

type DWT_Ctrl_Register is record
   CYCCNTENA : Boolean;
end record
  with Volatile_Full_Access, Size => 32;

for DWT_Ctrl_Register use record
   CYCCNTENA at 0 range 0 .. 0;
end record;

DEMCR : DEMCR_Register
  with Import, Address => System'To_Address (16#E000_EDFC#);
DWT_Ctrl : DWT_Ctrl_Register
  with Import, Address => System'To_Address (16#E000_1000#);
DWT_CYCCNT : Word
  with Import, Atomic, Address => System'To_Address (16#E000_1004#);
