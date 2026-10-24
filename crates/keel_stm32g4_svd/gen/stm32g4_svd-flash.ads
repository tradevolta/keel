pragma Style_Checks (Off);

--  This spec has been automatically generated from STM32G474.svd

pragma Restrictions (No_Elaboration_Code);

with System;

package STM32G4_SVD.Flash is
   pragma Preelaborate;

   ---------------
   -- Registers --
   ---------------

   --  Latency 	
   type FLASH_ACR_LATENCY_Field is
     (--  Zero wait state
      B_0x0,
      --  One wait state
      B_0x1,
      --  Two wait states
      B_0x2,
      --  Three wait states
      B_0x3,
      --  Four wait states
      B_0x4)
     with Size => 4;
   for FLASH_ACR_LATENCY_Field use
     (B_0x0 => 0,
      B_0x1 => 1,
      B_0x2 => 2,
      B_0x3 => 3,
      B_0x4 => 4);

   --  Prefetch enable
   type FLASH_ACR_PRFTEN_Field is
     (--  Prefetch disabled
      B_0x0,
      --  Prefetch enabled
      B_0x1)
     with Size => 1;
   for FLASH_ACR_PRFTEN_Field use
     (B_0x0 => 0,
      B_0x1 => 1);

   --  Instruction cache enable
   type FLASH_ACR_ICEN_Field is
     (--  Instruction cache is disabled
      B_0x0,
      --  Instruction cache is enabled
      B_0x1)
     with Size => 1;
   for FLASH_ACR_ICEN_Field use
     (B_0x0 => 0,
      B_0x1 => 1);

   --  Data cache enable
   type FLASH_ACR_DCEN_Field is
     (--  Data cache is disabled
      B_0x0,
      --  Data cache is enabled
      B_0x1)
     with Size => 1;
   for FLASH_ACR_DCEN_Field use
     (B_0x0 => 0,
      B_0x1 => 1);

   --  Instruction cache reset 	
   type FLASH_ACR_ICRST_Field is
     (--  Instruction cache is not reset
      B_0x0,
      --  Instruction cache is reset
      B_0x1)
     with Size => 1;
   for FLASH_ACR_ICRST_Field use
     (B_0x0 => 0,
      B_0x1 => 1);

   --  Data cache reset 	
   type FLASH_ACR_DCRST_Field is
     (--  Data cache is not reset
      B_0x0,
      --  Data cache is reset
      B_0x1)
     with Size => 1;
   for FLASH_ACR_DCRST_Field use
     (B_0x0 => 0,
      B_0x1 => 1);

   --  Flash Power-down mode during Run or Low-power run mode 	
   type FLASH_ACR_RUN_PD_Field is
     (--  Flash in Idle mode
      B_0x0,
      --  Flash in Power-down mode
      B_0x1)
     with Size => 1;
   for FLASH_ACR_RUN_PD_Field use
     (B_0x0 => 0,
      B_0x1 => 1);

   --  Flash Power-down mode during Sleep or Low-power sleep mode 	
   type FLASH_ACR_SLEEP_PD_Field is
     (--  Flash in Idle mode during Sleep and Low-power sleep modes
      B_0x0,
      --  Flash in Power-down mode during Sleep and Low-power sleep modes
      B_0x1)
     with Size => 1;
   for FLASH_ACR_SLEEP_PD_Field use
     (B_0x0 => 0,
      B_0x1 => 1);

   --  Debug software enable 	
   type FLASH_ACR_DBG_SWEN_Field is
     (--  Debugger disabled
      B_0x0,
      --  Debugger enabled
      B_0x1)
     with Size => 1;
   for FLASH_ACR_DBG_SWEN_Field use
     (B_0x0 => 0,
      B_0x1 => 1);

   --  Flash access control register
   type FLASH_ACR_Register is record
      --  Latency 	
      LATENCY        : FLASH_ACR_LATENCY_Field := STM32G4_SVD.Flash.B_0x1;
      --  unspecified
      Reserved_4_7   : STM32G4_SVD.UInt4 := 16#0#;
      --  Prefetch enable
      PRFTEN         : FLASH_ACR_PRFTEN_Field := STM32G4_SVD.Flash.B_0x0;
      --  Instruction cache enable
      ICEN           : FLASH_ACR_ICEN_Field := STM32G4_SVD.Flash.B_0x1;
      --  Data cache enable
      DCEN           : FLASH_ACR_DCEN_Field := STM32G4_SVD.Flash.B_0x1;
      --  Instruction cache reset 	
      ICRST          : FLASH_ACR_ICRST_Field := STM32G4_SVD.Flash.B_0x0;
      --  Data cache reset 	
      DCRST          : FLASH_ACR_DCRST_Field := STM32G4_SVD.Flash.B_0x0;
      --  Flash Power-down mode during Run or Low-power run mode 	
      RUN_PD         : FLASH_ACR_RUN_PD_Field := STM32G4_SVD.Flash.B_0x0;
      --  Flash Power-down mode during Sleep or Low-power sleep mode 	
      SLEEP_PD       : FLASH_ACR_SLEEP_PD_Field := STM32G4_SVD.Flash.B_0x0;
      --  unspecified
      Reserved_15_17 : STM32G4_SVD.UInt3 := 16#0#;
      --  Debug software enable 	
      DBG_SWEN       : FLASH_ACR_DBG_SWEN_Field := STM32G4_SVD.Flash.B_0x1;
      --  unspecified
      Reserved_19_31 : STM32G4_SVD.UInt13 := 16#0#;
   end record
     with Volatile_Full_Access, Object_Size => 32,
          Bit_Order => System.Low_Order_First;

   for FLASH_ACR_Register use record
      LATENCY        at 0 range 0 .. 3;
      Reserved_4_7   at 0 range 4 .. 7;
      PRFTEN         at 0 range 8 .. 8;
      ICEN           at 0 range 9 .. 9;
      DCEN           at 0 range 10 .. 10;
      ICRST          at 0 range 11 .. 11;
      DCRST          at 0 range 12 .. 12;
      RUN_PD         at 0 range 13 .. 13;
      SLEEP_PD       at 0 range 14 .. 14;
      Reserved_15_17 at 0 range 15 .. 17;
      DBG_SWEN       at 0 range 18 .. 18;
      Reserved_19_31 at 0 range 19 .. 31;
   end record;

   --  Flash status register
   type FLASH_SR_Register is record
      --  End of operation 	
      EOP            : Boolean := False;
      --  Operation error 	
      OPERR          : Boolean := False;
      --  unspecified
      Reserved_2_2   : STM32G4_SVD.Bit := 16#0#;
      --  Programming error 	
      PROGERR        : Boolean := False;
      --  Write protection error 	
      WRPERR         : Boolean := False;
      --  Programming alignment error 	
      PGAERR         : Boolean := False;
      --  Size error 	
      SIZERR         : Boolean := False;
      --  Programming sequence error 	
      PGSERR         : Boolean := False;
      --  Fast programming data miss error 	
      MISSERR        : Boolean := False;
      --  Fast programming error 	
      FASTERR        : Boolean := False;
      --  unspecified
      Reserved_10_13 : STM32G4_SVD.UInt4 := 16#0#;
      --  PCROP read error 	
      RDERR          : Boolean := False;
      --  Option validity error 	
      OPTVERR        : Boolean := False;
      --  Read-only. Busy 	
      BSY            : Boolean := False;
      --  unspecified
      Reserved_17_31 : STM32G4_SVD.UInt15 := 16#0#;
   end record
     with Volatile_Full_Access, Object_Size => 32,
          Bit_Order => System.Low_Order_First;

   for FLASH_SR_Register use record
      EOP            at 0 range 0 .. 0;
      OPERR          at 0 range 1 .. 1;
      Reserved_2_2   at 0 range 2 .. 2;
      PROGERR        at 0 range 3 .. 3;
      WRPERR         at 0 range 4 .. 4;
      PGAERR         at 0 range 5 .. 5;
      SIZERR         at 0 range 6 .. 6;
      PGSERR         at 0 range 7 .. 7;
      MISSERR        at 0 range 8 .. 8;
      FASTERR        at 0 range 9 .. 9;
      Reserved_10_13 at 0 range 10 .. 13;
      RDERR          at 0 range 14 .. 14;
      OPTVERR        at 0 range 15 .. 15;
      BSY            at 0 range 16 .. 16;
      Reserved_17_31 at 0 range 17 .. 31;
   end record;

   --  Programming
   type FLASH_CR_PG_Field is
     (--  Flash programming disabled
      B_0x0,
      --  Flash programming enabled
      B_0x1)
     with Size => 1;
   for FLASH_CR_PG_Field use
     (B_0x0 => 0,
      B_0x1 => 1);

   --  Page erase
   type FLASH_CR_PER_Field is
     (--  page erase disabled
      B_0x0,
      --  page erase enabled
      B_0x1)
     with Size => 1;
   for FLASH_CR_PER_Field use
     (B_0x0 => 0,
      B_0x1 => 1);

   --  Page number selection 	
   type FLASH_CR_PNB_Field is
     (--  page 0
      B_0x0,
      --  page 1
      B_0x1)
     with Size => 7;
   for FLASH_CR_PNB_Field use
     (B_0x0 => 0,
      B_0x1 => 1);

   --  Bank erase 	
   type FLASH_CR_BKER_Field is
     (--  Bank 1 is selected for page erase
      B_0x0,
      --  Bank 2 is selected for page erase
      B_0x1)
     with Size => 1;
   for FLASH_CR_BKER_Field use
     (B_0x0 => 0,
      B_0x1 => 1);

   --  Fast programming
   type FLASH_CR_FSTPG_Field is
     (--  Fast programming disabled
      B_0x0,
      --  Fast programming enabled
      B_0x1)
     with Size => 1;
   for FLASH_CR_FSTPG_Field use
     (B_0x0 => 0,
      B_0x1 => 1);

   --  End of operation interrupt enable 	
   type FLASH_CR_EOPIE_Field is
     (--  EOP Interrupt disabled
      B_0x0,
      --  EOP Interrupt enabled
      B_0x1)
     with Size => 1;
   for FLASH_CR_EOPIE_Field use
     (B_0x0 => 0,
      B_0x1 => 1);

   --  Error interrupt enable 	
   type FLASH_CR_ERRIE_Field is
     (--  OPERR error interrupt disabled
      B_0x0,
      --  OPERR error interrupt enabled
      B_0x1)
     with Size => 1;
   for FLASH_CR_ERRIE_Field use
     (B_0x0 => 0,
      B_0x1 => 1);

   --  PCROP read error interrupt enable 	
   type FLASH_CR_RDERRIE_Field is
     (--  PCROP read error interrupt disabled
      B_0x0,
      --  PCROP read error interrupt enabled
      B_0x1)
     with Size => 1;
   for FLASH_CR_RDERRIE_Field use
     (B_0x0 => 0,
      B_0x1 => 1);

   --  Force the option byte loading 	
   type FLASH_CR_OBL_LAUNCH_Field is
     (--  Option byte loading complete
      B_0x0,
      --  Option byte loading requested
      B_0x1)
     with Size => 1;
   for FLASH_CR_OBL_LAUNCH_Field use
     (B_0x0 => 0,
      B_0x1 => 1);

   --  FLASH_CR_SEC_PROT array
   type FLASH_CR_SEC_PROT_Field_Array is array (1 .. 2) of Boolean
     with Component_Size => 1, Size => 2;

   --  Type definition for FLASH_CR_SEC_PROT
   type FLASH_CR_SEC_PROT_Field
     (As_Array : Boolean := False)
   is record
      case As_Array is
         when False =>
            --  SEC_PROT as a value
            Val : STM32G4_SVD.UInt2;
         when True =>
            --  SEC_PROT as an array
            Arr : FLASH_CR_SEC_PROT_Field_Array;
      end case;
   end record
     with Unchecked_Union, Size => 2;

   for FLASH_CR_SEC_PROT_Field use record
      Val at 0 range 0 .. 1;
      Arr at 0 range 0 .. 1;
   end record;

   --  Flash control register
   type FLASH_CR_Register is record
      --  Programming
      PG             : FLASH_CR_PG_Field := STM32G4_SVD.Flash.B_0x0;
      --  Page erase
      PER            : FLASH_CR_PER_Field := STM32G4_SVD.Flash.B_0x0;
      --  Bank 1 Mass erase 	
      MER1           : Boolean := False;
      --  Page number selection 	
      PNB            : FLASH_CR_PNB_Field := STM32G4_SVD.Flash.B_0x0;
      --  unspecified
      Reserved_10_10 : STM32G4_SVD.Bit := 16#0#;
      --  Bank erase 	
      BKER           : FLASH_CR_BKER_Field := STM32G4_SVD.Flash.B_0x0;
      --  unspecified
      Reserved_12_14 : STM32G4_SVD.UInt3 := 16#0#;
      --  Bank 2 Mass erase 	
      MER2           : Boolean := False;
      --  Start 	
      START          : Boolean := False;
      --  Options modification start 	
      OPTSTRT        : Boolean := False;
      --  Fast programming
      FSTPG          : FLASH_CR_FSTPG_Field := STM32G4_SVD.Flash.B_0x0;
      --  unspecified
      Reserved_19_23 : STM32G4_SVD.UInt5 := 16#0#;
      --  End of operation interrupt enable 	
      EOPIE          : FLASH_CR_EOPIE_Field := STM32G4_SVD.Flash.B_0x0;
      --  Error interrupt enable 	
      ERRIE          : FLASH_CR_ERRIE_Field := STM32G4_SVD.Flash.B_0x0;
      --  PCROP read error interrupt enable 	
      RDERRIE        : FLASH_CR_RDERRIE_Field := STM32G4_SVD.Flash.B_0x0;
      --  Force the option byte loading 	
      OBL_LAUNCH     : FLASH_CR_OBL_LAUNCH_Field := STM32G4_SVD.Flash.B_0x0;
      --  Securable memory area protection bit for bank 1. 	
      SEC_PROT       : FLASH_CR_SEC_PROT_Field :=
                        (As_Array => False, Val => 16#0#);
      --  Options Lock 	
      OPTLOCK        : Boolean := True;
      --  FLASH_CR Lock 	
      LOCK           : Boolean := True;
   end record
     with Volatile_Full_Access, Object_Size => 32,
          Bit_Order => System.Low_Order_First;

   for FLASH_CR_Register use record
      PG             at 0 range 0 .. 0;
      PER            at 0 range 1 .. 1;
      MER1           at 0 range 2 .. 2;
      PNB            at 0 range 3 .. 9;
      Reserved_10_10 at 0 range 10 .. 10;
      BKER           at 0 range 11 .. 11;
      Reserved_12_14 at 0 range 12 .. 14;
      MER2           at 0 range 15 .. 15;
      START          at 0 range 16 .. 16;
      OPTSTRT        at 0 range 17 .. 17;
      FSTPG          at 0 range 18 .. 18;
      Reserved_19_23 at 0 range 19 .. 23;
      EOPIE          at 0 range 24 .. 24;
      ERRIE          at 0 range 25 .. 25;
      RDERRIE        at 0 range 26 .. 26;
      OBL_LAUNCH     at 0 range 27 .. 27;
      SEC_PROT       at 0 range 28 .. 29;
      OPTLOCK        at 0 range 30 .. 30;
      LOCK           at 0 range 31 .. 31;
   end record;

   subtype FLASH_ECCR_ADDR_ECC_Field is STM32G4_SVD.UInt19;

   --  ECC fail bank 	
   type FLASH_ECCR_BK_ECC_Field is
     (--  bank 1
      B_0x0,
      --  bank 2
      B_0x1)
     with Size => 1;
   for FLASH_ECCR_BK_ECC_Field use
     (B_0x0 => 0,
      B_0x1 => 1);

   --  ECC correction interrupt enable 	
   type FLASH_ECCR_ECCCIE_Field is
     (--  ECCC interrupt disabled
      B_0x0,
      --  ECCC interrupt enabled.
      B_0x1)
     with Size => 1;
   for FLASH_ECCR_ECCCIE_Field use
     (B_0x0 => 0,
      B_0x1 => 1);

   --  Flash ECC register
   type FLASH_ECCR_Register is record
      --  Read-only. ECC fail address 	
      ADDR_ECC       : FLASH_ECCR_ADDR_ECC_Field := 16#0#;
      --  unspecified
      Reserved_19_20 : STM32G4_SVD.UInt2 := 16#0#;
      --  Read-only. ECC fail bank 	
      BK_ECC         : FLASH_ECCR_BK_ECC_Field := STM32G4_SVD.Flash.B_0x0;
      --  Read-only. System Flash ECC fail 	
      SYSF_ECC       : Boolean := False;
      --  unspecified
      Reserved_23_23 : STM32G4_SVD.Bit := 16#0#;
      --  ECC correction interrupt enable 	
      ECCCIE         : FLASH_ECCR_ECCCIE_Field := STM32G4_SVD.Flash.B_0x0;
      --  unspecified
      Reserved_25_27 : STM32G4_SVD.UInt3 := 16#0#;
      --  ECC correction 	
      ECCC2          : Boolean := False;
      --  ECC2 detection 	
      ECCD2          : Boolean := False;
      --  ECC correction 	
      ECCC           : Boolean := False;
      --  ECC detection 	
      ECCD           : Boolean := False;
   end record
     with Volatile_Full_Access, Object_Size => 32,
          Bit_Order => System.Low_Order_First;

   for FLASH_ECCR_Register use record
      ADDR_ECC       at 0 range 0 .. 18;
      Reserved_19_20 at 0 range 19 .. 20;
      BK_ECC         at 0 range 21 .. 21;
      SYSF_ECC       at 0 range 22 .. 22;
      Reserved_23_23 at 0 range 23 .. 23;
      ECCCIE         at 0 range 24 .. 24;
      Reserved_25_27 at 0 range 25 .. 27;
      ECCC2          at 0 range 28 .. 28;
      ECCD2          at 0 range 29 .. 29;
      ECCC           at 0 range 30 .. 30;
      ECCD           at 0 range 31 .. 31;
   end record;

   --  Read protection level 	
   type FLASH_OPTR_RDP_Field is
     (--  Reset value for the field
      FLASH_OPTR_RDP_Field_Reset,
      --  Level 0, read protection not active
      B_0xAA,
      --  Level 2, chip read protection active
      B_0xCC)
     with Size => 8;
   for FLASH_OPTR_RDP_Field use
     (FLASH_OPTR_RDP_Field_Reset => 0,
      B_0xAA => 170,
      B_0xCC => 204);

   --  BOR reset Level 	
   type FLASH_OPTR_BOR_LEV_Field is
     (--  BOR Level 0. Reset level threshold is around 1.7 V
      B_0x0,
      --  BOR Level 1. Reset level threshold is around 2.0 V
      B_0x1,
      --  BOR Level 2. Reset level threshold is around 2.2 V
      B_0x2,
      --  BOR Level 3. Reset level threshold is around 2.5 V
      B_0x3,
      --  BOR Level 4. Reset level threshold is around 2.8 V
      B_0x4)
     with Size => 3;
   for FLASH_OPTR_BOR_LEV_Field use
     (B_0x0 => 0,
      B_0x1 => 1,
      B_0x2 => 2,
      B_0x3 => 3,
      B_0x4 => 4);

   --  Independent watchdog selection
   type FLASH_OPTR_IWDG_SW_Field is
     (--  Hardware independent watchdog
      B_0x0,
      --  Software independent watchdog
      B_0x1)
     with Size => 1;
   for FLASH_OPTR_IWDG_SW_Field use
     (B_0x0 => 0,
      B_0x1 => 1);

   --  Window watchdog selection
   type FLASH_OPTR_WWDG_SW_Field is
     (--  Hardware window watchdog
      B_0x0,
      --  Software window watchdog
      B_0x1)
     with Size => 1;
   for FLASH_OPTR_WWDG_SW_Field use
     (B_0x0 => 0,
      B_0x1 => 1);

   --  Dual-bank boot
   type FLASH_OPTR_BFB2_Field is
     (--  Dual-bank boot disable
      B_0x0,
      --  Dual-bank boot enable
      B_0x1)
     with Size => 1;
   for FLASH_OPTR_BFB2_Field use
     (B_0x0 => 0,
      B_0x1 => 1);

   --  This bit can only be written when PCROPA/B is disabled.
   type FLASH_OPTR_DBANK_Field is
     (--  Single bank mode with 128 bits data read width
      B_0x0,
      --  Dual bank mode with 64 bits data
      B_0x1)
     with Size => 1;
   for FLASH_OPTR_DBANK_Field use
     (B_0x0 => 0,
      B_0x1 => 1);

   --  SRAM1 and CCM SRAM parity check enable
   type FLASH_OPTR_SRAM_PE_Field is
     (--  SRAM1 and CCM SRAM parity check enable
      B_0x0,
      --  SRAM1 and CCM SRAM parity check disable
      B_0x1)
     with Size => 1;
   for FLASH_OPTR_SRAM_PE_Field use
     (B_0x0 => 0,
      B_0x1 => 1);

   --  Software BOOT0
   type FLASH_OPTR_nSWBOOT0_Field is
     (--  BOOT0 taken from the option bit nBOOT0
      B_0x0,
      --  BOOT0 taken from PB8/BOOT0 pin
      B_0x1)
     with Size => 1;
   for FLASH_OPTR_nSWBOOT0_Field use
     (B_0x0 => 0,
      B_0x1 => 1);

   --  nBOOT0 option bit
   type FLASH_OPTR_nBOOT0_Field is
     (--  nBOOT0 = 0
      B_0x0,
      --  nBOOT0 = 1
      B_0x1)
     with Size => 1;
   for FLASH_OPTR_nBOOT0_Field use
     (B_0x0 => 0,
      B_0x1 => 1);

   --  None
   type FLASH_OPTR_NRST_MODE_Field is
     (--  Reset value for the field
      FLASH_OPTR_NRST_MODE_Field_Reset,
      --  Reset Input only: a low level on the NRST pin generates system reset,
--  internal RESET not propagated to the NSRT pin
      B_0x1,
      --  GPIO: standard GPIO pad functionality, only internal RESET possible
      B_0x2,
      --  Bidirectional reset: NRST pin configured in reset input/output mode (legacy
--  mode)
      B_0x3)
     with Size => 2;
   for FLASH_OPTR_NRST_MODE_Field use
     (FLASH_OPTR_NRST_MODE_Field_Reset => 0,
      B_0x1 => 1,
      B_0x2 => 2,
      B_0x3 => 3);

   --  Internal reset holder enable bit
   type FLASH_OPTR_IRHEN_Field is
     (--  Internal resets are propagated as simple pulse on NRST pin
      B_0x0,
      --  Internal resets drives NRST pin low until it is seen as low level
      B_0x1)
     with Size => 1;
   for FLASH_OPTR_IRHEN_Field use
     (B_0x0 => 0,
      B_0x1 => 1);

   type FLASH_OPTR_Register is record
      --  Read protection level 	
      RDP            : FLASH_OPTR_RDP_Field := FLASH_OPTR_RDP_Field_Reset;
      --  BOR reset Level 	
      BOR_LEV        : FLASH_OPTR_BOR_LEV_Field := STM32G4_SVD.Flash.B_0x0;
      --  unspecified
      Reserved_11_11 : STM32G4_SVD.Bit := 16#0#;
      --  None
      nRST_STOP      : Boolean := False;
      --  None
      nRST_STDBY     : Boolean := False;
      --  None
      nRST_SHDW      : Boolean := False;
      --  unspecified
      Reserved_15_15 : STM32G4_SVD.Bit := 16#0#;
      --  Independent watchdog selection
      IWDG_SW        : FLASH_OPTR_IWDG_SW_Field := STM32G4_SVD.Flash.B_0x0;
      --  None
      IWDG_STOP      : Boolean := False;
      --  None
      IWGD_STDBY     : Boolean := False;
      --  Window watchdog selection
      WWDG_SW        : FLASH_OPTR_WWDG_SW_Field := STM32G4_SVD.Flash.B_0x0;
      --  Dual-bank boot
      BFB2           : FLASH_OPTR_BFB2_Field := STM32G4_SVD.Flash.B_0x0;
      --  unspecified
      Reserved_21_21 : STM32G4_SVD.Bit := 16#0#;
      --  This bit can only be written when PCROPA/B is disabled.
      DBANK          : FLASH_OPTR_DBANK_Field := STM32G4_SVD.Flash.B_0x0;
      --  Boot configuration 	
      nBOOT1         : Boolean := False;
      --  SRAM1 and CCM SRAM parity check enable
      SRAM_PE        : FLASH_OPTR_SRAM_PE_Field := STM32G4_SVD.Flash.B_0x0;
      --  None
      CCMSRAM_RST    : Boolean := False;
      --  Software BOOT0
      nSWBOOT0       : FLASH_OPTR_nSWBOOT0_Field := STM32G4_SVD.Flash.B_0x0;
      --  nBOOT0 option bit
      nBOOT0         : FLASH_OPTR_nBOOT0_Field := STM32G4_SVD.Flash.B_0x0;
      --  None
      NRST_MODE      : FLASH_OPTR_NRST_MODE_Field :=
                        FLASH_OPTR_NRST_MODE_Field_Reset;
      --  Internal reset holder enable bit
      IRHEN          : FLASH_OPTR_IRHEN_Field := STM32G4_SVD.Flash.B_0x0;
      --  unspecified
      Reserved_31_31 : STM32G4_SVD.Bit := 16#0#;
   end record
     with Volatile_Full_Access, Object_Size => 32,
          Bit_Order => System.Low_Order_First;

   for FLASH_OPTR_Register use record
      RDP            at 0 range 0 .. 7;
      BOR_LEV        at 0 range 8 .. 10;
      Reserved_11_11 at 0 range 11 .. 11;
      nRST_STOP      at 0 range 12 .. 12;
      nRST_STDBY     at 0 range 13 .. 13;
      nRST_SHDW      at 0 range 14 .. 14;
      Reserved_15_15 at 0 range 15 .. 15;
      IWDG_SW        at 0 range 16 .. 16;
      IWDG_STOP      at 0 range 17 .. 17;
      IWGD_STDBY     at 0 range 18 .. 18;
      WWDG_SW        at 0 range 19 .. 19;
      BFB2           at 0 range 20 .. 20;
      Reserved_21_21 at 0 range 21 .. 21;
      DBANK          at 0 range 22 .. 22;
      nBOOT1         at 0 range 23 .. 23;
      SRAM_PE        at 0 range 24 .. 24;
      CCMSRAM_RST    at 0 range 25 .. 25;
      nSWBOOT0       at 0 range 26 .. 26;
      nBOOT0         at 0 range 27 .. 27;
      NRST_MODE      at 0 range 28 .. 29;
      IRHEN          at 0 range 30 .. 30;
      Reserved_31_31 at 0 range 31 .. 31;
   end record;

   subtype FLASH_PCROP1SR_PCROP1_STRT_Field is STM32G4_SVD.UInt15;

   --  Flash PCROP1 Start address register
   type FLASH_PCROP1SR_Register is record
      --  PCROP area start offset 	
      PCROP1_STRT    : FLASH_PCROP1SR_PCROP1_STRT_Field := 16#0#;
      --  unspecified
      Reserved_15_31 : STM32G4_SVD.UInt17 := 16#1FFFE#;
   end record
     with Volatile_Full_Access, Object_Size => 32,
          Bit_Order => System.Low_Order_First;

   for FLASH_PCROP1SR_Register use record
      PCROP1_STRT    at 0 range 0 .. 14;
      Reserved_15_31 at 0 range 15 .. 31;
   end record;

   subtype FLASH_PCROP1ER_PCROP1_END_Field is STM32G4_SVD.UInt15;

   --  PCROP area preserved when RDP level decreased 	
   type FLASH_PCROP1ER_PCROP_RDP_Field is
     (--  PCROP area is not erased when the RDP level is decreased from Level 1 to
--  Level 0.
      B_0x0,
      --  PCROP area is erased when the RDP level is decreased from Level 1 to Level
--  0 (full mass erase).
      B_0x1)
     with Size => 1;
   for FLASH_PCROP1ER_PCROP_RDP_Field use
     (B_0x0 => 0,
      B_0x1 => 1);

   --  Flash PCROP1 End address register
   type FLASH_PCROP1ER_Register is record
      --  Bank 1 PCROP area end offset 	
      PCROP1_END     : FLASH_PCROP1ER_PCROP1_END_Field := 16#0#;
      --  unspecified
      Reserved_15_30 : STM32G4_SVD.UInt16 := 16#0#;
      --  PCROP area preserved when RDP level decreased 	
      PCROP_RDP      : FLASH_PCROP1ER_PCROP_RDP_Field :=
                        STM32G4_SVD.Flash.B_0x0;
   end record
     with Volatile_Full_Access, Object_Size => 32,
          Bit_Order => System.Low_Order_First;

   for FLASH_PCROP1ER_Register use record
      PCROP1_END     at 0 range 0 .. 14;
      Reserved_15_30 at 0 range 15 .. 30;
      PCROP_RDP      at 0 range 31 .. 31;
   end record;

   subtype FLASH_WRP1AR_WRP1A_STRT_Field is STM32G4_SVD.UInt7;
   subtype FLASH_WRP1AR_WRP1A_END_Field is STM32G4_SVD.UInt7;

   --  Flash Bank 1 WRP area A address register
   type FLASH_WRP1AR_Register is record
      --  WRP first area A start offset 	
      WRP1A_STRT     : FLASH_WRP1AR_WRP1A_STRT_Field := 16#0#;
      --  unspecified
      Reserved_7_15  : STM32G4_SVD.UInt9 := 16#0#;
      --  WRP first area A end offset 	
      WRP1A_END      : FLASH_WRP1AR_WRP1A_END_Field := 16#0#;
      --  unspecified
      Reserved_23_31 : STM32G4_SVD.UInt9 := 16#0#;
   end record
     with Volatile_Full_Access, Object_Size => 32,
          Bit_Order => System.Low_Order_First;

   for FLASH_WRP1AR_Register use record
      WRP1A_STRT     at 0 range 0 .. 6;
      Reserved_7_15  at 0 range 7 .. 15;
      WRP1A_END      at 0 range 16 .. 22;
      Reserved_23_31 at 0 range 23 .. 31;
   end record;

   subtype FLASH_WRP1BR_WRP1B_STRT_Field is STM32G4_SVD.UInt7;
   subtype FLASH_WRP1BR_WRP1B_END_Field is STM32G4_SVD.UInt7;

   --  Flash Bank 1 WRP area B address register
   type FLASH_WRP1BR_Register is record
      --  WRP second area B start offset 	
      WRP1B_STRT     : FLASH_WRP1BR_WRP1B_STRT_Field := 16#0#;
      --  unspecified
      Reserved_7_15  : STM32G4_SVD.UInt9 := 16#0#;
      --  WRP second area B end offset 	
      WRP1B_END      : FLASH_WRP1BR_WRP1B_END_Field := 16#0#;
      --  unspecified
      Reserved_23_31 : STM32G4_SVD.UInt9 := 16#0#;
   end record
     with Volatile_Full_Access, Object_Size => 32,
          Bit_Order => System.Low_Order_First;

   for FLASH_WRP1BR_Register use record
      WRP1B_STRT     at 0 range 0 .. 6;
      Reserved_7_15  at 0 range 7 .. 15;
      WRP1B_END      at 0 range 16 .. 22;
      Reserved_23_31 at 0 range 23 .. 31;
   end record;

   subtype FLASH_PCROP2SR_PCROP2_STRT_Field is STM32G4_SVD.UInt15;

   --  Flash PCROP2 Start address register
   type FLASH_PCROP2SR_Register is record
      --  PCROP area start offset 	
      PCROP2_STRT    : FLASH_PCROP2SR_PCROP2_STRT_Field := 16#0#;
      --  unspecified
      Reserved_15_31 : STM32G4_SVD.UInt17 := 16#1FFFE#;
   end record
     with Volatile_Full_Access, Object_Size => 32,
          Bit_Order => System.Low_Order_First;

   for FLASH_PCROP2SR_Register use record
      PCROP2_STRT    at 0 range 0 .. 14;
      Reserved_15_31 at 0 range 15 .. 31;
   end record;

   subtype FLASH_PCROP2ER_PCROP2_END_Field is STM32G4_SVD.UInt15;

   --  Flash PCROP2 End address register
   type FLASH_PCROP2ER_Register is record
      --  PCROP area end offset 	
      PCROP2_END     : FLASH_PCROP2ER_PCROP2_END_Field := 16#0#;
      --  unspecified
      Reserved_15_31 : STM32G4_SVD.UInt17 := 16#0#;
   end record
     with Volatile_Full_Access, Object_Size => 32,
          Bit_Order => System.Low_Order_First;

   for FLASH_PCROP2ER_Register use record
      PCROP2_END     at 0 range 0 .. 14;
      Reserved_15_31 at 0 range 15 .. 31;
   end record;

   subtype FLASH_WRP2AR_WRP2A_STRT_Field is STM32G4_SVD.UInt7;
   subtype FLASH_WRP2AR_WRP2A_END_Field is STM32G4_SVD.UInt7;

   --  Flash Bank 2 WRP area A address register
   type FLASH_WRP2AR_Register is record
      --  WRP first area A start offset 	
      WRP2A_STRT     : FLASH_WRP2AR_WRP2A_STRT_Field := 16#0#;
      --  unspecified
      Reserved_7_15  : STM32G4_SVD.UInt9 := 16#0#;
      --  WRP first area A end offset 	
      WRP2A_END      : FLASH_WRP2AR_WRP2A_END_Field := 16#0#;
      --  unspecified
      Reserved_23_31 : STM32G4_SVD.UInt9 := 16#0#;
   end record
     with Volatile_Full_Access, Object_Size => 32,
          Bit_Order => System.Low_Order_First;

   for FLASH_WRP2AR_Register use record
      WRP2A_STRT     at 0 range 0 .. 6;
      Reserved_7_15  at 0 range 7 .. 15;
      WRP2A_END      at 0 range 16 .. 22;
      Reserved_23_31 at 0 range 23 .. 31;
   end record;

   subtype FLASH_WRP2BR_WRP2B_STRT_Field is STM32G4_SVD.UInt7;
   subtype FLASH_WRP2BR_WRP2B_END_Field is STM32G4_SVD.UInt7;

   --  Flash Bank 2 WRP area B address register
   type FLASH_WRP2BR_Register is record
      --  WRP second area B start offset 	
      WRP2B_STRT     : FLASH_WRP2BR_WRP2B_STRT_Field := 16#0#;
      --  unspecified
      Reserved_7_15  : STM32G4_SVD.UInt9 := 16#0#;
      --  WRP second area B end offset 	
      WRP2B_END      : FLASH_WRP2BR_WRP2B_END_Field := 16#0#;
      --  unspecified
      Reserved_23_31 : STM32G4_SVD.UInt9 := 16#0#;
   end record
     with Volatile_Full_Access, Object_Size => 32,
          Bit_Order => System.Low_Order_First;

   for FLASH_WRP2BR_Register use record
      WRP2B_STRT     at 0 range 0 .. 6;
      Reserved_7_15  at 0 range 7 .. 15;
      WRP2B_END      at 0 range 16 .. 22;
      Reserved_23_31 at 0 range 23 .. 31;
   end record;

   subtype FLASH_SEC1R_SEC_SIZE1_Field is STM32G4_SVD.Byte;

   --  used to force boot from user Flash area.
   type FLASH_SEC1R_BOOT_LOCK_Field is
     (--  Boot based on the pad/option bit configuration
      B_0x0,
      --  Boot forced from Main Flash memory
      B_0x1)
     with Size => 1;
   for FLASH_SEC1R_BOOT_LOCK_Field use
     (B_0x0 => 0,
      B_0x1 => 1);

   --  Flash Securable area bank1 register
   type FLASH_SEC1R_Register is record
      --  sets the number of pages used in the bank 1 Securable memory area. 	
      SEC_SIZE1      : FLASH_SEC1R_SEC_SIZE1_Field := 16#0#;
      --  unspecified
      Reserved_8_15  : STM32G4_SVD.Byte := 16#FF#;
      --  used to force boot from user Flash area.
      BOOT_LOCK      : FLASH_SEC1R_BOOT_LOCK_Field := STM32G4_SVD.Flash.B_0x0;
      --  unspecified
      Reserved_17_31 : STM32G4_SVD.UInt15 := 16#7FF8#;
   end record
     with Volatile_Full_Access, Object_Size => 32,
          Bit_Order => System.Low_Order_First;

   for FLASH_SEC1R_Register use record
      SEC_SIZE1      at 0 range 0 .. 7;
      Reserved_8_15  at 0 range 8 .. 15;
      BOOT_LOCK      at 0 range 16 .. 16;
      Reserved_17_31 at 0 range 17 .. 31;
   end record;

   subtype FLASH_SEC2R_SEC_SIZE2_Field is STM32G4_SVD.Byte;

   --  Flash Securable area bank2 register
   type FLASH_SEC2R_Register is record
      --  sets the number of pages used in the bank 2 Securable memory area. 	
      SEC_SIZE2     : FLASH_SEC2R_SEC_SIZE2_Field := 16#0#;
      --  unspecified
      Reserved_8_31 : STM32G4_SVD.UInt24 := 16#FFFFFF#;
   end record
     with Volatile_Full_Access, Object_Size => 32,
          Bit_Order => System.Low_Order_First;

   for FLASH_SEC2R_Register use record
      SEC_SIZE2     at 0 range 0 .. 7;
      Reserved_8_31 at 0 range 8 .. 31;
   end record;

   -----------------
   -- Peripherals --
   -----------------

   --  Flash
   type FLASH_Peripheral is record
      --  Flash access control register
      FLASH_ACR      : aliased FLASH_ACR_Register;
      --  Flash Power-down key register
      FLASH_PDKEYR   : aliased STM32G4_SVD.UInt32;
      --  Flash key register
      FLASH_KEYR     : aliased STM32G4_SVD.UInt32;
      --  Flash option key register
      FLASH_OPTKEYR  : aliased STM32G4_SVD.UInt32;
      --  Flash status register
      FLASH_SR       : aliased FLASH_SR_Register;
      --  Flash control register
      FLASH_CR       : aliased FLASH_CR_Register;
      --  Flash ECC register
      FLASH_ECCR     : aliased FLASH_ECCR_Register;
      FLASH_OPTR     : aliased FLASH_OPTR_Register;
      --  Flash PCROP1 Start address register
      FLASH_PCROP1SR : aliased FLASH_PCROP1SR_Register;
      --  Flash PCROP1 End address register
      FLASH_PCROP1ER : aliased FLASH_PCROP1ER_Register;
      --  Flash Bank 1 WRP area A address register
      FLASH_WRP1AR   : aliased FLASH_WRP1AR_Register;
      --  Flash Bank 1 WRP area B address register
      FLASH_WRP1BR   : aliased FLASH_WRP1BR_Register;
      --  Flash PCROP2 Start address register
      FLASH_PCROP2SR : aliased FLASH_PCROP2SR_Register;
      --  Flash PCROP2 End address register
      FLASH_PCROP2ER : aliased FLASH_PCROP2ER_Register;
      --  Flash Bank 2 WRP area A address register
      FLASH_WRP2AR   : aliased FLASH_WRP2AR_Register;
      --  Flash Bank 2 WRP area B address register
      FLASH_WRP2BR   : aliased FLASH_WRP2BR_Register;
      --  Flash Securable area bank1 register
      FLASH_SEC1R    : aliased FLASH_SEC1R_Register;
      --  Flash Securable area bank2 register
      FLASH_SEC2R    : aliased FLASH_SEC2R_Register;
   end record
     with Volatile;

   for FLASH_Peripheral use record
      FLASH_ACR      at 16#0# range 0 .. 31;
      FLASH_PDKEYR   at 16#4# range 0 .. 31;
      FLASH_KEYR     at 16#8# range 0 .. 31;
      FLASH_OPTKEYR  at 16#C# range 0 .. 31;
      FLASH_SR       at 16#10# range 0 .. 31;
      FLASH_CR       at 16#14# range 0 .. 31;
      FLASH_ECCR     at 16#18# range 0 .. 31;
      FLASH_OPTR     at 16#20# range 0 .. 31;
      FLASH_PCROP1SR at 16#24# range 0 .. 31;
      FLASH_PCROP1ER at 16#28# range 0 .. 31;
      FLASH_WRP1AR   at 16#2C# range 0 .. 31;
      FLASH_WRP1BR   at 16#30# range 0 .. 31;
      FLASH_PCROP2SR at 16#44# range 0 .. 31;
      FLASH_PCROP2ER at 16#48# range 0 .. 31;
      FLASH_WRP2AR   at 16#4C# range 0 .. 31;
      FLASH_WRP2BR   at 16#50# range 0 .. 31;
      FLASH_SEC1R    at 16#70# range 0 .. 31;
      FLASH_SEC2R    at 16#74# range 0 .. 31;
   end record;

   --  Flash
   FLASH_Periph : aliased FLASH_Peripheral
     with Import, Address => FLASH_Base;

end STM32G4_SVD.Flash;
