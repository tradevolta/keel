type GPIO15_CTRL_Register is record
   --  0-31 -> selects pin function according to the gpio table 31 ==
   --  NULL
   FUNCSEL        : GPIO15_CTRL_FUNCSEL_Field :=
                     RP2350_SVD.IO_BANK0.null_k;
   --  unspecified
   Reserved_5_11  : RP2350_SVD.UInt7 := 16#0#;
   OUTOVER        : GPIO15_CTRL_OUTOVER_Field :=
                     RP2350_SVD.IO_BANK0.NORMAL;
   OEOVER         : GPIO15_CTRL_OEOVER_Field :=
                     RP2350_SVD.IO_BANK0.NORMAL;
   INOVER         : GPIO15_CTRL_INOVER_Field :=
                     RP2350_SVD.IO_BANK0.NORMAL;
   --  unspecified
   Reserved_18_27 : RP2350_SVD.UInt10 := 16#0#;
   IRQOVER        : GPIO15_CTRL_IRQOVER_Field :=
                     RP2350_SVD.IO_BANK0.NORMAL;
   --  unspecified
   Reserved_30_31 : RP2350_SVD.UInt2 := 16#0#;
end record
  with Volatile_Full_Access, Object_Size => 32,
       Bit_Order => System.Low_Order_First;

for GPIO15_CTRL_Register use record
   FUNCSEL        at 0 range 0 .. 4;
   Reserved_5_11  at 0 range 5 .. 11;
   OUTOVER        at 0 range 12 .. 13;
   OEOVER         at 0 range 14 .. 15;
   INOVER         at 0 range 16 .. 17;
   Reserved_18_27 at 0 range 18 .. 27;
   IRQOVER        at 0 range 28 .. 29;
   Reserved_30_31 at 0 range 30 .. 31;
end record;
