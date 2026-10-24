pragma Style_Checks (Off);

--  Copyright (c) 2024 Raspberry Pi Ltd.        SPDX-License-Identifier: BSD-3-Clause

--  This spec has been automatically generated from RP2350.svd

pragma Restrictions (No_Elaboration_Code);

with System;

--  Arm TrustZone RNG register block
package RP2350_SVD.TRNG is
   pragma Preelaborate;

   ---------------
   -- Registers --
   ---------------

   --  Interrupt masking.
   type RNG_IMR_Register is record
      --  Set to 1 to mask (disable) this interrupt: no interrupt will be
      --  generated. See RNG_ISR for an explanation on this interrupt.
      EHR_VALID_INT_MASK    : Boolean := True;
      --  Set to 1 to mask (disable) this interrupt: no interrupt will be
      --  generated. See RNG_ISR for an explanation on this interrupt.
      AUTOCORR_ERR_INT_MASK : Boolean := True;
      --  Set to 1 to mask (disable) this interrupt: no interrupt will be
      --  generated. See RNG_ISR for an explanation on this interrupt.
      CRNGT_ERR_INT_MASK    : Boolean := True;
      --  Set to 1 to mask (disable) this interrupt: no interrupt will be
      --  generated. See RNG_ISR for an explanation on this interrupt.
      VN_ERR_INT_MASK       : Boolean := True;
      --  unspecified
      Reserved_4_31         : RP2350_SVD.UInt28 := 16#0#;
   end record
     with Volatile_Full_Access, Object_Size => 32,
          Bit_Order => System.Low_Order_First;

   for RNG_IMR_Register use record
      EHR_VALID_INT_MASK    at 0 range 0 .. 0;
      AUTOCORR_ERR_INT_MASK at 0 range 1 .. 1;
      CRNGT_ERR_INT_MASK    at 0 range 2 .. 2;
      VN_ERR_INT_MASK       at 0 range 3 .. 3;
      Reserved_4_31         at 0 range 4 .. 31;
   end record;

   --  RNG status register. If corresponding RNG_IMR bit is unmasked, an
   --  interrupt will be generated.
   type RNG_ISR_Register is record
      --  Read-only. 1 indicates that 192 bits have been collected in the RNG,
      --  and are ready to be read.
      EHR_VALID     : Boolean;
      --  Read-only. 1 indicates Autocorrelation test failed four times in a
      --  row. When set, RNG ceases functioning until next reset.
      AUTOCORR_ERR  : Boolean;
      --  Read-only. 1 indicates CRNGT in the RNG test failed. Failure occurs
      --  when two consecutive blocks of 16 collected bits are equal.
      CRNGT_ERR     : Boolean;
      --  Read-only. 1 indicates von Neumann error. Error in von Neumann occurs
      --  if 32 consecutive collected bits are identical, ZERO or ONE.
      VN_ERR        : Boolean;
      --  unspecified
      Reserved_4_31 : RP2350_SVD.UInt28;
   end record
     with Volatile_Full_Access, Object_Size => 32,
          Bit_Order => System.Low_Order_First;

   for RNG_ISR_Register use record
      EHR_VALID     at 0 range 0 .. 0;
      AUTOCORR_ERR  at 0 range 1 .. 1;
      CRNGT_ERR     at 0 range 2 .. 2;
      VN_ERR        at 0 range 3 .. 3;
      Reserved_4_31 at 0 range 4 .. 31;
   end record;

   --  Interrupt/status bit clear Register.
   type RNG_ICR_Register is record
      --  Write 1 - clear corresponding bit in RNG_ISR.
      EHR_VALID     : Boolean := False;
      --  Cannot be cleared by SW! Only RNG reset clears this bit.
      AUTOCORR_ERR  : Boolean := False;
      --  Write 1 to clear corresponding bit in RNG_ISR.
      CRNGT_ERR     : Boolean := False;
      --  Write 1 to clear corresponding bit in RNG_ISR.
      VN_ERR        : Boolean := False;
      --  unspecified
      Reserved_4_31 : RP2350_SVD.UInt28 := 16#0#;
   end record
     with Volatile_Full_Access, Object_Size => 32,
          Bit_Order => System.Low_Order_First;

   for RNG_ICR_Register use record
      EHR_VALID     at 0 range 0 .. 0;
      AUTOCORR_ERR  at 0 range 1 .. 1;
      CRNGT_ERR     at 0 range 2 .. 2;
      VN_ERR        at 0 range 3 .. 3;
      Reserved_4_31 at 0 range 4 .. 31;
   end record;

   subtype TRNG_CONFIG_RND_SRC_SEL_Field is RP2350_SVD.UInt2;

   --  Selecting the inverter-chain length.
   type TRNG_CONFIG_Register is record
      --  Selects the number of inverters (out of four possible selections) in
      --  the ring oscillator (the entropy source). Higher values select longer
      --  inverter chain lengths.
      RND_SRC_SEL   : TRNG_CONFIG_RND_SRC_SEL_Field := 16#0#;
      --  unspecified
      Reserved_2_31 : RP2350_SVD.UInt30 := 16#0#;
   end record
     with Volatile_Full_Access, Object_Size => 32,
          Bit_Order => System.Low_Order_First;

   for TRNG_CONFIG_Register use record
      RND_SRC_SEL   at 0 range 0 .. 1;
      Reserved_2_31 at 0 range 2 .. 31;
   end record;

   --  192 bit collection indication.
   type TRNG_VALID_Register is record
      --  Read-only. 1 indicates that collection of bits in the RNG is
      --  completed, and data can be read from EHR_DATA register.
      EHR_VALID     : Boolean;
      --  unspecified
      Reserved_1_31 : RP2350_SVD.UInt31;
   end record
     with Volatile_Full_Access, Object_Size => 32,
          Bit_Order => System.Low_Order_First;

   for TRNG_VALID_Register use record
      EHR_VALID     at 0 range 0 .. 0;
      Reserved_1_31 at 0 range 1 .. 31;
   end record;

   --  Enable signal for the random source.
   type RND_SOURCE_ENABLE_Register is record
      --  * 1 - entropy source is enabled. * 0 - entropy source is disabled
      RND_SRC_EN    : Boolean := False;
      --  unspecified
      Reserved_1_31 : RP2350_SVD.UInt31 := 16#0#;
   end record
     with Volatile_Full_Access, Object_Size => 32,
          Bit_Order => System.Low_Order_First;

   for RND_SOURCE_ENABLE_Register use record
      RND_SRC_EN    at 0 range 0 .. 0;
      Reserved_1_31 at 0 range 1 .. 31;
   end record;

   subtype AUTOCORR_STATISTIC_AUTOCORR_TRYS_Field is RP2350_SVD.UInt14;
   subtype AUTOCORR_STATISTIC_AUTOCORR_FAILS_Field is RP2350_SVD.Byte;

   --  Statistics about autocorrelation test activations.
   type AUTOCORR_STATISTIC_Register is record
      --  Count each time an autocorrelation test starts. Any write to the
      --  register reset the counter. Stop collecting statistic if one of the
      --  counters reached the limit.
      AUTOCORR_TRYS  : AUTOCORR_STATISTIC_AUTOCORR_TRYS_Field := 16#0#;
      --  Count each time an autocorrelation test fails. Any write to the
      --  register reset the counter. Stop collecting statistic if one of the
      --  counters reached the limit.
      AUTOCORR_FAILS : AUTOCORR_STATISTIC_AUTOCORR_FAILS_Field := 16#0#;
      --  unspecified
      Reserved_22_31 : RP2350_SVD.UInt10 := 16#0#;
   end record
     with Volatile_Full_Access, Object_Size => 32,
          Bit_Order => System.Low_Order_First;

   for AUTOCORR_STATISTIC_Register use record
      AUTOCORR_TRYS  at 0 range 0 .. 13;
      AUTOCORR_FAILS at 0 range 14 .. 21;
      Reserved_22_31 at 0 range 22 .. 31;
   end record;

   --  Debug register.
   type TRNG_DEBUG_CONTROL_Register is record
      --  unspecified
      Reserved_0_0          : RP2350_SVD.Bit := 16#0#;
      --  When set, the Von-Neuman balancer is bypassed (including the 32
      --  consecutive bits test). N/A
      VNC_BYPASS            : Boolean := False;
      --  When set, the CRNGT test in the RNG is bypassed.
      TRNG_CRNGT_BYPASS     : Boolean := False;
      --  When set, the autocorrelation test in the TRNG module is bypassed.
      AUTO_CORRELATE_BYPASS : Boolean := False;
      --  unspecified
      Reserved_4_31         : RP2350_SVD.UInt28 := 16#0#;
   end record
     with Volatile_Full_Access, Object_Size => 32,
          Bit_Order => System.Low_Order_First;

   for TRNG_DEBUG_CONTROL_Register use record
      Reserved_0_0          at 0 range 0 .. 0;
      VNC_BYPASS            at 0 range 1 .. 1;
      TRNG_CRNGT_BYPASS     at 0 range 2 .. 2;
      AUTO_CORRELATE_BYPASS at 0 range 3 .. 3;
      Reserved_4_31         at 0 range 4 .. 31;
   end record;

   --  Generate internal SW reset within the RNG block.
   type TRNG_SW_RESET_Register is record
      --  Writing 1 to this register causes an internal RNG reset.
      TRNG_SW_RESET : Boolean := False;
      --  unspecified
      Reserved_1_31 : RP2350_SVD.UInt31 := 16#0#;
   end record
     with Volatile_Full_Access, Object_Size => 32,
          Bit_Order => System.Low_Order_First;

   for TRNG_SW_RESET_Register use record
      TRNG_SW_RESET at 0 range 0 .. 0;
      Reserved_1_31 at 0 range 1 .. 31;
   end record;

   --  Enable the RNG debug mode
   type RNG_DEBUG_EN_INPUT_Register is record
      --  * 1 - debug mode is enabled. * 0 - debug mode is disabled
      RNG_DEBUG_EN  : Boolean := False;
      --  unspecified
      Reserved_1_31 : RP2350_SVD.UInt31 := 16#0#;
   end record
     with Volatile_Full_Access, Object_Size => 32,
          Bit_Order => System.Low_Order_First;

   for RNG_DEBUG_EN_INPUT_Register use record
      RNG_DEBUG_EN  at 0 range 0 .. 0;
      Reserved_1_31 at 0 range 1 .. 31;
   end record;

   --  RNG Busy indication.
   type TRNG_BUSY_Register is record
      --  Read-only. Reflects rng_busy status.
      TRNG_BUSY     : Boolean;
      --  unspecified
      Reserved_1_31 : RP2350_SVD.UInt31;
   end record
     with Volatile_Full_Access, Object_Size => 32,
          Bit_Order => System.Low_Order_First;

   for TRNG_BUSY_Register use record
      TRNG_BUSY     at 0 range 0 .. 0;
      Reserved_1_31 at 0 range 1 .. 31;
   end record;

   --  Reset the counter of collected bits in the RNG.
   type RST_BITS_COUNTER_Register is record
      --  Writing any value to this address will reset the bits counter and RNG
      --  valid registers. RND_SORCE_ENABLE register must be unset in order for
      --  the reset to take place.
      RST_BITS_COUNTER : Boolean := False;
      --  unspecified
      Reserved_1_31    : RP2350_SVD.UInt31 := 16#0#;
   end record
     with Volatile_Full_Access, Object_Size => 32,
          Bit_Order => System.Low_Order_First;

   for RST_BITS_COUNTER_Register use record
      RST_BITS_COUNTER at 0 range 0 .. 0;
      Reserved_1_31    at 0 range 1 .. 31;
   end record;

   --  Displays the version settings of the TRNG.
   type RNG_VERSION_Register is record
      --  Read-only. * 1 - 192-bit EHR. * 0 - 128-bit EHR
      EHR_WIDTH_192        : Boolean;
      --  Read-only. * 1 - Exists. * 0 - Does not exist
      CRNGT_EXISTS         : Boolean;
      --  Read-only. * 1 - Exists. * 0 - Does not exist
      AUTOCORR_EXISTS      : Boolean;
      --  Read-only. * 1 - Exists. * 0 - Does not exist
      TRNG_TESTS_BYPASS_EN : Boolean;
      --  Read-only. * 1 - Exists. * 0 - Does not exist
      PRNG_EXISTS          : Boolean;
      --  Read-only. * 1 - Exists. * 0 - Does not exist
      KAT_EXISTS           : Boolean;
      --  Read-only. * 1 - Exists. * 0 - Does not exist
      RESEEDING_EXISTS     : Boolean;
      --  Read-only. * 1 - 5 SBOX AES. * 0 - 20 SBOX AES
      RNG_USE_5_SBOXES     : Boolean;
      --  unspecified
      Reserved_8_31        : RP2350_SVD.UInt24;
   end record
     with Volatile_Full_Access, Object_Size => 32,
          Bit_Order => System.Low_Order_First;

   for RNG_VERSION_Register use record
      EHR_WIDTH_192        at 0 range 0 .. 0;
      CRNGT_EXISTS         at 0 range 1 .. 1;
      AUTOCORR_EXISTS      at 0 range 2 .. 2;
      TRNG_TESTS_BYPASS_EN at 0 range 3 .. 3;
      PRNG_EXISTS          at 0 range 4 .. 4;
      KAT_EXISTS           at 0 range 5 .. 5;
      RESEEDING_EXISTS     at 0 range 6 .. 6;
      RNG_USE_5_SBOXES     at 0 range 7 .. 7;
      Reserved_8_31        at 0 range 8 .. 31;
   end record;

   subtype RNG_BIST_CNTR_0_ROSC_CNTR_VAL_Field is RP2350_SVD.UInt22;

   --  Collected BIST results.
   type RNG_BIST_CNTR_0_Register is record
      --  Read-only. Reflects the results of RNG BIST counter.
      ROSC_CNTR_VAL  : RNG_BIST_CNTR_0_ROSC_CNTR_VAL_Field;
      --  unspecified
      Reserved_22_31 : RP2350_SVD.UInt10;
   end record
     with Volatile_Full_Access, Object_Size => 32,
          Bit_Order => System.Low_Order_First;

   for RNG_BIST_CNTR_0_Register use record
      ROSC_CNTR_VAL  at 0 range 0 .. 21;
      Reserved_22_31 at 0 range 22 .. 31;
   end record;

   subtype RNG_BIST_CNTR_1_ROSC_CNTR_VAL_Field is RP2350_SVD.UInt22;

   --  Collected BIST results.
   type RNG_BIST_CNTR_1_Register is record
      --  Read-only. Reflects the results of RNG BIST counter.
      ROSC_CNTR_VAL  : RNG_BIST_CNTR_1_ROSC_CNTR_VAL_Field;
      --  unspecified
      Reserved_22_31 : RP2350_SVD.UInt10;
   end record
     with Volatile_Full_Access, Object_Size => 32,
          Bit_Order => System.Low_Order_First;

   for RNG_BIST_CNTR_1_Register use record
      ROSC_CNTR_VAL  at 0 range 0 .. 21;
      Reserved_22_31 at 0 range 22 .. 31;
   end record;

   subtype RNG_BIST_CNTR_2_ROSC_CNTR_VAL_Field is RP2350_SVD.UInt22;

   --  Collected BIST results.
   type RNG_BIST_CNTR_2_Register is record
      --  Read-only. Reflects the results of RNG BIST counter.
      ROSC_CNTR_VAL  : RNG_BIST_CNTR_2_ROSC_CNTR_VAL_Field;
      --  unspecified
      Reserved_22_31 : RP2350_SVD.UInt10;
   end record
     with Volatile_Full_Access, Object_Size => 32,
          Bit_Order => System.Low_Order_First;

   for RNG_BIST_CNTR_2_Register use record
      ROSC_CNTR_VAL  at 0 range 0 .. 21;
      Reserved_22_31 at 0 range 22 .. 31;
   end record;

   -----------------
   -- Peripherals --
   -----------------

   --  Arm TrustZone RNG register block
   type TRNG_Peripheral is record
      --  Interrupt masking.
      RNG_IMR            : aliased RNG_IMR_Register;
      --  RNG status register. If corresponding RNG_IMR bit is unmasked, an
      --  interrupt will be generated.
      RNG_ISR            : aliased RNG_ISR_Register;
      --  Interrupt/status bit clear Register.
      RNG_ICR            : aliased RNG_ICR_Register;
      --  Selecting the inverter-chain length.
      TRNG_CONFIG        : aliased TRNG_CONFIG_Register;
      --  192 bit collection indication.
      TRNG_VALID         : aliased TRNG_VALID_Register;
      --  RNG collected bits.
      EHR_DATA0          : aliased RP2350_SVD.UInt32;
      --  RNG collected bits.
      EHR_DATA1          : aliased RP2350_SVD.UInt32;
      --  RNG collected bits.
      EHR_DATA2          : aliased RP2350_SVD.UInt32;
      --  RNG collected bits.
      EHR_DATA3          : aliased RP2350_SVD.UInt32;
      --  RNG collected bits.
      EHR_DATA4          : aliased RP2350_SVD.UInt32;
      --  RNG collected bits.
      EHR_DATA5          : aliased RP2350_SVD.UInt32;
      --  Enable signal for the random source.
      RND_SOURCE_ENABLE  : aliased RND_SOURCE_ENABLE_Register;
      --  Counts clocks between sampling of random bit.
      SAMPLE_CNT1        : aliased RP2350_SVD.UInt32;
      --  Statistics about autocorrelation test activations.
      AUTOCORR_STATISTIC : aliased AUTOCORR_STATISTIC_Register;
      --  Debug register.
      TRNG_DEBUG_CONTROL : aliased TRNG_DEBUG_CONTROL_Register;
      --  Generate internal SW reset within the RNG block.
      TRNG_SW_RESET      : aliased TRNG_SW_RESET_Register;
      --  Enable the RNG debug mode
      RNG_DEBUG_EN_INPUT : aliased RNG_DEBUG_EN_INPUT_Register;
      --  RNG Busy indication.
      TRNG_BUSY          : aliased TRNG_BUSY_Register;
      --  Reset the counter of collected bits in the RNG.
      RST_BITS_COUNTER   : aliased RST_BITS_COUNTER_Register;
      --  Displays the version settings of the TRNG.
      RNG_VERSION        : aliased RNG_VERSION_Register;
      --  Collected BIST results.
      RNG_BIST_CNTR_0    : aliased RNG_BIST_CNTR_0_Register;
      --  Collected BIST results.
      RNG_BIST_CNTR_1    : aliased RNG_BIST_CNTR_1_Register;
      --  Collected BIST results.
      RNG_BIST_CNTR_2    : aliased RNG_BIST_CNTR_2_Register;
   end record
     with Volatile;

   for TRNG_Peripheral use record
      RNG_IMR            at 16#100# range 0 .. 31;
      RNG_ISR            at 16#104# range 0 .. 31;
      RNG_ICR            at 16#108# range 0 .. 31;
      TRNG_CONFIG        at 16#10C# range 0 .. 31;
      TRNG_VALID         at 16#110# range 0 .. 31;
      EHR_DATA0          at 16#114# range 0 .. 31;
      EHR_DATA1          at 16#118# range 0 .. 31;
      EHR_DATA2          at 16#11C# range 0 .. 31;
      EHR_DATA3          at 16#120# range 0 .. 31;
      EHR_DATA4          at 16#124# range 0 .. 31;
      EHR_DATA5          at 16#128# range 0 .. 31;
      RND_SOURCE_ENABLE  at 16#12C# range 0 .. 31;
      SAMPLE_CNT1        at 16#130# range 0 .. 31;
      AUTOCORR_STATISTIC at 16#134# range 0 .. 31;
      TRNG_DEBUG_CONTROL at 16#138# range 0 .. 31;
      TRNG_SW_RESET      at 16#140# range 0 .. 31;
      RNG_DEBUG_EN_INPUT at 16#1B4# range 0 .. 31;
      TRNG_BUSY          at 16#1B8# range 0 .. 31;
      RST_BITS_COUNTER   at 16#1BC# range 0 .. 31;
      RNG_VERSION        at 16#1C0# range 0 .. 31;
      RNG_BIST_CNTR_0    at 16#1E0# range 0 .. 31;
      RNG_BIST_CNTR_1    at 16#1E4# range 0 .. 31;
      RNG_BIST_CNTR_2    at 16#1E8# range 0 .. 31;
   end record;

   --  Arm TrustZone RNG register block
   TRNG_Periph : aliased TRNG_Peripheral
     with Import, Address => TRNG_Base;

end RP2350_SVD.TRNG;
