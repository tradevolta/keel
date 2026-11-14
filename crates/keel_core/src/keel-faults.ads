--  SPDX-License-Identifier: Apache-2.0
--  Keel.Faults: the fault status registers as data. CFSR and HFSR
--  are bit sets; each bit is one cause. This package only decodes
--  words, so it runs on the host as well as on the chip.
with Interfaces; use Interfaces;

package Keel.Faults
  with Pure, SPARK_Mode
is
   subtype Word is Unsigned_32;

   --  Arm's Cortex-M33 Generic User Guide: CFSR is MMFSR, BFSR and
   --  UFSR, from bit 0; then HFSR. STKOF is Armv8-M only: on Armv7-M
   --  bit 20 is 0.
   type Cause is
     (IACCVIOL, DACCVIOL, MUNSTKERR, MSTKERR, MLSPERR, MMARVALID,
      IBUSERR, PRECISERR, IMPRECISERR, UNSTKERR, STKERR, LSPERR,
      BFARVALID,
      UNDEFINSTR, INVSTATE, INVPC, NOCP, STKOF, UNALIGNED, DIVBYZERO,
      VECTTBL, FORCED, DEBUGEVT);

   subtype CFSR_Cause is Cause range IACCVIOL .. DIVBYZERO;
   subtype HFSR_Cause is Cause range VECTTBL .. DEBUGEVT;

   --  The bit each cause occupies in its register
   function Bit (C : Cause) return Natural is
     (case C is
        when IACCVIOL => 0, when DACCVIOL => 1, when MUNSTKERR => 3,
        when MSTKERR => 4, when MLSPERR => 5, when MMARVALID => 7,
        when IBUSERR => 8, when PRECISERR => 9, when IMPRECISERR => 10,
        when UNSTKERR => 11, when STKERR => 12, when LSPERR => 13,
        when BFARVALID => 15,
        when UNDEFINSTR => 16, when INVSTATE => 17, when INVPC => 18,
        when NOCP => 19, when STKOF => 20, when UNALIGNED => 24,
        when DIVBYZERO => 25,
        when VECTTBL => 1, when FORCED => 30, when DEBUGEVT => 31)
     with Post => Bit'Result <= 31;

   --  Is cause C set in these register values?
   function Present (CFSR, HFSR : Word; C : Cause) return Boolean is
     (((if C in CFSR_Cause then CFSR else HFSR)
       and Shift_Left (1, Bit (C))) /= 0);

   --  One line of plain English per cause
   function Meaning (C : Cause) return String is
     (case C is
        when IACCVIOL => "instruction fetch from a protected region",
        when DACCVIOL => "data access to a protected region",
        when MUNSTKERR => "MPU fault while unstacking",
        when MSTKERR => "MPU fault while stacking",
        when MLSPERR => "MPU fault in lazy FP state save",
        when MMARVALID => "MMFAR holds the address",
        when IBUSERR => "bus error on an instruction fetch",
        when PRECISERR => "precise bus error on a data access",
        when IMPRECISERR => "imprecise bus error on a data access",
        when UNSTKERR => "bus fault while unstacking",
        when STKERR => "bus fault while stacking",
        when LSPERR => "bus fault in lazy FP state save",
        when BFARVALID => "BFAR holds the address",
        when UNDEFINSTR => "undefined instruction",
        when INVSTATE => "branch to an address with bit 0 clear",
        when INVPC => "bad EXC_RETURN or PC on return",
        when NOCP => "coprocessor off or absent",
        when STKOF => "stack limit crossed",
        when UNALIGNED => "unaligned access",
        when DIVBYZERO => "integer divide by zero",
        when VECTTBL => "bus fault reading the vector table",
        when FORCED => "a configurable fault escalated",
        when DEBUGEVT => "debug event");

   --  What the processor pushed on exception entry, lowest address
   --  first: the basic frame, without floating-point registers
   type Stacked_Frame is record
      R0, R1, R2, R3, R12, LR, PC, xPSR : Word;
   end record;
end Keel.Faults;
