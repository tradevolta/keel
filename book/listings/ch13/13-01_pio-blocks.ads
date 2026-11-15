type Machine is range 0 .. 3;
type Slot is range 0 .. 31;

type Machine_Registers is record
   CLKDIV    : SM0_CLKDIV_Register;
   EXECCTRL  : SM0_EXECCTRL_Register;
   SHIFTCTRL : SM0_SHIFTCTRL_Register;
   ADDR      : SM0_ADDR_Register;
   --  Write to run one instruction now (11.5.7)
   INSTR     : SM0_INSTR_Register;
   PINCTRL   : SM0_PINCTRL_Register;
end record
  with Volatile, Size => 16#18# * 8;

for Machine_Registers use record
   CLKDIV    at 16#00# range 0 .. 31;
   EXECCTRL  at 16#04# range 0 .. 31;
   SHIFTCTRL at 16#08# range 0 .. 31;
   ADDR      at 16#0C# range 0 .. 31;
   INSTR     at 16#10# range 0 .. 31;
   PINCTRL   at 16#14# range 0 .. 31;
end record;

type Machine_Array is array (Machine) of Machine_Registers;
--  The FIFOs: each read or written whole, 32 bits at a time
type FIFO_Array is array (Machine) of UInt32
  with Volatile_Components;
--  Write-only
type Memory_Array is array (Slot) of INSTR_MEM0_Register;

type Block_Registers is record
   CTRL      : aliased CTRL_Register;
   FSTAT     : FSTAT_Register;
   FDEBUG    : FDEBUG_Register;
   FLEVEL    : FLEVEL_Register;
   TXF       : FIFO_Array;
   RXF       : FIFO_Array;
   INSTR_MEM : Memory_Array;
   SM        : Machine_Array;
end record
  with Volatile;

for Block_Registers use record
   CTRL      at 16#00# range 0 .. 31;
   FSTAT     at 16#04# range 0 .. 31;
   FDEBUG    at 16#08# range 0 .. 31;
   FLEVEL    at 16#0C# range 0 .. 31;
   TXF       at 16#10# range 0 .. 4 * 32 - 1;
   RXF       at 16#20# range 0 .. 4 * 32 - 1;
   INSTR_MEM at 16#48# range 0 .. 32 * 32 - 1;
   SM        at 16#C8# range 0 .. 4 * 16#18# * 8 - 1;
end record;
