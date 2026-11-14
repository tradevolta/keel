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
