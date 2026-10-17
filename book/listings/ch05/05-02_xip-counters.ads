--  XIP_CTRL CTR_HIT and CTR_ACC: they saturate, and any write
--  clears them.
XIP_Hits : Interfaces.Unsigned_32
  with Import, Atomic,
       Address => System'To_Address (16#400C_800C#);
XIP_Accesses : Interfaces.Unsigned_32
  with Import, Atomic,
       Address => System'To_Address (16#400C_8010#);
