--  SPDX-License-Identifier: Apache-2.0
--  Hand-written (not generated): POWMAN's registers as words, with
--  the password. A write to any register at offset 0x00 to 0xAC is
--  ignored unless its top 16 bits hold 0x5AFE (RP2350 datasheet,
--  6.4), so these registers have no writable fields there, and a
--  read never returns the password. The generated records in
--  RP2350_SVD.POWMAN have no field for it: write through this
--  package, read through either.
package RP2350_SVD.POWMAN_Words
  with Preelaborate
is
   --  A register's byte offset from POWMAN_Base
   type Offset is range 0 .. 16#EC#
     with Static_Predicate =>
       Offset in 16#00# | 16#04# | 16#08# | 16#0C# | 16#10# | 16#14#
                | 16#18# | 16#1C# | 16#20# | 16#24# | 16#28# | 16#2C#
                | 16#30# | 16#34# | 16#38# | 16#3C# | 16#40# | 16#44#
                | 16#48# | 16#4C# | 16#50# | 16#54# | 16#58# | 16#5C#
                | 16#60# | 16#64# | 16#68# | 16#6C# | 16#70# | 16#74#
                | 16#78# | 16#7C# | 16#80# | 16#84# | 16#88# | 16#8C#
                | 16#90# | 16#94# | 16#98# | 16#9C# | 16#A0# | 16#A4#
                | 16#A8# | 16#AC# | 16#B0# | 16#B4# | 16#B8# | 16#BC#
                | 16#C0# | 16#C4# | 16#C8# | 16#CC# | 16#D0# | 16#D4#
                | 16#D8# | 16#DC# | 16#E0# | 16#E4# | 16#E8# | 16#EC#;

   subtype Protected_Offset is Offset range 16#00# .. 16#AC#;

   Password : constant UInt32 := 16#5AFE_0000#;

   --  The offsets Keel uses (Table 509)
   VREG_CTRL         : constant Offset := 16#04#;
   CHIP_RESET        : constant Offset := 16#2C#;
   SEQ_CFG           : constant Offset := 16#34#;
   STATE             : constant Offset := 16#38#;
   SET_TIME_63TO48   : constant Offset := 16#60#;
   SET_TIME_47TO32   : constant Offset := 16#64#;
   SET_TIME_31TO16   : constant Offset := 16#68#;
   SET_TIME_15TO0    : constant Offset := 16#6C#;
   READ_TIME_UPPER   : constant Offset := 16#70#;
   READ_TIME_LOWER   : constant Offset := 16#74#;
   ALARM_TIME_63TO48 : constant Offset := 16#78#;
   ALARM_TIME_47TO32 : constant Offset := 16#7C#;
   ALARM_TIME_31TO16 : constant Offset := 16#80#;
   ALARM_TIME_15TO0  : constant Offset := 16#84#;
   TIMER             : constant Offset := 16#88#;
   PWRUP0            : constant Offset := 16#8C#;
   LAST_SWCORE_PWRUP : constant Offset := 16#A0#;
   DBG_PWRCFG        : constant Offset := 16#A4#;
   SCRATCH0          : constant Offset := 16#B0#;
   BOOT0             : constant Offset := 16#D0#;
   INTR              : constant Offset := 16#E0#;
   INTE              : constant Offset := 16#E4#;

   function Read (Reg : Offset) return UInt32
     with Inline;

   --  Write Value, with the password if Reg is protected
   procedure Write (Reg : Offset; Value : UInt32)
     with Inline,
          Pre => (if Reg in Protected_Offset then Value < 2**16);

   --  Set or clear the bits that are 1 in Bits, through the atomic
   --  aliases, with the password if Reg is protected (the Pico SDK's
   --  powman_set_bits and powman_clear_bits do the same)
   procedure Set_Bits (Reg : Offset; Bits : UInt32)
     with Inline,
          Pre => (if Reg in Protected_Offset then Bits < 2**16);
   procedure Clear_Bits (Reg : Offset; Bits : UInt32)
     with Inline,
          Pre => (if Reg in Protected_Offset then Bits < 2**16);
end RP2350_SVD.POWMAN_Words;
