pragma Style_Checks (Off);

--  This spec has been automatically generated from STM32G474.svd

pragma Restrictions (No_Elaboration_Code);

with System;

package STM32G4_SVD.TIM is
   pragma Preelaborate;

   ---------------
   -- Registers --
   ---------------

   --  Counter enable 	
   type TIM1_CR1_CEN_Field is
     (--  Counter disabled
      B_0x0,
      --  Counter enabled
      B_0x1)
     with Size => 1;
   for TIM1_CR1_CEN_Field use
     (B_0x0 => 0,
      B_0x1 => 1);

   --  Update disable 	
   type TIM1_CR1_UDIS_Field is
     (--  UEV enabled.
      B_0x0,
      --  UEV disabled.
      B_0x1)
     with Size => 1;
   for TIM1_CR1_UDIS_Field use
     (B_0x0 => 0,
      B_0x1 => 1);

   --  Update request source 	
   type TIM1_CR1_URS_Field is
     (--  Any of the following events generate an update interrupt or DMA request if
--  enabled.
      B_0x0,
      --  Only counter overflow/underflow generates an update interrupt or DMA
--  request if enabled.
      B_0x1)
     with Size => 1;
   for TIM1_CR1_URS_Field use
     (B_0x0 => 0,
      B_0x1 => 1);

   --  One-pulse mode
   type TIM1_CR1_OPM_Field is
     (--  Counter is not stopped at update event
      B_0x0,
      --  Counter stops counting at the next update event (clearing the bit CEN)
      B_0x1)
     with Size => 1;
   for TIM1_CR1_OPM_Field use
     (B_0x0 => 0,
      B_0x1 => 1);

   --  Direction 	
   type TIM1_CR1_DIR_Field is
     (--  Counter used as upcounter
      B_0x0,
      --  Counter used as downcounter
      B_0x1)
     with Size => 1;
   for TIM1_CR1_DIR_Field use
     (B_0x0 => 0,
      B_0x1 => 1);

   --  Center-aligned mode selection 	
   type TIM1_CR1_CMS_Field is
     (--  Edge-aligned mode.
      B_0x0,
      --  Center-aligned mode 1.
      B_0x1,
      --  Center-aligned mode 2.
      B_0x2,
      --  Center-aligned mode 3.
      B_0x3)
     with Size => 2;
   for TIM1_CR1_CMS_Field use
     (B_0x0 => 0,
      B_0x1 => 1,
      B_0x2 => 2,
      B_0x3 => 3);

   --  Auto-reload preload enable
   type TIM1_CR1_ARPE_Field is
     (--  TIMx_ARR register is not buffered
      B_0x0,
      --  TIMx_ARR register is buffered
      B_0x1)
     with Size => 1;
   for TIM1_CR1_ARPE_Field use
     (B_0x0 => 0,
      B_0x1 => 1);

   --  Clock division 	
   type TIM1_CR1_CKD_Field is
     (--  tless thansub>DTSless than/sub>=tless thansub>tim_ker_ckless than/sub>
      B_0x0,
      --  tless thansub>DTSless than/sub>=2*tless thansub>tim_ker_ckless than/sub>
      B_0x1,
      --  tless thansub>DTSless than/sub>=4*tless thansub>tim_ker_ckless than/sub>
      B_0x2)
     with Size => 2;
   for TIM1_CR1_CKD_Field use
     (B_0x0 => 0,
      B_0x1 => 1,
      B_0x2 => 2);

   --  UIF status bit remapping
   type TIM1_CR1_UIFREMAP_Field is
     (--  No remapping.
      B_0x0,
      --  Remapping enabled.
      B_0x1)
     with Size => 1;
   for TIM1_CR1_UIFREMAP_Field use
     (B_0x0 => 0,
      B_0x1 => 1);

   --  Dithering enable 	
   type TIM1_CR1_DITHEN_Field is
     (--  Dithering disabled
      B_0x0,
      --  Dithering enabled
      B_0x1)
     with Size => 1;
   for TIM1_CR1_DITHEN_Field use
     (B_0x0 => 0,
      B_0x1 => 1);

   --  TIM1 control register 1
   type TIM1_CR1_Register is record
      --  Counter enable 	
      CEN            : TIM1_CR1_CEN_Field := STM32G4_SVD.TIM.B_0x0;
      --  Update disable 	
      UDIS           : TIM1_CR1_UDIS_Field := STM32G4_SVD.TIM.B_0x0;
      --  Update request source 	
      URS            : TIM1_CR1_URS_Field := STM32G4_SVD.TIM.B_0x0;
      --  One-pulse mode
      OPM            : TIM1_CR1_OPM_Field := STM32G4_SVD.TIM.B_0x0;
      --  Direction 	
      DIR            : TIM1_CR1_DIR_Field := STM32G4_SVD.TIM.B_0x0;
      --  Center-aligned mode selection 	
      CMS            : TIM1_CR1_CMS_Field := STM32G4_SVD.TIM.B_0x0;
      --  Auto-reload preload enable
      ARPE           : TIM1_CR1_ARPE_Field := STM32G4_SVD.TIM.B_0x0;
      --  Clock division 	
      CKD            : TIM1_CR1_CKD_Field := STM32G4_SVD.TIM.B_0x0;
      --  unspecified
      Reserved_10_10 : STM32G4_SVD.Bit := 16#0#;
      --  UIF status bit remapping
      UIFREMAP       : TIM1_CR1_UIFREMAP_Field := STM32G4_SVD.TIM.B_0x0;
      --  Dithering enable 	
      DITHEN         : TIM1_CR1_DITHEN_Field := STM32G4_SVD.TIM.B_0x0;
      --  unspecified
      Reserved_13_15 : STM32G4_SVD.UInt3 := 16#0#;
   end record
     with Volatile_Full_Access, Object_Size => 16,
          Bit_Order => System.Low_Order_First;

   for TIM1_CR1_Register use record
      CEN            at 0 range 0 .. 0;
      UDIS           at 0 range 1 .. 1;
      URS            at 0 range 2 .. 2;
      OPM            at 0 range 3 .. 3;
      DIR            at 0 range 4 .. 4;
      CMS            at 0 range 5 .. 6;
      ARPE           at 0 range 7 .. 7;
      CKD            at 0 range 8 .. 9;
      Reserved_10_10 at 0 range 10 .. 10;
      UIFREMAP       at 0 range 11 .. 11;
      DITHEN         at 0 range 12 .. 12;
      Reserved_13_15 at 0 range 13 .. 15;
   end record;

   --  Capture/compare preloaded control 	
   type TIM1_CR2_CCPC_Field is
     (--  CCxE, CCxNE and OCxM bits are not preloaded
      B_0x0,
      --  CCxE, CCxNE and OCxM bits are preloaded, after having been written, they
--  are updated only when a commutation event (COM) occurs (COMG bit set or
--  rising edge detected on tim_trgi, depending on the CCUS bit).
      B_0x1)
     with Size => 1;
   for TIM1_CR2_CCPC_Field use
     (B_0x0 => 0,
      B_0x1 => 1);

   --  Capture/compare control update selection 	
   type TIM1_CR2_CCUS_Field is
     (--  When capture/compare control bits are preloaded (CCPC=1), they are updated
--  by setting the COMG bit only
      B_0x0,
      --  When capture/compare control bits are preloaded (CCPC=1), they are updated
--  by setting the COMG bit or when an rising edge occurs on tim_trgi
      B_0x1)
     with Size => 1;
   for TIM1_CR2_CCUS_Field use
     (B_0x0 => 0,
      B_0x1 => 1);

   --  Capture/compare DMA selection
   type TIM1_CR2_CCDS_Field is
     (--  CCx DMA request sent when CCx event occurs
      B_0x0,
      --  CCx DMA requests sent when update event occurs
      B_0x1)
     with Size => 1;
   for TIM1_CR2_CCDS_Field use
     (B_0x0 => 0,
      B_0x1 => 1);

   --  MMS[2:0]: Master mode selection 	
   type TIM1_CR2_MMS_Field is
     (--  Reset - the UG bit from the TIMx_EGR register is used as trigger output
--  (tim_trgo).
      B_0x0,
      --  Enable - the Counter Enable signal CNT_EN is used as trigger output
--  (tim_trgo).
      B_0x1,
      --  Update - The update event is selected as trigger output (tim_trgo).
      B_0x2,
      --  Compare Pulse - The trigger output send a positive pulse when the CC1IF
--  flag is to be set (even if it was already high), as soon as a capture or a
--  compare match occurred.
      B_0x3,
      --  Compare - tim_oc1refc signal is used as trigger output (tim_trgo)
      B_0x4,
      --  Compare - tim_oc2refc signal is used as trigger output (tim_trgo)
      B_0x5,
      --  Compare - tim_oc3refc signal is used as trigger output (tim_trgo)
      B_0x6,
      --  Compare - tim_oc4refc signal is used as trigger output (tim_trgo)
      B_0x7)
     with Size => 3;
   for TIM1_CR2_MMS_Field use
     (B_0x0 => 0,
      B_0x1 => 1,
      B_0x2 => 2,
      B_0x3 => 3,
      B_0x4 => 4,
      B_0x5 => 5,
      B_0x6 => 6,
      B_0x7 => 7);

   --  tim_ti1 selection
   type TIM1_CR2_TI1S_Field is
     (--  The tim_ti1_in[15:0] multiplexer output is connected to tim_ti1 input
      B_0x0,
      --  tim_ti1_in[15:0], tim_ti2_in[15:0] and tim_ti3_in[15:0] multiplexers
--  outputs are XORed and connected to the tim_ti1 input
      B_0x1)
     with Size => 1;
   for TIM1_CR2_TI1S_Field use
     (B_0x0 => 0,
      B_0x1 => 1);

   --  Output idle state 1 (tim_oc1 output) 	
   type TIM1_CR2_OIS1_Field is
     (--  tim_oc1=0 (after a dead-time) when MOE=0
      B_0x0,
      --  tim_oc1=1 (after a dead-time) when MOE=0
      B_0x1)
     with Size => 1;
   for TIM1_CR2_OIS1_Field use
     (B_0x0 => 0,
      B_0x1 => 1);

   --  Output idle state 1 (tim_oc1n output) 	
   type TIM1_CR2_OIS1N_Field is
     (--  tim_oc1n=0 after a dead-time when MOE=0
      B_0x0,
      --  tim_oc1n=1 after a dead-time when MOE=0
      B_0x1)
     with Size => 1;
   for TIM1_CR2_OIS1N_Field use
     (B_0x0 => 0,
      B_0x1 => 1);

   --  Master mode selection 2 	
   type TIM1_CR2_MMS2_Field is
     (--  Reset - the UG bit from the TIMx_EGR register is used as trigger output
--  (tim_trgo2).
      B_0x0,
      --  Enable - the Counter Enable signal CNT_EN is used as trigger output
--  (tim_trgo2).
      B_0x1,
      --  Update - the update event is selected as trigger output (tim_trgo2).
      B_0x2,
      --  Compare pulse - the trigger output sends a positive pulse when the CC1IF
--  flag is to be set (even if it was already high), as soon as a capture or
--  compare match occurs (tim_trgo2).
      B_0x3,
      --  Compare - tim_oc1refc signal is used as trigger output (tim_trgo2)
      B_0x4,
      --  Compare - tim_oc2refc signal is used as trigger output (tim_trgo2)
      B_0x5,
      --  Compare - tim_oc3refc signal is used as trigger output (tim_trgo2)
      B_0x6,
      --  Compare - tim_oc4refc signal is used as trigger output (tim_trgo2)
      B_0x7,
      --  Compare - tim_oc5refc signal is used as trigger output (tim_trgo2)
      B_0x8,
      --  Compare - tim_oc6refc signal is used as trigger output (tim_trgo2)
      B_0x9,
      --  Compare Pulse - tim_oc4refc rising or falling edges generate pulses on
--  tim_trgo2
      B_0xA,
      --  Compare pulse - tim_oc6refc rising or falling edges generate pulses on
--  tim_trgo2
      B_0xB,
      --  Compare pulse - tim_oc4refc or tim_oc6refc rising edges generate pulses on
--  tim_trgo2
      B_0xC,
      --  Compare pulse - tim_oc4refc rising or tim_oc6refc falling edges generate
--  pulses on tim_trgo2
      B_0xD,
      --  Compare pulse - tim_oc5refc or tim_oc6refc rising edges generate pulses on
--  tim_trgo2
      B_0xE,
      --  Compare pulse - tim_oc5refc rising or tim_oc6refc falling edges generate
--  pulses on tim_trgo2
      B_0xF)
     with Size => 4;
   for TIM1_CR2_MMS2_Field use
     (B_0x0 => 0,
      B_0x1 => 1,
      B_0x2 => 2,
      B_0x3 => 3,
      B_0x4 => 4,
      B_0x5 => 5,
      B_0x6 => 6,
      B_0x7 => 7,
      B_0x8 => 8,
      B_0x9 => 9,
      B_0xA => 10,
      B_0xB => 11,
      B_0xC => 12,
      B_0xD => 13,
      B_0xE => 14,
      B_0xF => 15);

   --  TIM1 control register 2
   type TIM1_CR2_Register is record
      --  Capture/compare preloaded control 	
      CCPC           : TIM1_CR2_CCPC_Field := STM32G4_SVD.TIM.B_0x0;
      --  unspecified
      Reserved_1_1   : STM32G4_SVD.Bit := 16#0#;
      --  Capture/compare control update selection 	
      CCUS           : TIM1_CR2_CCUS_Field := STM32G4_SVD.TIM.B_0x0;
      --  Capture/compare DMA selection
      CCDS           : TIM1_CR2_CCDS_Field := STM32G4_SVD.TIM.B_0x0;
      --  MMS[2:0]: Master mode selection 	
      MMS            : TIM1_CR2_MMS_Field := STM32G4_SVD.TIM.B_0x0;
      --  tim_ti1 selection
      TI1S           : TIM1_CR2_TI1S_Field := STM32G4_SVD.TIM.B_0x0;
      --  Output idle state 1 (tim_oc1 output) 	
      OIS1           : TIM1_CR2_OIS1_Field := STM32G4_SVD.TIM.B_0x0;
      --  Output idle state 1 (tim_oc1n output) 	
      OIS1N          : TIM1_CR2_OIS1N_Field := STM32G4_SVD.TIM.B_0x0;
      --  Output idle state 2 (tim_oc2 output) 	
      OIS2           : Boolean := False;
      --  Output idle state 2 (tim_oc2n output) 	
      OIS2N          : Boolean := False;
      --  Output idle state 3 (tim_oc3n output) 	
      OIS3           : Boolean := False;
      --  Output idle state 3 (tim_oc3n output) 	
      OIS3N          : Boolean := False;
      --  Output idle state 4 (tim_oc4 output) 	
      OIS4           : Boolean := False;
      --  Output idle state 4 (tim_oc4n output) 	
      OIS4N          : Boolean := False;
      --  Output idle state 5 (tim_oc5 output) 	
      OIS5           : Boolean := False;
      --  unspecified
      Reserved_17_17 : STM32G4_SVD.Bit := 16#0#;
      --  Output idle state 6 (tim_oc6 output) 	
      OIS6           : Boolean := False;
      --  unspecified
      Reserved_19_19 : STM32G4_SVD.Bit := 16#0#;
      --  Master mode selection 2 	
      MMS2           : TIM1_CR2_MMS2_Field := STM32G4_SVD.TIM.B_0x0;
      --  unspecified
      Reserved_24_24 : STM32G4_SVD.Bit := 16#0#;
      --  MMS[3]
      MMS_1          : Boolean := False;
      --  unspecified
      Reserved_26_31 : STM32G4_SVD.UInt6 := 16#0#;
   end record
     with Volatile_Full_Access, Object_Size => 32,
          Bit_Order => System.Low_Order_First;

   for TIM1_CR2_Register use record
      CCPC           at 0 range 0 .. 0;
      Reserved_1_1   at 0 range 1 .. 1;
      CCUS           at 0 range 2 .. 2;
      CCDS           at 0 range 3 .. 3;
      MMS            at 0 range 4 .. 6;
      TI1S           at 0 range 7 .. 7;
      OIS1           at 0 range 8 .. 8;
      OIS1N          at 0 range 9 .. 9;
      OIS2           at 0 range 10 .. 10;
      OIS2N          at 0 range 11 .. 11;
      OIS3           at 0 range 12 .. 12;
      OIS3N          at 0 range 13 .. 13;
      OIS4           at 0 range 14 .. 14;
      OIS4N          at 0 range 15 .. 15;
      OIS5           at 0 range 16 .. 16;
      Reserved_17_17 at 0 range 17 .. 17;
      OIS6           at 0 range 18 .. 18;
      Reserved_19_19 at 0 range 19 .. 19;
      MMS2           at 0 range 20 .. 23;
      Reserved_24_24 at 0 range 24 .. 24;
      MMS_1          at 0 range 25 .. 25;
      Reserved_26_31 at 0 range 26 .. 31;
   end record;

   --  SMS[2:0]: Slave mode selection 	
   type TIM1_SMCR_SMS_Field is
     (--  Slave mode disabled - if CEN = 1' then the prescaler is clocked directly by
--  the internal clock.
      B_0x0,
      --  Quadrature encoder mode 1, x2 mode- Counter counts up/down on tim_ti1fp1
--  edge depending on tim_ti2fp2 level.
      B_0x1,
      --  Quadrature encoder mode 2, x2 mode - Counter counts up/down on tim_ti2fp2
--  edge depending on tim_ti1fp1 level.
      B_0x2,
      --  Quadrature encoder mode 3, x4 mode - Counter counts up/down on both
--  tim_ti1fp1 and tim_ti2fp2 edges depending on the level of the other input.
      B_0x3,
      --  Reset Mode - Rising edge of the selected trigger input (tim_trgi)
--  reinitializes the counter and generates an update of the registers.
      B_0x4,
      --  Gated Mode - The counter clock is enabled when the trigger input (tim_trgi)
--  is high.
      B_0x5,
      --  Trigger Mode - The counter starts at a rising edge of the trigger tim_trgi
--  (but it is not reset).
      B_0x6,
      --  External Clock Mode 1 - Rising edges of the selected trigger (tim_trgi)
--  clock the counter.
      B_0x7)
     with Size => 3;
   for TIM1_SMCR_SMS_Field use
     (B_0x0 => 0,
      B_0x1 => 1,
      B_0x2 => 2,
      B_0x3 => 3,
      B_0x4 => 4,
      B_0x5 => 5,
      B_0x6 => 6,
      B_0x7 => 7);

   --  OCREF clear selection 	
   type TIM1_SMCR_OCCS_Field is
     (--  tim_ocref_clr_int is connected to the tim_ocref_clr input
      B_0x0,
      --  tim_ocref_clr_int is connected to tim_etrf
      B_0x1)
     with Size => 1;
   for TIM1_SMCR_OCCS_Field use
     (B_0x0 => 0,
      B_0x1 => 1);

   --  TS[2:0]: Trigger selection 	
   type TIM1_SMCR_TS_Field is
     (--  Internal Trigger 0 (tim_itr0)
      B_0x0,
      --  Internal Trigger 1 (tim_itr1)
      B_0x1,
      --  Internal Trigger 2 (tim_itr2)
      B_0x2,
      --  Internal Trigger 3 (tim_itr3)
      B_0x3,
      --  tim_ti1 Edge Detector (tim_ti1f_ed)
      B_0x4,
      --  Filtered Timer Input 1 (tim_ti1fp1)
      B_0x5,
      --  Filtered Timer Input 2 (tim_ti2fp2)
      B_0x6,
      --  External Trigger input (tim_etrf)
      B_0x7)
     with Size => 3;
   for TIM1_SMCR_TS_Field use
     (B_0x0 => 0,
      B_0x1 => 1,
      B_0x2 => 2,
      B_0x3 => 3,
      B_0x4 => 4,
      B_0x5 => 5,
      B_0x6 => 6,
      B_0x7 => 7);

   --  Master/slave mode
   type TIM1_SMCR_MSM_Field is
     (--  No action
      B_0x0,
      --  The effect of an event on the trigger input (tim_trgi) is delayed to allow
--  a perfect synchronization between the current timer and its slaves (through
--  tim_trgo).
      B_0x1)
     with Size => 1;
   for TIM1_SMCR_MSM_Field use
     (B_0x0 => 0,
      B_0x1 => 1);

   --  External trigger filter 	
   type TIM1_SMCR_ETF_Field is
     (--  No filter, sampling is done at fless thansub>DTSless than/sub>
      B_0x0,
      --  fless thansub>SAMPLINGless than/sub>=fless thansub>tim_ker_ckless
--  than/sub>, N=2
      B_0x1,
      --  fless thansub>SAMPLINGless than/sub>=fless thansub>tim_ker_ckless
--  than/sub>, N=4
      B_0x2,
      --  fless thansub>SAMPLINGless than/sub>=fless thansub>tim_ker_ckless
--  than/sub>, N=8
      B_0x3,
      --  fless thansub>SAMPLINGless than/sub>=fless thansub>DTSless than/sub>/2, N=6
      B_0x4,
      --  fless thansub>SAMPLINGless than/sub>=fless thansub>DTSless than/sub>/2, N=8
      B_0x5,
      --  fless thansub>SAMPLINGless than/sub>=fless thansub>DTSless than/sub>/4, N=6
      B_0x6,
      --  fless thansub>SAMPLINGless than/sub>=fless thansub>DTSless than/sub>/4, N=8
      B_0x7,
      --  fless thansub>SAMPLINGless than/sub>=fless thansub>DTSless than/sub>/8, N=6
      B_0x8,
      --  fless thansub>SAMPLINGless than/sub>=fless thansub>DTSless than/sub>/8, N=8
      B_0x9,
      --  fless thansub>SAMPLINGless than/sub>=fless thansub>DTSless than/sub>/16,
--  N=5
      B_0xA,
      --  fless thansub>SAMPLINGless than/sub>=fless thansub>DTSless than/sub>/16,
--  N=6
      B_0xB,
      --  fless thansub>SAMPLINGless than/sub>=fless thansub>DTSless than/sub>/16,
--  N=8
      B_0xC,
      --  fless thansub>SAMPLINGless than/sub>=fless thansub>DTSless than/sub>/32,
--  N=5
      B_0xD,
      --  fless thansub>SAMPLINGless than/sub>=fless thansub>DTSless than/sub>/32,
--  N=6
      B_0xE,
      --  fless thansub>SAMPLINGless than/sub>=fless thansub>DTSless than/sub>/32,
--  N=8
      B_0xF)
     with Size => 4;
   for TIM1_SMCR_ETF_Field use
     (B_0x0 => 0,
      B_0x1 => 1,
      B_0x2 => 2,
      B_0x3 => 3,
      B_0x4 => 4,
      B_0x5 => 5,
      B_0x6 => 6,
      B_0x7 => 7,
      B_0x8 => 8,
      B_0x9 => 9,
      B_0xA => 10,
      B_0xB => 11,
      B_0xC => 12,
      B_0xD => 13,
      B_0xE => 14,
      B_0xF => 15);

   --  External trigger prescaler 	
   type TIM1_SMCR_ETPS_Field is
     (--  Prescaler OFF
      B_0x0,
      --  tim_etr_in frequency divided by 2
      B_0x1,
      --  tim_etr_in frequency divided by 4
      B_0x2,
      --  tim_etr_in frequency divided by 8
      B_0x3)
     with Size => 2;
   for TIM1_SMCR_ETPS_Field use
     (B_0x0 => 0,
      B_0x1 => 1,
      B_0x2 => 2,
      B_0x3 => 3);

   --  External clock enable 	
   type TIM1_SMCR_ECE_Field is
     (--  External clock mode 2 disabled
      B_0x0,
      --  External clock mode 2 enabled.
      B_0x1)
     with Size => 1;
   for TIM1_SMCR_ECE_Field use
     (B_0x0 => 0,
      B_0x1 => 1);

   --  External trigger polarity 	
   type TIM1_SMCR_ETP_Field is
     (--  tim_etr_in is non-inverted, active at high level or rising edge.
      B_0x0,
      --  tim_etr_in is inverted, active at low level or falling edge.
      B_0x1)
     with Size => 1;
   for TIM1_SMCR_ETP_Field use
     (B_0x0 => 0,
      B_0x1 => 1);

   subtype TIM1_SMCR_TS_1_Field is STM32G4_SVD.UInt2;

   --  SMS preload enable 	
   type TIM1_SMCR_SMSPE_Field is
     (--  SMS[3:0] bitfield is not preloaded
      B_0x0,
      --  SMS[3:0] preload is enabled
      B_0x1)
     with Size => 1;
   for TIM1_SMCR_SMSPE_Field use
     (B_0x0 => 0,
      B_0x1 => 1);

   --  SMS preload source 	
   type TIM1_SMCR_SMSPS_Field is
     (--  The transfer is triggered by the Timer's Update event
      B_0x0,
      --  The transfer is triggered by the Index event
      B_0x1)
     with Size => 1;
   for TIM1_SMCR_SMSPS_Field use
     (B_0x0 => 0,
      B_0x1 => 1);

   --  TIM1 slave mode control register
   type TIM1_SMCR_Register is record
      --  SMS[2:0]: Slave mode selection 	
      SMS            : TIM1_SMCR_SMS_Field := STM32G4_SVD.TIM.B_0x0;
      --  OCREF clear selection 	
      OCCS           : TIM1_SMCR_OCCS_Field := STM32G4_SVD.TIM.B_0x0;
      --  TS[2:0]: Trigger selection 	
      TS             : TIM1_SMCR_TS_Field := STM32G4_SVD.TIM.B_0x0;
      --  Master/slave mode
      MSM            : TIM1_SMCR_MSM_Field := STM32G4_SVD.TIM.B_0x0;
      --  External trigger filter 	
      ETF            : TIM1_SMCR_ETF_Field := STM32G4_SVD.TIM.B_0x0;
      --  External trigger prescaler 	
      ETPS           : TIM1_SMCR_ETPS_Field := STM32G4_SVD.TIM.B_0x0;
      --  External clock enable 	
      ECE            : TIM1_SMCR_ECE_Field := STM32G4_SVD.TIM.B_0x0;
      --  External trigger polarity 	
      ETP            : TIM1_SMCR_ETP_Field := STM32G4_SVD.TIM.B_0x0;
      --  SMS[3]
      SMS_1          : Boolean := False;
      --  unspecified
      Reserved_17_19 : STM32G4_SVD.UInt3 := 16#0#;
      --  TS[4:3]
      TS_1           : TIM1_SMCR_TS_1_Field := 16#0#;
      --  unspecified
      Reserved_22_23 : STM32G4_SVD.UInt2 := 16#0#;
      --  SMS preload enable 	
      SMSPE          : TIM1_SMCR_SMSPE_Field := STM32G4_SVD.TIM.B_0x0;
      --  SMS preload source 	
      SMSPS          : TIM1_SMCR_SMSPS_Field := STM32G4_SVD.TIM.B_0x0;
      --  unspecified
      Reserved_26_31 : STM32G4_SVD.UInt6 := 16#0#;
   end record
     with Volatile_Full_Access, Object_Size => 32,
          Bit_Order => System.Low_Order_First;

   for TIM1_SMCR_Register use record
      SMS            at 0 range 0 .. 2;
      OCCS           at 0 range 3 .. 3;
      TS             at 0 range 4 .. 6;
      MSM            at 0 range 7 .. 7;
      ETF            at 0 range 8 .. 11;
      ETPS           at 0 range 12 .. 13;
      ECE            at 0 range 14 .. 14;
      ETP            at 0 range 15 .. 15;
      SMS_1          at 0 range 16 .. 16;
      Reserved_17_19 at 0 range 17 .. 19;
      TS_1           at 0 range 20 .. 21;
      Reserved_22_23 at 0 range 22 .. 23;
      SMSPE          at 0 range 24 .. 24;
      SMSPS          at 0 range 25 .. 25;
      Reserved_26_31 at 0 range 26 .. 31;
   end record;

   --  Update interrupt enable
   type TIM1_DIER_UIE_Field is
     (--  Update interrupt disabled
      B_0x0,
      --  Update interrupt enabled
      B_0x1)
     with Size => 1;
   for TIM1_DIER_UIE_Field use
     (B_0x0 => 0,
      B_0x1 => 1);

   --  Capture/compare 1 interrupt enable
   type TIM1_DIER_CC1IE_Field is
     (--  CC1 interrupt disabled
      B_0x0,
      --  CC1 interrupt enabled
      B_0x1)
     with Size => 1;
   for TIM1_DIER_CC1IE_Field use
     (B_0x0 => 0,
      B_0x1 => 1);

   --  Capture/compare 2 interrupt enable
   type TIM1_DIER_CC2IE_Field is
     (--  CC2 interrupt disabled
      B_0x0,
      --  CC2 interrupt enabled
      B_0x1)
     with Size => 1;
   for TIM1_DIER_CC2IE_Field use
     (B_0x0 => 0,
      B_0x1 => 1);

   --  Capture/compare 3 interrupt enable
   type TIM1_DIER_CC3IE_Field is
     (--  CC3 interrupt disabled
      B_0x0,
      --  CC3 interrupt enabled
      B_0x1)
     with Size => 1;
   for TIM1_DIER_CC3IE_Field use
     (B_0x0 => 0,
      B_0x1 => 1);

   --  Capture/compare 4 interrupt enable
   type TIM1_DIER_CC4IE_Field is
     (--  CC4 interrupt disabled
      B_0x0,
      --  CC4 interrupt enabled
      B_0x1)
     with Size => 1;
   for TIM1_DIER_CC4IE_Field use
     (B_0x0 => 0,
      B_0x1 => 1);

   --  COM interrupt enable
   type TIM1_DIER_COMIE_Field is
     (--  COM interrupt disabled
      B_0x0,
      --  COM interrupt enabled
      B_0x1)
     with Size => 1;
   for TIM1_DIER_COMIE_Field use
     (B_0x0 => 0,
      B_0x1 => 1);

   --  Trigger interrupt enable
   type TIM1_DIER_TIE_Field is
     (--  Trigger interrupt disabled
      B_0x0,
      --  Trigger interrupt enabled
      B_0x1)
     with Size => 1;
   for TIM1_DIER_TIE_Field use
     (B_0x0 => 0,
      B_0x1 => 1);

   --  Break interrupt enable
   type TIM1_DIER_BIE_Field is
     (--  Break interrupt disabled
      B_0x0,
      --  Break interrupt enabled
      B_0x1)
     with Size => 1;
   for TIM1_DIER_BIE_Field use
     (B_0x0 => 0,
      B_0x1 => 1);

   --  Update DMA request enable
   type TIM1_DIER_UDE_Field is
     (--  Update DMA request disabled
      B_0x0,
      --  Update DMA request enabled
      B_0x1)
     with Size => 1;
   for TIM1_DIER_UDE_Field use
     (B_0x0 => 0,
      B_0x1 => 1);

   --  Capture/compare 1 DMA request enable
   type TIM1_DIER_CC1DE_Field is
     (--  CC1 DMA request disabled
      B_0x0,
      --  CC1 DMA request enabled
      B_0x1)
     with Size => 1;
   for TIM1_DIER_CC1DE_Field use
     (B_0x0 => 0,
      B_0x1 => 1);

   --  Capture/compare 2 DMA request enable
   type TIM1_DIER_CC2DE_Field is
     (--  CC2 DMA request disabled
      B_0x0,
      --  CC2 DMA request enabled
      B_0x1)
     with Size => 1;
   for TIM1_DIER_CC2DE_Field use
     (B_0x0 => 0,
      B_0x1 => 1);

   --  Capture/compare 3 DMA request enable
   type TIM1_DIER_CC3DE_Field is
     (--  CC3 DMA request disabled
      B_0x0,
      --  CC3 DMA request enabled
      B_0x1)
     with Size => 1;
   for TIM1_DIER_CC3DE_Field use
     (B_0x0 => 0,
      B_0x1 => 1);

   --  Capture/compare 4 DMA request enable
   type TIM1_DIER_CC4DE_Field is
     (--  CC4 DMA request disabled
      B_0x0,
      --  CC4 DMA request enabled
      B_0x1)
     with Size => 1;
   for TIM1_DIER_CC4DE_Field use
     (B_0x0 => 0,
      B_0x1 => 1);

   --  COM DMA request enable
   type TIM1_DIER_COMDE_Field is
     (--  COM DMA request disabled
      B_0x0,
      --  COM DMA request enabled
      B_0x1)
     with Size => 1;
   for TIM1_DIER_COMDE_Field use
     (B_0x0 => 0,
      B_0x1 => 1);

   --  Trigger DMA request enable
   type TIM1_DIER_TDE_Field is
     (--  Trigger DMA request disabled
      B_0x0,
      --  Trigger DMA request enabled
      B_0x1)
     with Size => 1;
   for TIM1_DIER_TDE_Field use
     (B_0x0 => 0,
      B_0x1 => 1);

   --  Index interrupt enable
   type TIM1_DIER_IDXIE_Field is
     (--  Index interrupt disabled
      B_0x0,
      --  Index Change interrupt enabled
      B_0x1)
     with Size => 1;
   for TIM1_DIER_IDXIE_Field use
     (B_0x0 => 0,
      B_0x1 => 1);

   --  Direction change interrupt enable
   type TIM1_DIER_DIRIE_Field is
     (--  Direction Change interrupt disabled
      B_0x0,
      --  Direction Change interrupt enabled
      B_0x1)
     with Size => 1;
   for TIM1_DIER_DIRIE_Field use
     (B_0x0 => 0,
      B_0x1 => 1);

   --  Index error interrupt enable
   type TIM1_DIER_IERRIE_Field is
     (--  Index error interrupt disabled
      B_0x0,
      --  Index error interrupt enabled
      B_0x1)
     with Size => 1;
   for TIM1_DIER_IERRIE_Field use
     (B_0x0 => 0,
      B_0x1 => 1);

   --  Transition error interrupt enable
   type TIM1_DIER_TERRIE_Field is
     (--  Transition error interrupt disabled
      B_0x0,
      --  Transition error interrupt enabled
      B_0x1)
     with Size => 1;
   for TIM1_DIER_TERRIE_Field use
     (B_0x0 => 0,
      B_0x1 => 1);

   --  TIM1 DMA/interrupt enable register
   type TIM1_DIER_Register is record
      --  Update interrupt enable
      UIE            : TIM1_DIER_UIE_Field := STM32G4_SVD.TIM.B_0x0;
      --  Capture/compare 1 interrupt enable
      CC1IE          : TIM1_DIER_CC1IE_Field := STM32G4_SVD.TIM.B_0x0;
      --  Capture/compare 2 interrupt enable
      CC2IE          : TIM1_DIER_CC2IE_Field := STM32G4_SVD.TIM.B_0x0;
      --  Capture/compare 3 interrupt enable
      CC3IE          : TIM1_DIER_CC3IE_Field := STM32G4_SVD.TIM.B_0x0;
      --  Capture/compare 4 interrupt enable
      CC4IE          : TIM1_DIER_CC4IE_Field := STM32G4_SVD.TIM.B_0x0;
      --  COM interrupt enable
      COMIE          : TIM1_DIER_COMIE_Field := STM32G4_SVD.TIM.B_0x0;
      --  Trigger interrupt enable
      TIE            : TIM1_DIER_TIE_Field := STM32G4_SVD.TIM.B_0x0;
      --  Break interrupt enable
      BIE            : TIM1_DIER_BIE_Field := STM32G4_SVD.TIM.B_0x0;
      --  Update DMA request enable
      UDE            : TIM1_DIER_UDE_Field := STM32G4_SVD.TIM.B_0x0;
      --  Capture/compare 1 DMA request enable
      CC1DE          : TIM1_DIER_CC1DE_Field := STM32G4_SVD.TIM.B_0x0;
      --  Capture/compare 2 DMA request enable
      CC2DE          : TIM1_DIER_CC2DE_Field := STM32G4_SVD.TIM.B_0x0;
      --  Capture/compare 3 DMA request enable
      CC3DE          : TIM1_DIER_CC3DE_Field := STM32G4_SVD.TIM.B_0x0;
      --  Capture/compare 4 DMA request enable
      CC4DE          : TIM1_DIER_CC4DE_Field := STM32G4_SVD.TIM.B_0x0;
      --  COM DMA request enable
      COMDE          : TIM1_DIER_COMDE_Field := STM32G4_SVD.TIM.B_0x0;
      --  Trigger DMA request enable
      TDE            : TIM1_DIER_TDE_Field := STM32G4_SVD.TIM.B_0x0;
      --  unspecified
      Reserved_15_19 : STM32G4_SVD.UInt5 := 16#0#;
      --  Index interrupt enable
      IDXIE          : TIM1_DIER_IDXIE_Field := STM32G4_SVD.TIM.B_0x0;
      --  Direction change interrupt enable
      DIRIE          : TIM1_DIER_DIRIE_Field := STM32G4_SVD.TIM.B_0x0;
      --  Index error interrupt enable
      IERRIE         : TIM1_DIER_IERRIE_Field := STM32G4_SVD.TIM.B_0x0;
      --  Transition error interrupt enable
      TERRIE         : TIM1_DIER_TERRIE_Field := STM32G4_SVD.TIM.B_0x0;
      --  unspecified
      Reserved_24_31 : STM32G4_SVD.Byte := 16#0#;
   end record
     with Volatile_Full_Access, Object_Size => 32,
          Bit_Order => System.Low_Order_First;

   for TIM1_DIER_Register use record
      UIE            at 0 range 0 .. 0;
      CC1IE          at 0 range 1 .. 1;
      CC2IE          at 0 range 2 .. 2;
      CC3IE          at 0 range 3 .. 3;
      CC4IE          at 0 range 4 .. 4;
      COMIE          at 0 range 5 .. 5;
      TIE            at 0 range 6 .. 6;
      BIE            at 0 range 7 .. 7;
      UDE            at 0 range 8 .. 8;
      CC1DE          at 0 range 9 .. 9;
      CC2DE          at 0 range 10 .. 10;
      CC3DE          at 0 range 11 .. 11;
      CC4DE          at 0 range 12 .. 12;
      COMDE          at 0 range 13 .. 13;
      TDE            at 0 range 14 .. 14;
      Reserved_15_19 at 0 range 15 .. 19;
      IDXIE          at 0 range 20 .. 20;
      DIRIE          at 0 range 21 .. 21;
      IERRIE         at 0 range 22 .. 22;
      TERRIE         at 0 range 23 .. 23;
      Reserved_24_31 at 0 range 24 .. 31;
   end record;

   --  Update interrupt flag 	
   type TIM1_SR_UIF_Field is
     (--  No update occurred.
      B_0x0,
      --  Update interrupt pending.
      B_0x1)
     with Size => 1;
   for TIM1_SR_UIF_Field use
     (B_0x0 => 0,
      B_0x1 => 1);

   --  Capture/compare 1 interrupt flag 	
   type TIM1_SR_CC1IF_Field is
     (--  No compare match / No input capture occurred
      B_0x0,
      --  A compare match or an input capture occurred
      B_0x1)
     with Size => 1;
   for TIM1_SR_CC1IF_Field use
     (B_0x0 => 0,
      B_0x1 => 1);

   --  COM interrupt flag 	
   type TIM1_SR_COMIF_Field is
     (--  No COM event occurred.
      B_0x0,
      --  COM interrupt pending.
      B_0x1)
     with Size => 1;
   for TIM1_SR_COMIF_Field use
     (B_0x0 => 0,
      B_0x1 => 1);

   --  Trigger interrupt flag 	
   type TIM1_SR_TIF_Field is
     (--  No trigger event occurred.
      B_0x0,
      --  Trigger interrupt pending.
      B_0x1)
     with Size => 1;
   for TIM1_SR_TIF_Field use
     (B_0x0 => 0,
      B_0x1 => 1);

   --  Break interrupt flag 	
   type TIM1_SR_BIF_Field is
     (--  No break event occurred.
      B_0x0,
      --  An active level has been detected on the break input.
      B_0x1)
     with Size => 1;
   for TIM1_SR_BIF_Field use
     (B_0x0 => 0,
      B_0x1 => 1);

   --  Break 2 interrupt flag 	
   type TIM1_SR_B2IF_Field is
     (--  No break event occurred.
      B_0x0,
      --  An active level has been detected on the break 2 input.
      B_0x1)
     with Size => 1;
   for TIM1_SR_B2IF_Field use
     (B_0x0 => 0,
      B_0x1 => 1);

   --  Capture/compare 1 overcapture flag 	
   type TIM1_SR_CC1OF_Field is
     (--  No overcapture has been detected.
      B_0x0,
      --  The counter value has been captured in TIMx_CCR1 register while CC1IF flag
--  was already set
      B_0x1)
     with Size => 1;
   for TIM1_SR_CC1OF_Field use
     (B_0x0 => 0,
      B_0x1 => 1);

   --  System break interrupt flag 	
   type TIM1_SR_SBIF_Field is
     (--  No break event occurred.
      B_0x0,
      --  An active level has been detected on the system break input.
      B_0x1)
     with Size => 1;
   for TIM1_SR_SBIF_Field use
     (B_0x0 => 0,
      B_0x1 => 1);

   --  Index interrupt flag 	
   type TIM1_SR_IDXF_Field is
     (--  No index event occurred.
      B_0x0,
      --  An index event has occurred
      B_0x1)
     with Size => 1;
   for TIM1_SR_IDXF_Field use
     (B_0x0 => 0,
      B_0x1 => 1);

   --  Direction change interrupt flag 	
   type TIM1_SR_DIRF_Field is
     (--  No direction change
      B_0x0,
      --  Direction change
      B_0x1)
     with Size => 1;
   for TIM1_SR_DIRF_Field use
     (B_0x0 => 0,
      B_0x1 => 1);

   --  Index error interrupt flag 	
   type TIM1_SR_IERRF_Field is
     (--  No index error has been detected.
      B_0x0,
      --  An index error has been detected
      B_0x1)
     with Size => 1;
   for TIM1_SR_IERRF_Field use
     (B_0x0 => 0,
      B_0x1 => 1);

   --  Transition error interrupt flag 	
   type TIM1_SR_TERRF_Field is
     (--  No encoder transition error has been detected.
      B_0x0,
      --  An encoder transition error has been detected
      B_0x1)
     with Size => 1;
   for TIM1_SR_TERRF_Field use
     (B_0x0 => 0,
      B_0x1 => 1);

   --  TIM1 status register
   type TIM1_SR_Register is record
      --  Update interrupt flag 	
      UIF            : TIM1_SR_UIF_Field := STM32G4_SVD.TIM.B_0x0;
      --  Capture/compare 1 interrupt flag 	
      CC1IF          : TIM1_SR_CC1IF_Field := STM32G4_SVD.TIM.B_0x0;
      --  Capture/compare 2 interrupt flag 	
      CC2IF          : Boolean := False;
      --  Capture/compare 3 interrupt flag 	
      CC3IF          : Boolean := False;
      --  Capture/compare 4 interrupt flag 	
      CC4IF          : Boolean := False;
      --  COM interrupt flag 	
      COMIF          : TIM1_SR_COMIF_Field := STM32G4_SVD.TIM.B_0x0;
      --  Trigger interrupt flag 	
      TIF            : TIM1_SR_TIF_Field := STM32G4_SVD.TIM.B_0x0;
      --  Break interrupt flag 	
      BIF            : TIM1_SR_BIF_Field := STM32G4_SVD.TIM.B_0x0;
      --  Break 2 interrupt flag 	
      B2IF           : TIM1_SR_B2IF_Field := STM32G4_SVD.TIM.B_0x0;
      --  Capture/compare 1 overcapture flag 	
      CC1OF          : TIM1_SR_CC1OF_Field := STM32G4_SVD.TIM.B_0x0;
      --  Capture/compare 2 overcapture flag 	
      CC2OF          : Boolean := False;
      --  Capture/compare 3 overcapture flag 	
      CC3OF          : Boolean := False;
      --  Capture/compare 4 overcapture flag 	
      CC4OF          : Boolean := False;
      --  System break interrupt flag 	
      SBIF           : TIM1_SR_SBIF_Field := STM32G4_SVD.TIM.B_0x0;
      --  unspecified
      Reserved_14_15 : STM32G4_SVD.UInt2 := 16#0#;
      --  Compare 5 interrupt flag 	
      CC5IF          : Boolean := False;
      --  Compare 6 interrupt flag 	
      CC6IF          : Boolean := False;
      --  unspecified
      Reserved_18_19 : STM32G4_SVD.UInt2 := 16#0#;
      --  Index interrupt flag 	
      IDXF           : TIM1_SR_IDXF_Field := STM32G4_SVD.TIM.B_0x0;
      --  Direction change interrupt flag 	
      DIRF           : TIM1_SR_DIRF_Field := STM32G4_SVD.TIM.B_0x0;
      --  Index error interrupt flag 	
      IERRF          : TIM1_SR_IERRF_Field := STM32G4_SVD.TIM.B_0x0;
      --  Transition error interrupt flag 	
      TERRF          : TIM1_SR_TERRF_Field := STM32G4_SVD.TIM.B_0x0;
      --  unspecified
      Reserved_24_31 : STM32G4_SVD.Byte := 16#0#;
   end record
     with Volatile_Full_Access, Object_Size => 32,
          Bit_Order => System.Low_Order_First;

   for TIM1_SR_Register use record
      UIF            at 0 range 0 .. 0;
      CC1IF          at 0 range 1 .. 1;
      CC2IF          at 0 range 2 .. 2;
      CC3IF          at 0 range 3 .. 3;
      CC4IF          at 0 range 4 .. 4;
      COMIF          at 0 range 5 .. 5;
      TIF            at 0 range 6 .. 6;
      BIF            at 0 range 7 .. 7;
      B2IF           at 0 range 8 .. 8;
      CC1OF          at 0 range 9 .. 9;
      CC2OF          at 0 range 10 .. 10;
      CC3OF          at 0 range 11 .. 11;
      CC4OF          at 0 range 12 .. 12;
      SBIF           at 0 range 13 .. 13;
      Reserved_14_15 at 0 range 14 .. 15;
      CC5IF          at 0 range 16 .. 16;
      CC6IF          at 0 range 17 .. 17;
      Reserved_18_19 at 0 range 18 .. 19;
      IDXF           at 0 range 20 .. 20;
      DIRF           at 0 range 21 .. 21;
      IERRF          at 0 range 22 .. 22;
      TERRF          at 0 range 23 .. 23;
      Reserved_24_31 at 0 range 24 .. 31;
   end record;

   --  Update generation 	
   type TIM1_EGR_UG_Field is
     (--  No action
      B_0x0,
      --  Reinitialize the counter and generates an update of the registers.
      B_0x1)
     with Size => 1;
   for TIM1_EGR_UG_Field use
     (B_0x0 => 0,
      B_0x1 => 1);

   --  Capture/compare 1 generation 	
   type TIM1_EGR_CC1G_Field is
     (--  No action
      B_0x0,
      --  A capture/compare event is generated on channel 1:
      B_0x1)
     with Size => 1;
   for TIM1_EGR_CC1G_Field use
     (B_0x0 => 0,
      B_0x1 => 1);

   --  Capture/compare control update generation 	
   type TIM1_EGR_COMG_Field is
     (--  No action
      B_0x0,
      --  When CCPC bit is set, it allows to update CCxE, CCxNE and OCxM bits
      B_0x1)
     with Size => 1;
   for TIM1_EGR_COMG_Field use
     (B_0x0 => 0,
      B_0x1 => 1);

   --  Trigger generation 	
   type TIM1_EGR_TG_Field is
     (--  No action
      B_0x0,
      --  The TIF flag is set in TIMx_SR register.
      B_0x1)
     with Size => 1;
   for TIM1_EGR_TG_Field use
     (B_0x0 => 0,
      B_0x1 => 1);

   --  Break generation 	
   type TIM1_EGR_BG_Field is
     (--  No action
      B_0x0,
      --  A break event is generated.
      B_0x1)
     with Size => 1;
   for TIM1_EGR_BG_Field use
     (B_0x0 => 0,
      B_0x1 => 1);

   --  Break 2 generation 	
   type TIM1_EGR_B2G_Field is
     (--  No action
      B_0x0,
      --  A break 2 event is generated.
      B_0x1)
     with Size => 1;
   for TIM1_EGR_B2G_Field use
     (B_0x0 => 0,
      B_0x1 => 1);

   --  TIM1 event generation register
   type TIM1_EGR_Register is record
      --  Write-only. Update generation 	
      UG            : TIM1_EGR_UG_Field := STM32G4_SVD.TIM.B_0x0;
      --  Write-only. Capture/compare 1 generation 	
      CC1G          : TIM1_EGR_CC1G_Field := STM32G4_SVD.TIM.B_0x0;
      --  Write-only. Capture/compare 2 generation 	
      CC2G          : Boolean := False;
      --  Write-only. Capture/compare 3 generation 	
      CC3G          : Boolean := False;
      --  Write-only. Capture/compare 4 generation 	
      CC4G          : Boolean := False;
      --  Write-only. Capture/compare control update generation 	
      COMG          : TIM1_EGR_COMG_Field := STM32G4_SVD.TIM.B_0x0;
      --  Write-only. Trigger generation 	
      TG            : TIM1_EGR_TG_Field := STM32G4_SVD.TIM.B_0x0;
      --  Write-only. Break generation 	
      BG            : TIM1_EGR_BG_Field := STM32G4_SVD.TIM.B_0x0;
      --  Write-only. Break 2 generation 	
      B2G           : TIM1_EGR_B2G_Field := STM32G4_SVD.TIM.B_0x0;
      --  unspecified
      Reserved_9_15 : STM32G4_SVD.UInt7 := 16#0#;
   end record
     with Volatile_Full_Access, Object_Size => 16,
          Bit_Order => System.Low_Order_First;

   for TIM1_EGR_Register use record
      UG            at 0 range 0 .. 0;
      CC1G          at 0 range 1 .. 1;
      CC2G          at 0 range 2 .. 2;
      CC3G          at 0 range 3 .. 3;
      CC4G          at 0 range 4 .. 4;
      COMG          at 0 range 5 .. 5;
      TG            at 0 range 6 .. 6;
      BG            at 0 range 7 .. 7;
      B2G           at 0 range 8 .. 8;
      Reserved_9_15 at 0 range 9 .. 15;
   end record;

   --  Capture/compare 1 Selection 	
   type TIM1_CCMR1_CC1S_Field is
     (--  CC1 channel is configured as output
      B_0x0,
      --  CC1 channel is configured as input, tim_ic1 is mapped on tim_ti1
      B_0x1,
      --  CC1 channel is configured as input, tim_ic1 is mapped on tim_ti2
      B_0x2,
      --  CC1 channel is configured as input, tim_ic1 is mapped on tim_trc.
      B_0x3)
     with Size => 2;
   for TIM1_CCMR1_CC1S_Field use
     (B_0x0 => 0,
      B_0x1 => 1,
      B_0x2 => 2,
      B_0x3 => 3);

   --  Input capture 1 prescaler 	
   type TIM1_CCMR1_IC1PSC_Field is
     (--  no prescaler, capture is done each time an edge is detected on the capture
--  input
      B_0x0,
      --  capture is done once every 2 events
      B_0x1,
      --  capture is done once every 4 events
      B_0x2,
      --  capture is done once every 8 events
      B_0x3)
     with Size => 2;
   for TIM1_CCMR1_IC1PSC_Field use
     (B_0x0 => 0,
      B_0x1 => 1,
      B_0x2 => 2,
      B_0x3 => 3);

   --  Input capture 1 filter 	
   type TIM1_CCMR1_IC1F_Field is
     (--  No filter, sampling is done at fless thansub>DTSless than/sub>
      B_0x0,
      --  fless thansub>SAMPLINGless than/sub>=fless thansub>tim_ker_ckless
--  than/sub>, N=2
      B_0x1,
      --  fless thansub>SAMPLINGless than/sub>=fless thansub>tim_ker_ckless
--  than/sub>, N=4
      B_0x2,
      --  fless thansub>SAMPLINGless than/sub>=fless thansub>tim_ker_ckless
--  than/sub>, N=8
      B_0x3,
      --  fless thansub>SAMPLINGless than/sub>=fless thansub>DTSless than/sub>/2, N=6
      B_0x4,
      --  fless thansub>SAMPLINGless than/sub>=fless thansub>DTSless than/sub>/2, N=8
      B_0x5,
      --  fless thansub>SAMPLINGless than/sub>=fless thansub>DTSless than/sub>/4, N=6
      B_0x6,
      --  fless thansub>SAMPLINGless than/sub>=fless thansub>DTSless than/sub>/4, N=8
      B_0x7,
      --  fless thansub>SAMPLINGless than/sub>=fless thansub>DTSless than/sub>/8, N=6
      B_0x8,
      --  fless thansub>SAMPLINGless than/sub>=fless thansub>DTSless than/sub>/8, N=8
      B_0x9,
      --  fless thansub>SAMPLINGless than/sub>=fless thansub>DTSless than/sub>/16,
--  N=5
      B_0xA,
      --  fless thansub>SAMPLINGless than/sub>=fless thansub>DTSless than/sub>/16,
--  N=6
      B_0xB,
      --  fless thansub>SAMPLINGless than/sub>=fless thansub>DTSless than/sub>/16,
--  N=8
      B_0xC,
      --  fless thansub>SAMPLINGless than/sub>=fless thansub>DTSless than/sub>/32,
--  N=5
      B_0xD,
      --  fless thansub>SAMPLINGless than/sub>=fless thansub>DTSless than/sub>/32,
--  N=6
      B_0xE,
      --  fless thansub>SAMPLINGless than/sub>=fless thansub>DTSless than/sub>/32,
--  N=8
      B_0xF)
     with Size => 4;
   for TIM1_CCMR1_IC1F_Field use
     (B_0x0 => 0,
      B_0x1 => 1,
      B_0x2 => 2,
      B_0x3 => 3,
      B_0x4 => 4,
      B_0x5 => 5,
      B_0x6 => 6,
      B_0x7 => 7,
      B_0x8 => 8,
      B_0x9 => 9,
      B_0xA => 10,
      B_0xB => 11,
      B_0xC => 12,
      B_0xD => 13,
      B_0xE => 14,
      B_0xF => 15);

   --  Capture/compare 2 selection 	
   type TIM1_CCMR1_CC2S_Field is
     (--  CC2 channel is configured as output
      B_0x0,
      --  CC2 channel is configured as input, tim_ic2 is mapped on tim_ti2
      B_0x1,
      --  CC2 channel is configured as input, tim_ic2 is mapped on tim_ti1
      B_0x2,
      --  CC2 channel is configured as input, tim_ic2 is mapped on tim_trc.
      B_0x3)
     with Size => 2;
   for TIM1_CCMR1_CC2S_Field use
     (B_0x0 => 0,
      B_0x1 => 1,
      B_0x2 => 2,
      B_0x3 => 3);

   subtype TIM1_CCMR1_IC2PSC_Field is STM32G4_SVD.UInt2;
   subtype TIM1_CCMR1_IC2F_Field is STM32G4_SVD.UInt4;

   --  TIM1 capture/compare mode register 1 [alternate]
   type TIM1_CCMR1_Register is record
      --  Capture/compare 1 Selection 	
      CC1S           : TIM1_CCMR1_CC1S_Field := STM32G4_SVD.TIM.B_0x0;
      --  Input capture 1 prescaler 	
      IC1PSC         : TIM1_CCMR1_IC1PSC_Field := STM32G4_SVD.TIM.B_0x0;
      --  Input capture 1 filter 	
      IC1F           : TIM1_CCMR1_IC1F_Field := STM32G4_SVD.TIM.B_0x0;
      --  Capture/compare 2 selection 	
      CC2S           : TIM1_CCMR1_CC2S_Field := STM32G4_SVD.TIM.B_0x0;
      --  Input capture 2 prescaler
      IC2PSC         : TIM1_CCMR1_IC2PSC_Field := 16#0#;
      --  Input capture 2 filter
      IC2F           : TIM1_CCMR1_IC2F_Field := 16#0#;
      --  unspecified
      Reserved_16_31 : STM32G4_SVD.UInt16 := 16#0#;
   end record
     with Volatile_Full_Access, Object_Size => 32,
          Bit_Order => System.Low_Order_First;

   for TIM1_CCMR1_Register use record
      CC1S           at 0 range 0 .. 1;
      IC1PSC         at 0 range 2 .. 3;
      IC1F           at 0 range 4 .. 7;
      CC2S           at 0 range 8 .. 9;
      IC2PSC         at 0 range 10 .. 11;
      IC2F           at 0 range 12 .. 15;
      Reserved_16_31 at 0 range 16 .. 31;
   end record;

   --  Capture/compare 1 selection 	
   type TIM1_CCMR1_Alternate_CC1S_Field is
     (--  CC1 channel is configured as output
      B_0x0,
      --  CC1 channel is configured as input, tim_ic1 is mapped on tim_ti1
      B_0x1,
      --  CC1 channel is configured as input, tim_ic1 is mapped on tim_ti2
      B_0x2,
      --  CC1 channel is configured as input, tim_ic1 is mapped on tim_trc.
      B_0x3)
     with Size => 2;
   for TIM1_CCMR1_Alternate_CC1S_Field use
     (B_0x0 => 0,
      B_0x1 => 1,
      B_0x2 => 2,
      B_0x3 => 3);

   --  Output compare 1 fast enable 	
   type TIM1_CCMR1_Alternate_OC1FE_Field is
     (--  CC1 behaves normally depending on counter and CCR1 values even when the
--  trigger is ON.
      B_0x0,
      --  An active edge on the trigger input acts like a compare match on CC1
--  output.
      B_0x1)
     with Size => 1;
   for TIM1_CCMR1_Alternate_OC1FE_Field use
     (B_0x0 => 0,
      B_0x1 => 1);

   --  Output compare 1 preload enable 	
   type TIM1_CCMR1_Alternate_OC1PE_Field is
     (--  Preload register on TIMx_CCR1 disabled.
      B_0x0,
      --  Preload register on TIMx_CCR1 enabled.
      B_0x1)
     with Size => 1;
   for TIM1_CCMR1_Alternate_OC1PE_Field use
     (B_0x0 => 0,
      B_0x1 => 1);

   --  OC1M[2:0]: Output compare 1 mode 	
   type TIM1_CCMR1_Alternate_OC1M_Field is
     (--  Frozen - The comparison between the output compare register TIMx_CCR1 and
--  the counter TIMx_CNT has no effect on the outputs.
      B_0x0,
      --  Set channel 1 to active level on match.
      B_0x1,
      --  Set channel 1 to inactive level on match.
      B_0x2,
      --  Toggle - tim_oc1ref toggles when TIMx_CNT=TIMx_CCR1.
      B_0x3,
      --  Force inactive level - tim_oc1ref is forced low.
      B_0x4,
      --  Force active level - tim_oc1ref is forced high.
      B_0x5,
      --  PWM mode 1 - In upcounting, channel 1 is active as long as TIMx_CNTless
--  thanTIMx_CCR1 else inactive.
      B_0x6,
      --  PWM mode 2 - In upcounting, channel 1 is inactive as long as TIMx_CNTless
--  thanTIMx_CCR1 else active.
      B_0x7)
     with Size => 3;
   for TIM1_CCMR1_Alternate_OC1M_Field use
     (B_0x0 => 0,
      B_0x1 => 1,
      B_0x2 => 2,
      B_0x3 => 3,
      B_0x4 => 4,
      B_0x5 => 5,
      B_0x6 => 6,
      B_0x7 => 7);

   --  Output compare 1 clear enable
   type TIM1_CCMR1_Alternate_OC1CE_Field is
     (--  tim_oc1ref is not affected by the tim_ocref_clr_int signal
      B_0x0,
      --  tim_oc1ref is cleared as soon as a High level is detected on
--  tim_ocref_clr_int signal (tim_ocref_clr input or tim_etrf input)
      B_0x1)
     with Size => 1;
   for TIM1_CCMR1_Alternate_OC1CE_Field use
     (B_0x0 => 0,
      B_0x1 => 1);

   --  Capture/compare 2 selection 	
   type TIM1_CCMR1_Alternate_CC2S_Field is
     (--  CC2 channel is configured as output
      B_0x0,
      --  CC2 channel is configured as input, tim_ic2 is mapped on tim_ti2
      B_0x1,
      --  CC2 channel is configured as input, tim_ic2 is mapped on tim_ti1
      B_0x2,
      --  CC2 channel is configured as input, tim_ic2 is mapped on tim_trc.
      B_0x3)
     with Size => 2;
   for TIM1_CCMR1_Alternate_CC2S_Field use
     (B_0x0 => 0,
      B_0x1 => 1,
      B_0x2 => 2,
      B_0x3 => 3);

   subtype TIM1_CCMR1_Alternate_OC2M_Field is STM32G4_SVD.UInt3;

   --  TIM1 capture/compare mode register 1
   type TIM1_CCMR1_Alternate_Register is record
      --  Capture/compare 1 selection 	
      CC1S           : TIM1_CCMR1_Alternate_CC1S_Field :=
                        STM32G4_SVD.TIM.B_0x0;
      --  Output compare 1 fast enable 	
      OC1FE          : TIM1_CCMR1_Alternate_OC1FE_Field :=
                        STM32G4_SVD.TIM.B_0x0;
      --  Output compare 1 preload enable 	
      OC1PE          : TIM1_CCMR1_Alternate_OC1PE_Field :=
                        STM32G4_SVD.TIM.B_0x0;
      --  OC1M[2:0]: Output compare 1 mode 	
      OC1M           : TIM1_CCMR1_Alternate_OC1M_Field :=
                        STM32G4_SVD.TIM.B_0x0;
      --  Output compare 1 clear enable
      OC1CE          : TIM1_CCMR1_Alternate_OC1CE_Field :=
                        STM32G4_SVD.TIM.B_0x0;
      --  Capture/compare 2 selection 	
      CC2S           : TIM1_CCMR1_Alternate_CC2S_Field :=
                        STM32G4_SVD.TIM.B_0x0;
      --  Output compare 2 fast enable
      OC2FE          : Boolean := False;
      --  Output compare 2 preload enable
      OC2PE          : Boolean := False;
      --  OC2M[2:0]: Output compare 2 mode
      OC2M           : TIM1_CCMR1_Alternate_OC2M_Field := 16#0#;
      --  Output compare 2 clear enable
      OC2CE          : Boolean := False;
      --  OC1M[3]
      OC1M_1         : Boolean := False;
      --  unspecified
      Reserved_17_23 : STM32G4_SVD.UInt7 := 16#0#;
      --  OC2M[3]
      OC2M_1         : Boolean := False;
      --  unspecified
      Reserved_25_31 : STM32G4_SVD.UInt7 := 16#0#;
   end record
     with Volatile_Full_Access, Object_Size => 32,
          Bit_Order => System.Low_Order_First;

   for TIM1_CCMR1_Alternate_Register use record
      CC1S           at 0 range 0 .. 1;
      OC1FE          at 0 range 2 .. 2;
      OC1PE          at 0 range 3 .. 3;
      OC1M           at 0 range 4 .. 6;
      OC1CE          at 0 range 7 .. 7;
      CC2S           at 0 range 8 .. 9;
      OC2FE          at 0 range 10 .. 10;
      OC2PE          at 0 range 11 .. 11;
      OC2M           at 0 range 12 .. 14;
      OC2CE          at 0 range 15 .. 15;
      OC1M_1         at 0 range 16 .. 16;
      Reserved_17_23 at 0 range 17 .. 23;
      OC2M_1         at 0 range 24 .. 24;
      Reserved_25_31 at 0 range 25 .. 31;
   end record;

   --  Capture/compare 3 selection 	
   type TIM1_CCMR2_CC3S_Field is
     (--  CC3 channel is configured as output
      B_0x0,
      --  CC3 channel is configured as input, tim_ic3 is mapped on tim_ti3
      B_0x1,
      --  CC3 channel is configured as input, tim_ic3 is mapped on tim_ti4
      B_0x2,
      --  CC3 channel is configured as input, tim_ic3 is mapped on tim_trc.
      B_0x3)
     with Size => 2;
   for TIM1_CCMR2_CC3S_Field use
     (B_0x0 => 0,
      B_0x1 => 1,
      B_0x2 => 2,
      B_0x3 => 3);

   subtype TIM1_CCMR2_IC3PSC_Field is STM32G4_SVD.UInt2;
   subtype TIM1_CCMR2_IC3F_Field is STM32G4_SVD.UInt4;

   --  Capture/compare 4 selection 	
   type TIM1_CCMR2_CC4S_Field is
     (--  CC4 channel is configured as output
      B_0x0,
      --  CC4 channel is configured as input, tim_ic4 is mapped on tim_ti4
      B_0x1,
      --  CC4 channel is configured as input, tim_ic4 is mapped on tim_ti3
      B_0x2,
      --  CC4 channel is configured as input, tim_ic4 is mapped on tim_trc.
      B_0x3)
     with Size => 2;
   for TIM1_CCMR2_CC4S_Field use
     (B_0x0 => 0,
      B_0x1 => 1,
      B_0x2 => 2,
      B_0x3 => 3);

   subtype TIM1_CCMR2_IC4PSC_Field is STM32G4_SVD.UInt2;
   subtype TIM1_CCMR2_IC4F_Field is STM32G4_SVD.UInt4;

   --  TIM1 capture/compare mode register 2 [alternate]
   type TIM1_CCMR2_Register is record
      --  Capture/compare 3 selection 	
      CC3S           : TIM1_CCMR2_CC3S_Field := STM32G4_SVD.TIM.B_0x0;
      --  Input capture 3 prescaler
      IC3PSC         : TIM1_CCMR2_IC3PSC_Field := 16#0#;
      --  Input capture 3 filter
      IC3F           : TIM1_CCMR2_IC3F_Field := 16#0#;
      --  Capture/compare 4 selection 	
      CC4S           : TIM1_CCMR2_CC4S_Field := STM32G4_SVD.TIM.B_0x0;
      --  Input capture 4 prescaler
      IC4PSC         : TIM1_CCMR2_IC4PSC_Field := 16#0#;
      --  Input capture 4 filter
      IC4F           : TIM1_CCMR2_IC4F_Field := 16#0#;
      --  unspecified
      Reserved_16_31 : STM32G4_SVD.UInt16 := 16#0#;
   end record
     with Volatile_Full_Access, Object_Size => 32,
          Bit_Order => System.Low_Order_First;

   for TIM1_CCMR2_Register use record
      CC3S           at 0 range 0 .. 1;
      IC3PSC         at 0 range 2 .. 3;
      IC3F           at 0 range 4 .. 7;
      CC4S           at 0 range 8 .. 9;
      IC4PSC         at 0 range 10 .. 11;
      IC4F           at 0 range 12 .. 15;
      Reserved_16_31 at 0 range 16 .. 31;
   end record;

   --  Capture/compare 3 selection 	
   type TIM1_CCMR2_Alternate_CC3S_Field is
     (--  CC3 channel is configured as output
      B_0x0,
      --  CC3 channel is configured as input, tim_ic3 is mapped on tim_ti3
      B_0x1,
      --  CC3 channel is configured as input, tim_ic3 is mapped on tim_ti4
      B_0x2,
      --  CC3 channel is configured as input, tim_ic3 is mapped on tim_trc.
      B_0x3)
     with Size => 2;
   for TIM1_CCMR2_Alternate_CC3S_Field use
     (B_0x0 => 0,
      B_0x1 => 1,
      B_0x2 => 2,
      B_0x3 => 3);

   --  OC3M[2:0]: Output compare 3 mode 	
   type TIM1_CCMR2_Alternate_OC3M_Field is
     (--  Frozen - The comparison between the output compare register TIMx_CCR3 and
--  the counter TIMx_CNT has no effect on the outputs.
      B_0x0,
      --  Set channel 3 to active level on match.
      B_0x1,
      --  Set channel 3 to inactive level on match.
      B_0x2,
      --  Toggle - tim_oc3ref toggles when TIMx_CNT=TIMx_CCR3.
      B_0x3,
      --  Force inactive level - tim_oc3ref is forced low.
      B_0x4,
      --  Force active level - tim_oc3ref is forced high.
      B_0x5,
      --  PWM mode 1 - In upcounting, channel 3 is active as long as TIMx_CNTless
--  thanTIMx_CCR3 else inactive.
      B_0x6,
      --  PWM mode 2 - In upcounting, channel 3 is inactive as long as TIMx_CNTless
--  thanTIMx_CCR3 else active.
      B_0x7)
     with Size => 3;
   for TIM1_CCMR2_Alternate_OC3M_Field use
     (B_0x0 => 0,
      B_0x1 => 1,
      B_0x2 => 2,
      B_0x3 => 3,
      B_0x4 => 4,
      B_0x5 => 5,
      B_0x6 => 6,
      B_0x7 => 7);

   --  Capture/compare 4 selection 	
   type TIM1_CCMR2_Alternate_CC4S_Field is
     (--  CC4 channel is configured as output
      B_0x0,
      --  CC4 channel is configured as input, tim_ic4 is mapped on tim_ti4
      B_0x1,
      --  CC4 channel is configured as input, tim_ic4 is mapped on tim_ti3
      B_0x2,
      --  CC4 channel is configured as input, tim_ic4 is mapped on tim_trc.
      B_0x3)
     with Size => 2;
   for TIM1_CCMR2_Alternate_CC4S_Field use
     (B_0x0 => 0,
      B_0x1 => 1,
      B_0x2 => 2,
      B_0x3 => 3);

   subtype TIM1_CCMR2_Alternate_OC4M_Field is STM32G4_SVD.UInt3;

   --  TIM1 capture/compare mode register 2
   type TIM1_CCMR2_Alternate_Register is record
      --  Capture/compare 3 selection 	
      CC3S           : TIM1_CCMR2_Alternate_CC3S_Field :=
                        STM32G4_SVD.TIM.B_0x0;
      --  Output compare 3 fast enable
      OC3FE          : Boolean := False;
      --  Output compare 3 preload enable
      OC3PE          : Boolean := False;
      --  OC3M[2:0]: Output compare 3 mode 	
      OC3M           : TIM1_CCMR2_Alternate_OC3M_Field :=
                        STM32G4_SVD.TIM.B_0x0;
      --  Output compare 3 clear enable
      OC3CE          : Boolean := False;
      --  Capture/compare 4 selection 	
      CC4S           : TIM1_CCMR2_Alternate_CC4S_Field :=
                        STM32G4_SVD.TIM.B_0x0;
      --  Output compare 4 fast enable
      OC4FE          : Boolean := False;
      --  Output compare 4 preload enable
      OC4PE          : Boolean := False;
      --  OC4M[2:0]: Output compare 4 mode 	
      OC4M           : TIM1_CCMR2_Alternate_OC4M_Field := 16#0#;
      --  Output compare 4 clear enable
      OC4CE          : Boolean := False;
      --  OC3M[3]
      OC3M_1         : Boolean := False;
      --  unspecified
      Reserved_17_23 : STM32G4_SVD.UInt7 := 16#0#;
      --  OC4M[3]
      OC4M_1         : Boolean := False;
      --  unspecified
      Reserved_25_31 : STM32G4_SVD.UInt7 := 16#0#;
   end record
     with Volatile_Full_Access, Object_Size => 32,
          Bit_Order => System.Low_Order_First;

   for TIM1_CCMR2_Alternate_Register use record
      CC3S           at 0 range 0 .. 1;
      OC3FE          at 0 range 2 .. 2;
      OC3PE          at 0 range 3 .. 3;
      OC3M           at 0 range 4 .. 6;
      OC3CE          at 0 range 7 .. 7;
      CC4S           at 0 range 8 .. 9;
      OC4FE          at 0 range 10 .. 10;
      OC4PE          at 0 range 11 .. 11;
      OC4M           at 0 range 12 .. 14;
      OC4CE          at 0 range 15 .. 15;
      OC3M_1         at 0 range 16 .. 16;
      Reserved_17_23 at 0 range 17 .. 23;
      OC4M_1         at 0 range 24 .. 24;
      Reserved_25_31 at 0 range 25 .. 31;
   end record;

   --  Capture/compare 1 output enable 	
   type TIM1_CCER_CC1E_Field is
     (--  Capture mode disabled / OC1 is not active (see below)
      B_0x0,
      --  Capture mode enabled / OC1 signal is output on the corresponding output pin
      B_0x1)
     with Size => 1;
   for TIM1_CCER_CC1E_Field use
     (B_0x0 => 0,
      B_0x1 => 1);

   --  Capture/compare 1 output polarity 	
   type TIM1_CCER_CC1P_Field is
     (--  OC1 active high (output mode) / Edge sensitivity selection (input mode, see
--  below)
      B_0x0,
      --  OC1 active low (output mode) / Edge sensitivity selection (input mode, see
--  below)
      B_0x1)
     with Size => 1;
   for TIM1_CCER_CC1P_Field use
     (B_0x0 => 0,
      B_0x1 => 1);

   --  Capture/compare 1 complementary output enable 	
   type TIM1_CCER_CC1NE_Field is
     (--  Off - tim_oc1n is not active.
      B_0x0,
      --  On - tim_oc1n signal is output on the corresponding output pin depending on
--  MOE, OSSI, OSSR, OIS1, OIS1N and CC1E bits.
      B_0x1)
     with Size => 1;
   for TIM1_CCER_CC1NE_Field use
     (B_0x0 => 0,
      B_0x1 => 1);

   --  Capture/compare 1 complementary output polarity 	
   type TIM1_CCER_CC1NP_Field is
     (--  tim_oc1n active high.
      B_0x0,
      --  tim_oc1n active low.
      B_0x1)
     with Size => 1;
   for TIM1_CCER_CC1NP_Field use
     (B_0x0 => 0,
      B_0x1 => 1);

   --  TIM1 capture/compare enable register
   type TIM1_CCER_Register is record
      --  Capture/compare 1 output enable 	
      CC1E           : TIM1_CCER_CC1E_Field := STM32G4_SVD.TIM.B_0x0;
      --  Capture/compare 1 output polarity 	
      CC1P           : TIM1_CCER_CC1P_Field := STM32G4_SVD.TIM.B_0x0;
      --  Capture/compare 1 complementary output enable 	
      CC1NE          : TIM1_CCER_CC1NE_Field := STM32G4_SVD.TIM.B_0x0;
      --  Capture/compare 1 complementary output polarity 	
      CC1NP          : TIM1_CCER_CC1NP_Field := STM32G4_SVD.TIM.B_0x0;
      --  Capture/compare 2 output enable 	
      CC2E           : Boolean := False;
      --  Capture/compare 2 output polarity 	
      CC2P           : Boolean := False;
      --  Capture/compare 2 complementary output enable 	
      CC2NE          : Boolean := False;
      --  Capture/compare 2 complementary output polarity 	
      CC2NP          : Boolean := False;
      --  Capture/compare 3 output enable 	
      CC3E           : Boolean := False;
      --  Capture/compare 3 output polarity 	
      CC3P           : Boolean := False;
      --  Capture/compare 3 complementary output enable 	
      CC3NE          : Boolean := False;
      --  Capture/compare 3 complementary output polarity 	
      CC3NP          : Boolean := False;
      --  Capture/compare 4 output enable 	
      CC4E           : Boolean := False;
      --  Capture/compare 4 output polarity 	
      CC4P           : Boolean := False;
      --  Capture/compare 4 complementary output enable 	
      CC4NE          : Boolean := False;
      --  Capture/compare 4 complementary output polarity 	
      CC4NP          : Boolean := False;
      --  Capture/compare 5 output enable 	
      CC5E           : Boolean := False;
      --  Capture/compare 5 output polarity 	
      CC5P           : Boolean := False;
      --  unspecified
      Reserved_18_19 : STM32G4_SVD.UInt2 := 16#0#;
      --  Capture/compare 6 output enable 	
      CC6E           : Boolean := False;
      --  Capture/compare 6 output polarity 	
      CC6P           : Boolean := False;
      --  unspecified
      Reserved_22_31 : STM32G4_SVD.UInt10 := 16#0#;
   end record
     with Volatile_Full_Access, Object_Size => 32,
          Bit_Order => System.Low_Order_First;

   for TIM1_CCER_Register use record
      CC1E           at 0 range 0 .. 0;
      CC1P           at 0 range 1 .. 1;
      CC1NE          at 0 range 2 .. 2;
      CC1NP          at 0 range 3 .. 3;
      CC2E           at 0 range 4 .. 4;
      CC2P           at 0 range 5 .. 5;
      CC2NE          at 0 range 6 .. 6;
      CC2NP          at 0 range 7 .. 7;
      CC3E           at 0 range 8 .. 8;
      CC3P           at 0 range 9 .. 9;
      CC3NE          at 0 range 10 .. 10;
      CC3NP          at 0 range 11 .. 11;
      CC4E           at 0 range 12 .. 12;
      CC4P           at 0 range 13 .. 13;
      CC4NE          at 0 range 14 .. 14;
      CC4NP          at 0 range 15 .. 15;
      CC5E           at 0 range 16 .. 16;
      CC5P           at 0 range 17 .. 17;
      Reserved_18_19 at 0 range 18 .. 19;
      CC6E           at 0 range 20 .. 20;
      CC6P           at 0 range 21 .. 21;
      Reserved_22_31 at 0 range 22 .. 31;
   end record;

   subtype TIM1_CNT_CNT_Field is STM32G4_SVD.UInt16;

   --  TIM1 counter
   type TIM1_CNT_Register is record
      --  Counter value 	
      CNT            : TIM1_CNT_CNT_Field := 16#0#;
      --  unspecified
      Reserved_16_30 : STM32G4_SVD.UInt15 := 16#0#;
      --  Read-only. UIF copy 	
      UIFCPY         : Boolean := False;
   end record
     with Volatile_Full_Access, Object_Size => 32,
          Bit_Order => System.Low_Order_First;

   for TIM1_CNT_Register use record
      CNT            at 0 range 0 .. 15;
      Reserved_16_30 at 0 range 16 .. 30;
      UIFCPY         at 0 range 31 .. 31;
   end record;

   subtype TIM1_ARR_ARR_Field is STM32G4_SVD.UInt20;

   --  TIM1 auto-reload register
   type TIM1_ARR_Register is record
      --  Auto-reload value 	
      ARR            : TIM1_ARR_ARR_Field := 16#FFFF#;
      --  unspecified
      Reserved_20_31 : STM32G4_SVD.UInt12 := 16#0#;
   end record
     with Volatile_Full_Access, Object_Size => 32,
          Bit_Order => System.Low_Order_First;

   for TIM1_ARR_Register use record
      ARR            at 0 range 0 .. 19;
      Reserved_20_31 at 0 range 20 .. 31;
   end record;

   subtype TIM1_CCR1_CCR1_Field is STM32G4_SVD.UInt20;

   --  TIM1 capture/compare register 1
   type TIM1_CCR1_Register is record
      --  Capture/compare 1 value 	
      CCR1           : TIM1_CCR1_CCR1_Field := 16#0#;
      --  unspecified
      Reserved_20_31 : STM32G4_SVD.UInt12 := 16#0#;
   end record
     with Volatile_Full_Access, Object_Size => 32,
          Bit_Order => System.Low_Order_First;

   for TIM1_CCR1_Register use record
      CCR1           at 0 range 0 .. 19;
      Reserved_20_31 at 0 range 20 .. 31;
   end record;

   subtype TIM1_CCR2_CCR2_Field is STM32G4_SVD.UInt20;

   --  TIM1 capture/compare register 2
   type TIM1_CCR2_Register is record
      --  Capture/compare 2 value 	
      CCR2           : TIM1_CCR2_CCR2_Field := 16#0#;
      --  unspecified
      Reserved_20_31 : STM32G4_SVD.UInt12 := 16#0#;
   end record
     with Volatile_Full_Access, Object_Size => 32,
          Bit_Order => System.Low_Order_First;

   for TIM1_CCR2_Register use record
      CCR2           at 0 range 0 .. 19;
      Reserved_20_31 at 0 range 20 .. 31;
   end record;

   subtype TIM1_CCR3_CCR3_Field is STM32G4_SVD.UInt20;

   --  TIM1 capture/compare register 3
   type TIM1_CCR3_Register is record
      --  Capture/compare value 	
      CCR3           : TIM1_CCR3_CCR3_Field := 16#0#;
      --  unspecified
      Reserved_20_31 : STM32G4_SVD.UInt12 := 16#0#;
   end record
     with Volatile_Full_Access, Object_Size => 32,
          Bit_Order => System.Low_Order_First;

   for TIM1_CCR3_Register use record
      CCR3           at 0 range 0 .. 19;
      Reserved_20_31 at 0 range 20 .. 31;
   end record;

   subtype TIM1_CCR4_CCR4_Field is STM32G4_SVD.UInt20;

   --  TIM1 capture/compare register 4
   type TIM1_CCR4_Register is record
      --  Capture/compare value 	
      CCR4           : TIM1_CCR4_CCR4_Field := 16#0#;
      --  unspecified
      Reserved_20_31 : STM32G4_SVD.UInt12 := 16#0#;
   end record
     with Volatile_Full_Access, Object_Size => 32,
          Bit_Order => System.Low_Order_First;

   for TIM1_CCR4_Register use record
      CCR4           at 0 range 0 .. 19;
      Reserved_20_31 at 0 range 20 .. 31;
   end record;

   subtype TIM1_BDTR_DTG_Field is STM32G4_SVD.Byte;

   --  Lock configuration 	
   type TIM1_BDTR_LOCK_Field is
     (--  LOCK OFF - No bit is write protected.
      B_0x0,
      --  LOCK Level 1 = DTG bits in TIMx_BDTR register, OISx and OISxN bits in
--  TIMx_CR2 register and BKBID/BK2BID/BKE/BKP/AOE bits in TIMx_BDTR register
--  can no longer be written.
      B_0x1,
      --  LOCK Level 2 = LOCK Level 1 + CC Polarity bits (CCxP/CCxNP bits in
--  TIMx_CCER register, as long as the related channel is configured in output
--  through the CCxS bits) as well as OSSR and OSSI bits can no longer be
--  written.
      B_0x2,
      --  LOCK Level 3 = LOCK Level 2 + CC Control bits (OCxM and OCxPE bits in
--  TIMx_CCMRx registers, as long as the related channel is configured in
--  output through the CCxS bits) can no longer be written.
      B_0x3)
     with Size => 2;
   for TIM1_BDTR_LOCK_Field use
     (B_0x0 => 0,
      B_0x1 => 1,
      B_0x2 => 2,
      B_0x3 => 3);

   --  Off-state selection for idle mode 	
   type TIM1_BDTR_OSSI_Field is
     (--  When inactive, OC/OCN outputs are disabled (the timer releases the output
--  control which is taken over by the GPIO logic and which imposes a Hi-Z
--  state).
      B_0x0,
      --  When inactive, OC/OCN outputs are first forced with their inactive level
--  then forced to their idle level after the deadtime.
      B_0x1)
     with Size => 1;
   for TIM1_BDTR_OSSI_Field use
     (B_0x0 => 0,
      B_0x1 => 1);

   --  Off-state selection for Run mode 	
   type TIM1_BDTR_OSSR_Field is
     (--  When inactive, OC/OCN outputs are disabled (the timer releases the output
--  control which is taken over by the GPIO logic, which forces a Hi-Z state).
      B_0x0,
      --  When inactive, OC/OCN outputs are enabled with their inactive level as soon
--  as CCxE=1 or CCxNE=1 (the output is still controlled by the timer).
      B_0x1)
     with Size => 1;
   for TIM1_BDTR_OSSR_Field use
     (B_0x0 => 0,
      B_0x1 => 1);

   --  Break enable 	
   type TIM1_BDTR_BKE_Field is
     (--  Break function disabled
      B_0x0,
      --  Break function enabled
      B_0x1)
     with Size => 1;
   for TIM1_BDTR_BKE_Field use
     (B_0x0 => 0,
      B_0x1 => 1);

   --  Break polarity 	
   type TIM1_BDTR_BKP_Field is
     (--  Break input tim_brk is active low
      B_0x0,
      --  Break input tim_brk is active high
      B_0x1)
     with Size => 1;
   for TIM1_BDTR_BKP_Field use
     (B_0x0 => 0,
      B_0x1 => 1);

   --  Automatic output enable 	
   type TIM1_BDTR_AOE_Field is
     (--  MOE can be set only by software
      B_0x0,
      --  MOE can be set by software or automatically at the next update event (if
--  none of the break inputs tim_brk and tim_brk2 is active)
      B_0x1)
     with Size => 1;
   for TIM1_BDTR_AOE_Field use
     (B_0x0 => 0,
      B_0x1 => 1);

   --  Main output enable 	
   type TIM1_BDTR_MOE_Field is
     (--  In response to a break 2 event.
      B_0x0,
      --  OC and OCN outputs are enabled if their respective enable bits are set
--  (CCxE, CCxNE in TIMx_CCER register).
      B_0x1)
     with Size => 1;
   for TIM1_BDTR_MOE_Field use
     (B_0x0 => 0,
      B_0x1 => 1);

   --  Break filter 	
   type TIM1_BDTR_BKF_Field is
     (--  No filter, tim_brk acts asynchronously
      B_0x0,
      --  fless thansub>SAMPLINGless than/sub>=fless thansub>tim_ker_ckless
--  than/sub>, N=2
      B_0x1,
      --  fless thansub>SAMPLINGless than/sub>=fless thansub>tim_ker_ckless
--  than/sub>, N=4
      B_0x2,
      --  fless thansub>SAMPLINGless than/sub>=fless thansub>tim_ker_ckless
--  than/sub>, N=8
      B_0x3,
      --  fless thansub>SAMPLINGless than/sub>=fless thansub>DTSless than/sub>/2, N=6
      B_0x4,
      --  fless thansub>SAMPLINGless than/sub>=fless thansub>DTSless than/sub>/2, N=8
      B_0x5,
      --  fless thansub>SAMPLINGless than/sub>=fless thansub>DTSless than/sub>/4, N=6
      B_0x6,
      --  fless thansub>SAMPLINGless than/sub>=fless thansub>DTSless than/sub>/4, N=8
      B_0x7,
      --  fless thansub>SAMPLINGless than/sub>=fless thansub>DTSless than/sub>/8, N=6
      B_0x8,
      --  fless thansub>SAMPLINGless than/sub>=fless thansub>DTSless than/sub>/8, N=8
      B_0x9,
      --  fless thansub>SAMPLINGless than/sub>=fless thansub>DTSless than/sub>/16,
--  N=5
      B_0xA,
      --  fless thansub>SAMPLINGless than/sub>=fless thansub>DTSless than/sub>/16,
--  N=6
      B_0xB,
      --  fless thansub>SAMPLINGless than/sub>=fless thansub>DTSless than/sub>/16,
--  N=8
      B_0xC,
      --  fless thansub>SAMPLINGless than/sub>=fless thansub>DTSless than/sub>/32,
--  N=5
      B_0xD,
      --  fless thansub>SAMPLINGless than/sub>=fless thansub>DTSless than/sub>/32,
--  N=6
      B_0xE,
      --  fless thansub>SAMPLINGless than/sub>=fless thansub>DTSless than/sub>/32,
--  N=8
      B_0xF)
     with Size => 4;
   for TIM1_BDTR_BKF_Field use
     (B_0x0 => 0,
      B_0x1 => 1,
      B_0x2 => 2,
      B_0x3 => 3,
      B_0x4 => 4,
      B_0x5 => 5,
      B_0x6 => 6,
      B_0x7 => 7,
      B_0x8 => 8,
      B_0x9 => 9,
      B_0xA => 10,
      B_0xB => 11,
      B_0xC => 12,
      B_0xD => 13,
      B_0xE => 14,
      B_0xF => 15);

   --  Break 2 filter 	
   type TIM1_BDTR_BK2F_Field is
     (--  No filter, tim_brk2 acts asynchronously
      B_0x0,
      --  fless thansub>SAMPLINGless than/sub>=fless thansub>tim_ker_ckless
--  than/sub>, N=2
      B_0x1,
      --  fless thansub>SAMPLINGless than/sub>=fless thansub>tim_ker_ckless
--  than/sub>, N=4
      B_0x2,
      --  fless thansub>SAMPLINGless than/sub>=fless thansub>tim_ker_ckless
--  than/sub>, N=8
      B_0x3,
      --  fless thansub>SAMPLINGless than/sub>=fless thansub>DTSless than/sub>/2, N=6
      B_0x4,
      --  fless thansub>SAMPLINGless than/sub>=fless thansub>DTSless than/sub>/2, N=8
      B_0x5,
      --  fless thansub>SAMPLINGless than/sub>=fless thansub>DTSless than/sub>/4, N=6
      B_0x6,
      --  fless thansub>SAMPLINGless than/sub>=fless thansub>DTSless than/sub>/4, N=8
      B_0x7,
      --  fless thansub>SAMPLINGless than/sub>=fless thansub>DTSless than/sub>/8, N=6
      B_0x8,
      --  fless thansub>SAMPLINGless than/sub>=fless thansub>DTSless than/sub>/8, N=8
      B_0x9,
      --  fless thansub>SAMPLINGless than/sub>=fless thansub>DTSless than/sub>/16,
--  N=5
      B_0xA,
      --  fless thansub>SAMPLINGless than/sub>=fless thansub>DTSless than/sub>/16,
--  N=6
      B_0xB,
      --  fless thansub>SAMPLINGless than/sub>=fless thansub>DTSless than/sub>/16,
--  N=8
      B_0xC,
      --  fless thansub>SAMPLINGless than/sub>=fless thansub>DTSless than/sub>/32,
--  N=5
      B_0xD,
      --  fless thansub>SAMPLINGless than/sub>=fless thansub>DTSless than/sub>/32,
--  N=6
      B_0xE,
      --  fless thansub>SAMPLINGless than/sub>=fless thansub>DTSless than/sub>/32,
--  N=8
      B_0xF)
     with Size => 4;
   for TIM1_BDTR_BK2F_Field use
     (B_0x0 => 0,
      B_0x1 => 1,
      B_0x2 => 2,
      B_0x3 => 3,
      B_0x4 => 4,
      B_0x5 => 5,
      B_0x6 => 6,
      B_0x7 => 7,
      B_0x8 => 8,
      B_0x9 => 9,
      B_0xA => 10,
      B_0xB => 11,
      B_0xC => 12,
      B_0xD => 13,
      B_0xE => 14,
      B_0xF => 15);

   --  Break 2 enable 	
   type TIM1_BDTR_BK2E_Field is
     (--  Break2 function disabled
      B_0x0,
      --  Break2 function enabled
      B_0x1)
     with Size => 1;
   for TIM1_BDTR_BK2E_Field use
     (B_0x0 => 0,
      B_0x1 => 1);

   --  Break 2 polarity 	
   type TIM1_BDTR_BK2P_Field is
     (--  Break input tim_brk2 is active low
      B_0x0,
      --  Break input tim_brk2 is active high
      B_0x1)
     with Size => 1;
   for TIM1_BDTR_BK2P_Field use
     (B_0x0 => 0,
      B_0x1 => 1);

   --  Break disarm 	
   type TIM1_BDTR_BKDSRM_Field is
     (--  Break input tim_brk is armed
      B_0x0,
      --  Break input tim_brk is disarmed
      B_0x1)
     with Size => 1;
   for TIM1_BDTR_BKDSRM_Field use
     (B_0x0 => 0,
      B_0x1 => 1);

   --  Break bidirectional 	
   type TIM1_BDTR_BKBID_Field is
     (--  Break input tim_brk in input mode
      B_0x0,
      --  Break input tim_brk in bidirectional mode
      B_0x1)
     with Size => 1;
   for TIM1_BDTR_BKBID_Field use
     (B_0x0 => 0,
      B_0x1 => 1);

   --  TIM1 break and dead-time register
   type TIM1_BDTR_Register is record
      --  Dead-time generator setup 	
      DTG            : TIM1_BDTR_DTG_Field := 16#0#;
      --  Lock configuration 	
      LOCK           : TIM1_BDTR_LOCK_Field := STM32G4_SVD.TIM.B_0x0;
      --  Off-state selection for idle mode 	
      OSSI           : TIM1_BDTR_OSSI_Field := STM32G4_SVD.TIM.B_0x0;
      --  Off-state selection for Run mode 	
      OSSR           : TIM1_BDTR_OSSR_Field := STM32G4_SVD.TIM.B_0x0;
      --  Break enable 	
      BKE            : TIM1_BDTR_BKE_Field := STM32G4_SVD.TIM.B_0x0;
      --  Break polarity 	
      BKP            : TIM1_BDTR_BKP_Field := STM32G4_SVD.TIM.B_0x0;
      --  Automatic output enable 	
      AOE            : TIM1_BDTR_AOE_Field := STM32G4_SVD.TIM.B_0x0;
      --  Main output enable 	
      MOE            : TIM1_BDTR_MOE_Field := STM32G4_SVD.TIM.B_0x0;
      --  Break filter 	
      BKF            : TIM1_BDTR_BKF_Field := STM32G4_SVD.TIM.B_0x0;
      --  Break 2 filter 	
      BK2F           : TIM1_BDTR_BK2F_Field := STM32G4_SVD.TIM.B_0x0;
      --  Break 2 enable 	
      BK2E           : TIM1_BDTR_BK2E_Field := STM32G4_SVD.TIM.B_0x0;
      --  Break 2 polarity 	
      BK2P           : TIM1_BDTR_BK2P_Field := STM32G4_SVD.TIM.B_0x0;
      --  Break disarm 	
      BKDSRM         : TIM1_BDTR_BKDSRM_Field := STM32G4_SVD.TIM.B_0x0;
      --  Break2 disarm 	
      BK2DSRM        : Boolean := False;
      --  Break bidirectional 	
      BKBID          : TIM1_BDTR_BKBID_Field := STM32G4_SVD.TIM.B_0x0;
      --  Break2 bidirectional 	
      BK2BID         : Boolean := False;
      --  unspecified
      Reserved_30_31 : STM32G4_SVD.UInt2 := 16#0#;
   end record
     with Volatile_Full_Access, Object_Size => 32,
          Bit_Order => System.Low_Order_First;

   for TIM1_BDTR_Register use record
      DTG            at 0 range 0 .. 7;
      LOCK           at 0 range 8 .. 9;
      OSSI           at 0 range 10 .. 10;
      OSSR           at 0 range 11 .. 11;
      BKE            at 0 range 12 .. 12;
      BKP            at 0 range 13 .. 13;
      AOE            at 0 range 14 .. 14;
      MOE            at 0 range 15 .. 15;
      BKF            at 0 range 16 .. 19;
      BK2F           at 0 range 20 .. 23;
      BK2E           at 0 range 24 .. 24;
      BK2P           at 0 range 25 .. 25;
      BKDSRM         at 0 range 26 .. 26;
      BK2DSRM        at 0 range 27 .. 27;
      BKBID          at 0 range 28 .. 28;
      BK2BID         at 0 range 29 .. 29;
      Reserved_30_31 at 0 range 30 .. 31;
   end record;

   subtype TIM1_CCR5_CCR5_Field is STM32G4_SVD.UInt20;

   --  Group channel 5 and channel 1 	
   type TIM1_CCR5_GC5C1_Field is
     (--  No effect of oc5ref on oc1refc
      B_0x0,
      --  oc1refc is the logical AND of oc1ref and oc5ref
      B_0x1)
     with Size => 1;
   for TIM1_CCR5_GC5C1_Field use
     (B_0x0 => 0,
      B_0x1 => 1);

   --  Group channel 5 and channel 2 	
   type TIM1_CCR5_GC5C2_Field is
     (--  No effect of tim_oc5ref on tim_oc2refc
      B_0x0,
      --  tim_oc2refc is the logical AND of tim_oc2ref and tim_oc5ref
      B_0x1)
     with Size => 1;
   for TIM1_CCR5_GC5C2_Field use
     (B_0x0 => 0,
      B_0x1 => 1);

   --  Group channel 5 and channel 3 	
   type TIM1_CCR5_GC5C3_Field is
     (--  No effect of tim_oc5ref on tim_oc3refc
      B_0x0,
      --  tim_oc3refc is the logical AND of tim_oc3ref and tim_oc5ref
      B_0x1)
     with Size => 1;
   for TIM1_CCR5_GC5C3_Field use
     (B_0x0 => 0,
      B_0x1 => 1);

   --  TIM1 capture/compare register 5
   type TIM1_CCR5_Register is record
      --  Capture/compare 5 value 	
      CCR5           : TIM1_CCR5_CCR5_Field := 16#0#;
      --  unspecified
      Reserved_20_28 : STM32G4_SVD.UInt9 := 16#0#;
      --  Group channel 5 and channel 1 	
      GC5C1          : TIM1_CCR5_GC5C1_Field := STM32G4_SVD.TIM.B_0x0;
      --  Group channel 5 and channel 2 	
      GC5C2          : TIM1_CCR5_GC5C2_Field := STM32G4_SVD.TIM.B_0x0;
      --  Group channel 5 and channel 3 	
      GC5C3          : TIM1_CCR5_GC5C3_Field := STM32G4_SVD.TIM.B_0x0;
   end record
     with Volatile_Full_Access, Object_Size => 32,
          Bit_Order => System.Low_Order_First;

   for TIM1_CCR5_Register use record
      CCR5           at 0 range 0 .. 19;
      Reserved_20_28 at 0 range 20 .. 28;
      GC5C1          at 0 range 29 .. 29;
      GC5C2          at 0 range 30 .. 30;
      GC5C3          at 0 range 31 .. 31;
   end record;

   subtype TIM1_CCR6_CCR6_Field is STM32G4_SVD.UInt20;

   --  TIM1 capture/compare register 6
   type TIM1_CCR6_Register is record
      --  Capture/compare 6 value 	
      CCR6           : TIM1_CCR6_CCR6_Field := 16#0#;
      --  unspecified
      Reserved_20_31 : STM32G4_SVD.UInt12 := 16#0#;
   end record
     with Volatile_Full_Access, Object_Size => 32,
          Bit_Order => System.Low_Order_First;

   for TIM1_CCR6_Register use record
      CCR6           at 0 range 0 .. 19;
      Reserved_20_31 at 0 range 20 .. 31;
   end record;

   subtype TIM1_CCMR3_OC5M_Field is STM32G4_SVD.UInt3;
   subtype TIM1_CCMR3_OC6M_Field is STM32G4_SVD.UInt3;

   --  TIM1 capture/compare mode register 3
   type TIM1_CCMR3_Register is record
      --  unspecified
      Reserved_0_1   : STM32G4_SVD.UInt2 := 16#0#;
      --  Output compare 5 fast enable
      OC5FE          : Boolean := False;
      --  Output compare 5 preload enable
      OC5PE          : Boolean := False;
      --  OC5M[2:0]: Output compare 5 mode
      OC5M           : TIM1_CCMR3_OC5M_Field := 16#0#;
      --  Output compare 5 clear enable
      OC5CE          : Boolean := False;
      --  unspecified
      Reserved_8_9   : STM32G4_SVD.UInt2 := 16#0#;
      --  Output compare 6 fast enable
      OC6FE          : Boolean := False;
      --  Output compare 6 preload enable
      OC6PE          : Boolean := False;
      --  OC6M[2:0]: Output compare 6 mode
      OC6M           : TIM1_CCMR3_OC6M_Field := 16#0#;
      --  Output compare 6 clear enable
      OC6CE          : Boolean := False;
      --  OC5M[3]
      OC5M_1         : Boolean := False;
      --  unspecified
      Reserved_17_23 : STM32G4_SVD.UInt7 := 16#0#;
      --  OC6M[3]
      OC6M_1         : Boolean := False;
      --  unspecified
      Reserved_25_31 : STM32G4_SVD.UInt7 := 16#0#;
   end record
     with Volatile_Full_Access, Object_Size => 32,
          Bit_Order => System.Low_Order_First;

   for TIM1_CCMR3_Register use record
      Reserved_0_1   at 0 range 0 .. 1;
      OC5FE          at 0 range 2 .. 2;
      OC5PE          at 0 range 3 .. 3;
      OC5M           at 0 range 4 .. 6;
      OC5CE          at 0 range 7 .. 7;
      Reserved_8_9   at 0 range 8 .. 9;
      OC6FE          at 0 range 10 .. 10;
      OC6PE          at 0 range 11 .. 11;
      OC6M           at 0 range 12 .. 14;
      OC6CE          at 0 range 15 .. 15;
      OC5M_1         at 0 range 16 .. 16;
      Reserved_17_23 at 0 range 17 .. 23;
      OC6M_1         at 0 range 24 .. 24;
      Reserved_25_31 at 0 range 25 .. 31;
   end record;

   subtype TIM1_DTR2_DTGF_Field is STM32G4_SVD.Byte;

   --  Deadtime asymmetric enable 	
   type TIM1_DTR2_DTAE_Field is
     (--  Deadtime on rising and falling edges are identical, and defined with
--  DTG[7:0] register
      B_0x0,
      --  Deadtime on rising edge is defined with DTG[7:0] register and deadtime on
--  falling edge is defined with DTGF[7:0] bits.
      B_0x1)
     with Size => 1;
   for TIM1_DTR2_DTAE_Field use
     (B_0x0 => 0,
      B_0x1 => 1);

   --  Deadtime preload enable 	
   type TIM1_DTR2_DTPE_Field is
     (--  Deadtime value is not preloaded
      B_0x0,
      --  Deadtime value preload is enabled
      B_0x1)
     with Size => 1;
   for TIM1_DTR2_DTPE_Field use
     (B_0x0 => 0,
      B_0x1 => 1);

   --  TIM1 timer deadtime register 2
   type TIM1_DTR2_Register is record
      --  Dead-time falling edge generator setup 	
      DTGF           : TIM1_DTR2_DTGF_Field := 16#0#;
      --  unspecified
      Reserved_8_15  : STM32G4_SVD.Byte := 16#0#;
      --  Deadtime asymmetric enable 	
      DTAE           : TIM1_DTR2_DTAE_Field := STM32G4_SVD.TIM.B_0x0;
      --  Deadtime preload enable 	
      DTPE           : TIM1_DTR2_DTPE_Field := STM32G4_SVD.TIM.B_0x0;
      --  unspecified
      Reserved_18_31 : STM32G4_SVD.UInt14 := 16#0#;
   end record
     with Volatile_Full_Access, Object_Size => 32,
          Bit_Order => System.Low_Order_First;

   for TIM1_DTR2_Register use record
      DTGF           at 0 range 0 .. 7;
      Reserved_8_15  at 0 range 8 .. 15;
      DTAE           at 0 range 16 .. 16;
      DTPE           at 0 range 17 .. 17;
      Reserved_18_31 at 0 range 18 .. 31;
   end record;

   --  Index enable 	
   type TIM1_ECR_IE_Field is
     (--  Index disabled
      B_0x0,
      --  Index enabled
      B_0x1)
     with Size => 1;
   for TIM1_ECR_IE_Field use
     (B_0x0 => 0,
      B_0x1 => 1);

   --  Index direction 	
   type TIM1_ECR_IDIR_Field is
     (--  Index resets the counter whatever the direction
      B_0x0,
      --  Index resets the counter when up-counting only
      B_0x1,
      --  Index resets the counter when down-counting only
      B_0x2)
     with Size => 2;
   for TIM1_ECR_IDIR_Field use
     (B_0x0 => 0,
      B_0x1 => 1,
      B_0x2 => 2);

   --  First index 	
   type TIM1_ECR_FIDX_Field is
     (--  Index is always active
      B_0x0,
      --  the first Index only resets the counter
      B_0x1)
     with Size => 1;
   for TIM1_ECR_FIDX_Field use
     (B_0x0 => 0,
      B_0x1 => 1);

   --  Index positioning 	
   type TIM1_ECR_IPOS_Field is
     (--  Index resets the counter when AB = 00
      B_0x0,
      --  Index resets the counter when AB = 01
      B_0x1,
      --  Index resets the counter when AB = 10
      B_0x2,
      --  Index resets the counter when AB = 11
      B_0x3)
     with Size => 2;
   for TIM1_ECR_IPOS_Field use
     (B_0x0 => 0,
      B_0x1 => 1,
      B_0x2 => 2,
      B_0x3 => 3);

   subtype TIM1_ECR_PW_Field is STM32G4_SVD.Byte;
   subtype TIM1_ECR_PWPRSC_Field is STM32G4_SVD.UInt3;

   --  TIM1 timer encoder control register
   type TIM1_ECR_Register is record
      --  Index enable 	
      IE             : TIM1_ECR_IE_Field := STM32G4_SVD.TIM.B_0x0;
      --  Index direction 	
      IDIR           : TIM1_ECR_IDIR_Field := STM32G4_SVD.TIM.B_0x0;
      --  unspecified
      Reserved_3_4   : STM32G4_SVD.UInt2 := 16#0#;
      --  First index 	
      FIDX           : TIM1_ECR_FIDX_Field := STM32G4_SVD.TIM.B_0x0;
      --  Index positioning 	
      IPOS           : TIM1_ECR_IPOS_Field := STM32G4_SVD.TIM.B_0x0;
      --  unspecified
      Reserved_8_15  : STM32G4_SVD.Byte := 16#0#;
      --  Pulse width 	
      PW             : TIM1_ECR_PW_Field := 16#0#;
      --  Pulse width prescaler 	
      PWPRSC         : TIM1_ECR_PWPRSC_Field := 16#0#;
      --  unspecified
      Reserved_27_31 : STM32G4_SVD.UInt5 := 16#0#;
   end record
     with Volatile_Full_Access, Object_Size => 32,
          Bit_Order => System.Low_Order_First;

   for TIM1_ECR_Register use record
      IE             at 0 range 0 .. 0;
      IDIR           at 0 range 1 .. 2;
      Reserved_3_4   at 0 range 3 .. 4;
      FIDX           at 0 range 5 .. 5;
      IPOS           at 0 range 6 .. 7;
      Reserved_8_15  at 0 range 8 .. 15;
      PW             at 0 range 16 .. 23;
      PWPRSC         at 0 range 24 .. 26;
      Reserved_27_31 at 0 range 27 .. 31;
   end record;

   --  Selects tim_ti1[15:0] input 	
   type TIM1_TISEL_TI1SEL_Field is
     (--  tim_ti1_in0: TIMx_CH1
      B_0x0,
      --  tim_ti1_in1
      B_0x1,
      --  tim_ti1_in15
      B_0xF)
     with Size => 4;
   for TIM1_TISEL_TI1SEL_Field use
     (B_0x0 => 0,
      B_0x1 => 1,
      B_0xF => 15);

   --  Selects tim_ti2[15:0] input 	
   type TIM1_TISEL_TI2SEL_Field is
     (--  tim_ti2_in0: TIMx_CH2
      B_0x0,
      --  tim_ti2_in1
      B_0x1,
      --  tim_ti2_in15
      B_0xF)
     with Size => 4;
   for TIM1_TISEL_TI2SEL_Field use
     (B_0x0 => 0,
      B_0x1 => 1,
      B_0xF => 15);

   --  Selects tim_ti3[15:0] input 	
   type TIM1_TISEL_TI3SEL_Field is
     (--  tim_ti3_in0: TIMx_CH2
      B_0x0,
      --  tim_ti3_in1
      B_0x1,
      --  tim_ti3_in15
      B_0xF)
     with Size => 4;
   for TIM1_TISEL_TI3SEL_Field use
     (B_0x0 => 0,
      B_0x1 => 1,
      B_0xF => 15);

   --  Selects tim_ti4[15:0] input 	
   type TIM1_TISEL_TI4SEL_Field is
     (--  tim_ti4_in0: TIMx_CH4
      B_0x0,
      --  tim_ti4_in1
      B_0x1,
      --  tim_ti4_in15
      B_0xF)
     with Size => 4;
   for TIM1_TISEL_TI4SEL_Field use
     (B_0x0 => 0,
      B_0x1 => 1,
      B_0xF => 15);

   --  TIM1 timer input selection register
   type TIM1_TISEL_Register is record
      --  Selects tim_ti1[15:0] input 	
      TI1SEL         : TIM1_TISEL_TI1SEL_Field := STM32G4_SVD.TIM.B_0x0;
      --  unspecified
      Reserved_4_7   : STM32G4_SVD.UInt4 := 16#0#;
      --  Selects tim_ti2[15:0] input 	
      TI2SEL         : TIM1_TISEL_TI2SEL_Field := STM32G4_SVD.TIM.B_0x0;
      --  unspecified
      Reserved_12_15 : STM32G4_SVD.UInt4 := 16#0#;
      --  Selects tim_ti3[15:0] input 	
      TI3SEL         : TIM1_TISEL_TI3SEL_Field := STM32G4_SVD.TIM.B_0x0;
      --  unspecified
      Reserved_20_23 : STM32G4_SVD.UInt4 := 16#0#;
      --  Selects tim_ti4[15:0] input 	
      TI4SEL         : TIM1_TISEL_TI4SEL_Field := STM32G4_SVD.TIM.B_0x0;
      --  unspecified
      Reserved_28_31 : STM32G4_SVD.UInt4 := 16#0#;
   end record
     with Volatile_Full_Access, Object_Size => 32,
          Bit_Order => System.Low_Order_First;

   for TIM1_TISEL_Register use record
      TI1SEL         at 0 range 0 .. 3;
      Reserved_4_7   at 0 range 4 .. 7;
      TI2SEL         at 0 range 8 .. 11;
      Reserved_12_15 at 0 range 12 .. 15;
      TI3SEL         at 0 range 16 .. 19;
      Reserved_20_23 at 0 range 20 .. 23;
      TI4SEL         at 0 range 24 .. 27;
      Reserved_28_31 at 0 range 28 .. 31;
   end record;

   --  TIMx_BKIN input enable 	
   type TIM1_AF1_BKINE_Field is
     (--  TIMx_BKIN input disabled
      B_0x0,
      --  TIMx_BKIN input enabled
      B_0x1)
     with Size => 1;
   for TIM1_AF1_BKINE_Field use
     (B_0x0 => 0,
      B_0x1 => 1);

   --  tim_brk_cmp1 enable 	
   type TIM1_AF1_BKCMP1E_Field is
     (--  tim_brk_cmp1 input disabled
      B_0x0,
      --  tim_brk_cmp1 input enabled
      B_0x1)
     with Size => 1;
   for TIM1_AF1_BKCMP1E_Field use
     (B_0x0 => 0,
      B_0x1 => 1);

   --  tim_brk_cmp2 enable 	
   type TIM1_AF1_BKCMP2E_Field is
     (--  tim_brk_cmp2 input disabled
      B_0x0,
      --  tim_brk_cmp2 input enabled
      B_0x1)
     with Size => 1;
   for TIM1_AF1_BKCMP2E_Field use
     (B_0x0 => 0,
      B_0x1 => 1);

   --  tim_brk_cmp3 enable 	
   type TIM1_AF1_BKCMP3E_Field is
     (--  tim_brk_cmp3 input disabled
      B_0x0,
      --  tim_brk_cmp3 input enabled
      B_0x1)
     with Size => 1;
   for TIM1_AF1_BKCMP3E_Field use
     (B_0x0 => 0,
      B_0x1 => 1);

   --  tim_brk_cmp4 enable 	
   type TIM1_AF1_BKCMP4E_Field is
     (--  tim_brk_cmp4 input disabled
      B_0x0,
      --  tim_brk_cmp4 input enabled
      B_0x1)
     with Size => 1;
   for TIM1_AF1_BKCMP4E_Field use
     (B_0x0 => 0,
      B_0x1 => 1);

   --  tim_brk_cmp5 enable 	
   type TIM1_AF1_BKCMP5E_Field is
     (--  tim_brk_cmp5 input disabled
      B_0x0,
      --  tim_brk_cmp5 input enabled
      B_0x1)
     with Size => 1;
   for TIM1_AF1_BKCMP5E_Field use
     (B_0x0 => 0,
      B_0x1 => 1);

   --  tim_brk_cmp6 enable 	
   type TIM1_AF1_BKCMP6E_Field is
     (--  tim_brk_cmp6 input disabled
      B_0x0,
      --  tim_brk_cmp6 input enabled
      B_0x1)
     with Size => 1;
   for TIM1_AF1_BKCMP6E_Field use
     (B_0x0 => 0,
      B_0x1 => 1);

   --  tim_brk_cmp7 enable 	
   type TIM1_AF1_BKCMP7E_Field is
     (--  tim_brk_cmp7 input disabled
      B_0x0,
      --  tim_brk_cmp7 input enabled
      B_0x1)
     with Size => 1;
   for TIM1_AF1_BKCMP7E_Field use
     (B_0x0 => 0,
      B_0x1 => 1);

   --  tim_brk_cmp8 enable 	
   type TIM1_AF1_BKCMP8E_Field is
     (--  tim_brk_cmp8 input disabled
      B_0x0,
      --  tim_brk_cmp8 input enabled
      B_0x1)
     with Size => 1;
   for TIM1_AF1_BKCMP8E_Field use
     (B_0x0 => 0,
      B_0x1 => 1);

   --  TIMx_BKIN input polarity 	
   type TIM1_AF1_BKINP_Field is
     (--  TIMx_BKIN input polarity is not inverted (active low if BKP = 0, active
--  high if BKP = 1)
      B_0x0,
      --  TIMx_BKIN input polarity is inverted (active high if BKP = 0, active low if
--  BKP = 1)
      B_0x1)
     with Size => 1;
   for TIM1_AF1_BKINP_Field use
     (B_0x0 => 0,
      B_0x1 => 1);

   --  tim_brk_cmp1 input polarity 	
   type TIM1_AF1_BKCMP1P_Field is
     (--  tim_brk_cmp1 input polarity is not inverted (active low if BKP = 0, active
--  high if BKP = 1)
      B_0x0,
      --  tim_brk_cmp1 input polarity is inverted (active high if BKP = 0, active low
--  if BKP = 1)
      B_0x1)
     with Size => 1;
   for TIM1_AF1_BKCMP1P_Field use
     (B_0x0 => 0,
      B_0x1 => 1);

   --  tim_brk_cmp2 input polarity 	
   type TIM1_AF1_BKCMP2P_Field is
     (--  tim_brk_cmp2 input polarity is not inverted (active low if BKP = 0, active
--  high if BKP = 1)
      B_0x0,
      --  tim_brk_cmp2 input polarity is inverted (active high if BKP = 0, active low
--  if BKP = 1)
      B_0x1)
     with Size => 1;
   for TIM1_AF1_BKCMP2P_Field use
     (B_0x0 => 0,
      B_0x1 => 1);

   --  tim_brk_cmp3 input polarity 	
   type TIM1_AF1_BKCMP3P_Field is
     (--  tim_brk_cmp3 input polarity is not inverted (active low if BKP = 0, active
--  high if BKP = 1)
      B_0x0,
      --  tim_brk_cmp3 input polarity is inverted (active high if BKP = 0, active low
--  if BKP = 1)
      B_0x1)
     with Size => 1;
   for TIM1_AF1_BKCMP3P_Field use
     (B_0x0 => 0,
      B_0x1 => 1);

   --  tim_brk_cmp4 input polarity 	
   type TIM1_AF1_BKCMP4P_Field is
     (--  tim_brk_cmp4 input polarity is not inverted (active low if BKP = 0, active
--  high if BKP = 1)
      B_0x0,
      --  tim_brk_cmp4 input polarity is inverted (active high if BKP = 0, active low
--  if BKP = 1)
      B_0x1)
     with Size => 1;
   for TIM1_AF1_BKCMP4P_Field use
     (B_0x0 => 0,
      B_0x1 => 1);

   --  etr_in source selection 	
   type TIM1_AF1_ETRSEL_Field is
     (--  tim_etr0: TIMx_ETR input
      B_0x0,
      --  tim_etr1
      B_0x1,
      --  tim_etr15
      B_0xF)
     with Size => 4;
   for TIM1_AF1_ETRSEL_Field use
     (B_0x0 => 0,
      B_0x1 => 1,
      B_0xF => 15);

   --  TIM1 alternate function option register 1
   type TIM1_AF1_Register is record
      --  TIMx_BKIN input enable 	
      BKINE          : TIM1_AF1_BKINE_Field := STM32G4_SVD.TIM.B_0x1;
      --  tim_brk_cmp1 enable 	
      BKCMP1E        : TIM1_AF1_BKCMP1E_Field := STM32G4_SVD.TIM.B_0x0;
      --  tim_brk_cmp2 enable 	
      BKCMP2E        : TIM1_AF1_BKCMP2E_Field := STM32G4_SVD.TIM.B_0x0;
      --  tim_brk_cmp3 enable 	
      BKCMP3E        : TIM1_AF1_BKCMP3E_Field := STM32G4_SVD.TIM.B_0x0;
      --  tim_brk_cmp4 enable 	
      BKCMP4E        : TIM1_AF1_BKCMP4E_Field := STM32G4_SVD.TIM.B_0x0;
      --  tim_brk_cmp5 enable 	
      BKCMP5E        : TIM1_AF1_BKCMP5E_Field := STM32G4_SVD.TIM.B_0x0;
      --  tim_brk_cmp6 enable 	
      BKCMP6E        : TIM1_AF1_BKCMP6E_Field := STM32G4_SVD.TIM.B_0x0;
      --  tim_brk_cmp7 enable 	
      BKCMP7E        : TIM1_AF1_BKCMP7E_Field := STM32G4_SVD.TIM.B_0x0;
      --  tim_brk_cmp8 enable 	
      BKCMP8E        : TIM1_AF1_BKCMP8E_Field := STM32G4_SVD.TIM.B_0x0;
      --  TIMx_BKIN input polarity 	
      BKINP          : TIM1_AF1_BKINP_Field := STM32G4_SVD.TIM.B_0x0;
      --  tim_brk_cmp1 input polarity 	
      BKCMP1P        : TIM1_AF1_BKCMP1P_Field := STM32G4_SVD.TIM.B_0x0;
      --  tim_brk_cmp2 input polarity 	
      BKCMP2P        : TIM1_AF1_BKCMP2P_Field := STM32G4_SVD.TIM.B_0x0;
      --  tim_brk_cmp3 input polarity 	
      BKCMP3P        : TIM1_AF1_BKCMP3P_Field := STM32G4_SVD.TIM.B_0x0;
      --  tim_brk_cmp4 input polarity 	
      BKCMP4P        : TIM1_AF1_BKCMP4P_Field := STM32G4_SVD.TIM.B_0x0;
      --  etr_in source selection 	
      ETRSEL         : TIM1_AF1_ETRSEL_Field := STM32G4_SVD.TIM.B_0x0;
      --  unspecified
      Reserved_18_31 : STM32G4_SVD.UInt14 := 16#0#;
   end record
     with Volatile_Full_Access, Object_Size => 32,
          Bit_Order => System.Low_Order_First;

   for TIM1_AF1_Register use record
      BKINE          at 0 range 0 .. 0;
      BKCMP1E        at 0 range 1 .. 1;
      BKCMP2E        at 0 range 2 .. 2;
      BKCMP3E        at 0 range 3 .. 3;
      BKCMP4E        at 0 range 4 .. 4;
      BKCMP5E        at 0 range 5 .. 5;
      BKCMP6E        at 0 range 6 .. 6;
      BKCMP7E        at 0 range 7 .. 7;
      BKCMP8E        at 0 range 8 .. 8;
      BKINP          at 0 range 9 .. 9;
      BKCMP1P        at 0 range 10 .. 10;
      BKCMP2P        at 0 range 11 .. 11;
      BKCMP3P        at 0 range 12 .. 12;
      BKCMP4P        at 0 range 13 .. 13;
      ETRSEL         at 0 range 14 .. 17;
      Reserved_18_31 at 0 range 18 .. 31;
   end record;

   --  TIMx_BKIN2 input enable 	
   type TIM1_AF2_BK2INE_Field is
     (--  TIMx_BKIN2 input disabled
      B_0x0,
      --  TIMx_BKIN2 input enabled
      B_0x1)
     with Size => 1;
   for TIM1_AF2_BK2INE_Field use
     (B_0x0 => 0,
      B_0x1 => 1);

   --  tim_brk2_cmp1 enable 	
   type TIM1_AF2_BK2CMP1E_Field is
     (--  tim_brk2_cmp1 input disabled
      B_0x0,
      --  tim_brk2_cmp1 input enabled
      B_0x1)
     with Size => 1;
   for TIM1_AF2_BK2CMP1E_Field use
     (B_0x0 => 0,
      B_0x1 => 1);

   --  tim_brk2_cmp2 enable 	
   type TIM1_AF2_BK2CMP2E_Field is
     (--  tim_brk2_cmp2 input disabled
      B_0x0,
      --  tim_brk2_cmp2 input enabled
      B_0x1)
     with Size => 1;
   for TIM1_AF2_BK2CMP2E_Field use
     (B_0x0 => 0,
      B_0x1 => 1);

   --  tim_brk2_cmp3 enable 	
   type TIM1_AF2_BK2CMP3E_Field is
     (--  tim_brk2_cmp3 input disabled
      B_0x0,
      --  tim_brk2_cmp3 input enabled
      B_0x1)
     with Size => 1;
   for TIM1_AF2_BK2CMP3E_Field use
     (B_0x0 => 0,
      B_0x1 => 1);

   --  tim_brk2_cmp4 enable 	
   type TIM1_AF2_BK2CMP4E_Field is
     (--  tim_brk2_cmp4 input disabled
      B_0x0,
      --  tim_brk2_cmp4 input enabled
      B_0x1)
     with Size => 1;
   for TIM1_AF2_BK2CMP4E_Field use
     (B_0x0 => 0,
      B_0x1 => 1);

   --  tim_brk2_cmp5 enable 	
   type TIM1_AF2_BK2CMP5E_Field is
     (--  tim_brk2_cmp5 input disabled
      B_0x0,
      --  tim_brk2_cmp5 input enabled
      B_0x1)
     with Size => 1;
   for TIM1_AF2_BK2CMP5E_Field use
     (B_0x0 => 0,
      B_0x1 => 1);

   --  tim_brk2_cmp6 enable 	
   type TIM1_AF2_BK2CMP6E_Field is
     (--  tim_brk2_cmp6 input disabled
      B_0x0,
      --  tim_brk2_cmp6 input enabled
      B_0x1)
     with Size => 1;
   for TIM1_AF2_BK2CMP6E_Field use
     (B_0x0 => 0,
      B_0x1 => 1);

   --  tim_brk2_cmp7 enable 	
   type TIM1_AF2_BK2CMP7E_Field is
     (--  tim_brk2_cmp7 input disabled
      B_0x0,
      --  tim_brk2_cmp7 input enabled
      B_0x1)
     with Size => 1;
   for TIM1_AF2_BK2CMP7E_Field use
     (B_0x0 => 0,
      B_0x1 => 1);

   --  tim_brk2_cmp8 enable 	
   type TIM1_AF2_BK2CMP8E_Field is
     (--  tim_brk2_cmp8 input disabled
      B_0x0,
      --  tim_brk2_cmp8 input enabled
      B_0x1)
     with Size => 1;
   for TIM1_AF2_BK2CMP8E_Field use
     (B_0x0 => 0,
      B_0x1 => 1);

   --  TIMx_BKIN2 input polarity 	
   type TIM1_AF2_BK2INP_Field is
     (--  TIMx_BKIN2 input polarity is not inverted (active low if BK2P = 0, active
--  high if BK2P = 1)
      B_0x0,
      --  TIMx_BKIN2 input polarity is inverted (active high if BK2P = 0, active low
--  if BK2P = 1)
      B_0x1)
     with Size => 1;
   for TIM1_AF2_BK2INP_Field use
     (B_0x0 => 0,
      B_0x1 => 1);

   --  tim_brk2_cmp1 input polarity 	
   type TIM1_AF2_BK2CMP1P_Field is
     (--  tim_brk2_cmp1 input polarity is not inverted (active low if BK2P = 0,
--  active high if BK2P = 1)
      B_0x0,
      --  tim_brk2_cmp1 input polarity is inverted (active high if BK2P = 0, active
--  low if BK2P = 1)
      B_0x1)
     with Size => 1;
   for TIM1_AF2_BK2CMP1P_Field use
     (B_0x0 => 0,
      B_0x1 => 1);

   --  tim_brk2_cmp2 input polarity 	
   type TIM1_AF2_BK2CMP2P_Field is
     (--  tim_brk2_cmp2 input polarity is not inverted (active low if BK2P = 0,
--  active high if BK2P = 1)
      B_0x0,
      --  tim_brk2_cmp2 input polarity is inverted (active high if BK2P = 0, active
--  low if BK2P = 1)
      B_0x1)
     with Size => 1;
   for TIM1_AF2_BK2CMP2P_Field use
     (B_0x0 => 0,
      B_0x1 => 1);

   --  tim_brk2_cmp3 input polarity 	
   type TIM1_AF2_BK2CMP3P_Field is
     (--  tim_brk2_cmp3 input polarity is not inverted (active low if BK2P = 0,
--  active high if BK2P = 1)
      B_0x0,
      --  tim_brk2_cmp3 input polarity is inverted (active high if BK2P = 0, active
--  low if BK2P = 1)
      B_0x1)
     with Size => 1;
   for TIM1_AF2_BK2CMP3P_Field use
     (B_0x0 => 0,
      B_0x1 => 1);

   --  tim_brk2_cmp4 input polarity 	
   type TIM1_AF2_BK2CMP4P_Field is
     (--  tim_brk2_cmp4 input polarity is not inverted (active low if BK2P = 0,
--  active high if BK2P = 1)
      B_0x0,
      --  tim_brk2_cmp4 input polarity is inverted (active high if BK2P = 0, active
--  low if BK2P = 1)
      B_0x1)
     with Size => 1;
   for TIM1_AF2_BK2CMP4P_Field use
     (B_0x0 => 0,
      B_0x1 => 1);

   --  ocref_clr source selection 	
   type TIM1_AF2_OCRSEL_Field is
     (--  tim_ocref_clr0
      B_0x0,
      --  tim_ocref_clr1
      B_0x1,
      --  tim_ocref_clr7
      B_0x7)
     with Size => 3;
   for TIM1_AF2_OCRSEL_Field use
     (B_0x0 => 0,
      B_0x1 => 1,
      B_0x7 => 7);

   --  TIM1 alternate function register 2
   type TIM1_AF2_Register is record
      --  TIMx_BKIN2 input enable 	
      BK2INE         : TIM1_AF2_BK2INE_Field := STM32G4_SVD.TIM.B_0x1;
      --  tim_brk2_cmp1 enable 	
      BK2CMP1E       : TIM1_AF2_BK2CMP1E_Field := STM32G4_SVD.TIM.B_0x0;
      --  tim_brk2_cmp2 enable 	
      BK2CMP2E       : TIM1_AF2_BK2CMP2E_Field := STM32G4_SVD.TIM.B_0x0;
      --  tim_brk2_cmp3 enable 	
      BK2CMP3E       : TIM1_AF2_BK2CMP3E_Field := STM32G4_SVD.TIM.B_0x0;
      --  tim_brk2_cmp4 enable 	
      BK2CMP4E       : TIM1_AF2_BK2CMP4E_Field := STM32G4_SVD.TIM.B_0x0;
      --  tim_brk2_cmp5 enable 	
      BK2CMP5E       : TIM1_AF2_BK2CMP5E_Field := STM32G4_SVD.TIM.B_0x0;
      --  tim_brk2_cmp6 enable 	
      BK2CMP6E       : TIM1_AF2_BK2CMP6E_Field := STM32G4_SVD.TIM.B_0x0;
      --  tim_brk2_cmp7 enable 	
      BK2CMP7E       : TIM1_AF2_BK2CMP7E_Field := STM32G4_SVD.TIM.B_0x0;
      --  tim_brk2_cmp8 enable 	
      BK2CMP8E       : TIM1_AF2_BK2CMP8E_Field := STM32G4_SVD.TIM.B_0x0;
      --  TIMx_BKIN2 input polarity 	
      BK2INP         : TIM1_AF2_BK2INP_Field := STM32G4_SVD.TIM.B_0x0;
      --  tim_brk2_cmp1 input polarity 	
      BK2CMP1P       : TIM1_AF2_BK2CMP1P_Field := STM32G4_SVD.TIM.B_0x0;
      --  tim_brk2_cmp2 input polarity 	
      BK2CMP2P       : TIM1_AF2_BK2CMP2P_Field := STM32G4_SVD.TIM.B_0x0;
      --  tim_brk2_cmp3 input polarity 	
      BK2CMP3P       : TIM1_AF2_BK2CMP3P_Field := STM32G4_SVD.TIM.B_0x0;
      --  tim_brk2_cmp4 input polarity 	
      BK2CMP4P       : TIM1_AF2_BK2CMP4P_Field := STM32G4_SVD.TIM.B_0x0;
      --  unspecified
      Reserved_14_15 : STM32G4_SVD.UInt2 := 16#0#;
      --  ocref_clr source selection 	
      OCRSEL         : TIM1_AF2_OCRSEL_Field := STM32G4_SVD.TIM.B_0x0;
      --  unspecified
      Reserved_19_31 : STM32G4_SVD.UInt13 := 16#0#;
   end record
     with Volatile_Full_Access, Object_Size => 32,
          Bit_Order => System.Low_Order_First;

   for TIM1_AF2_Register use record
      BK2INE         at 0 range 0 .. 0;
      BK2CMP1E       at 0 range 1 .. 1;
      BK2CMP2E       at 0 range 2 .. 2;
      BK2CMP3E       at 0 range 3 .. 3;
      BK2CMP4E       at 0 range 4 .. 4;
      BK2CMP5E       at 0 range 5 .. 5;
      BK2CMP6E       at 0 range 6 .. 6;
      BK2CMP7E       at 0 range 7 .. 7;
      BK2CMP8E       at 0 range 8 .. 8;
      BK2INP         at 0 range 9 .. 9;
      BK2CMP1P       at 0 range 10 .. 10;
      BK2CMP2P       at 0 range 11 .. 11;
      BK2CMP3P       at 0 range 12 .. 12;
      BK2CMP4P       at 0 range 13 .. 13;
      Reserved_14_15 at 0 range 14 .. 15;
      OCRSEL         at 0 range 16 .. 18;
      Reserved_19_31 at 0 range 19 .. 31;
   end record;

   --  DMA base address 	
   type TIM1_DCR_DBA_Field is
     (--  TIMx_CR1
      B_0x0,
      --  TIMx_CR2
      B_0x1,
      --  TIMx_SMCR
      B_0x2)
     with Size => 5;
   for TIM1_DCR_DBA_Field use
     (B_0x0 => 0,
      B_0x1 => 1,
      B_0x2 => 2);

   --  DMA burst length 	
   type TIM1_DCR_DBL_Field is
     (--  1 transfer
      B_0x0,
      --  2 transfers
      B_0x1,
      --  3 transfers
      B_0x2,
      --  26 transfers
      B_0x1A)
     with Size => 5;
   for TIM1_DCR_DBL_Field use
     (B_0x0 => 0,
      B_0x1 => 1,
      B_0x2 => 2,
      B_0x1A => 26);

   --  TIM1 DMA control register
   type TIM1_DCR_Register is record
      --  DMA base address 	
      DBA            : TIM1_DCR_DBA_Field := STM32G4_SVD.TIM.B_0x0;
      --  unspecified
      Reserved_5_7   : STM32G4_SVD.UInt3 := 16#0#;
      --  DMA burst length 	
      DBL            : TIM1_DCR_DBL_Field := STM32G4_SVD.TIM.B_0x0;
      --  unspecified
      Reserved_13_31 : STM32G4_SVD.UInt19 := 16#0#;
   end record
     with Volatile_Full_Access, Object_Size => 32,
          Bit_Order => System.Low_Order_First;

   for TIM1_DCR_Register use record
      DBA            at 0 range 0 .. 4;
      Reserved_5_7   at 0 range 5 .. 7;
      DBL            at 0 range 8 .. 12;
      Reserved_13_31 at 0 range 13 .. 31;
   end record;

   --  Counter enable
   type TIM2_CR1_CEN_Field is
     (--  Counter disabled
      B_0x0,
      --  Counter enabled
      B_0x1)
     with Size => 1;
   for TIM2_CR1_CEN_Field use
     (B_0x0 => 0,
      B_0x1 => 1);

   --  Update disable
   type TIM2_CR1_UDIS_Field is
     (--  UEV enabled.
      B_0x0,
      --  UEV disabled.
      B_0x1)
     with Size => 1;
   for TIM2_CR1_UDIS_Field use
     (B_0x0 => 0,
      B_0x1 => 1);

   --  Update request source
   type TIM2_CR1_URS_Field is
     (--  Any of the following events generate an update interrupt or DMA request if
--  enabled.
      B_0x0,
      --  Only counter overflow/underflow generates an update interrupt or DMA
--  request if enabled.
      B_0x1)
     with Size => 1;
   for TIM2_CR1_URS_Field use
     (B_0x0 => 0,
      B_0x1 => 1);

   --  One-pulse mode
   type TIM2_CR1_OPM_Field is
     (--  Counter is not stopped at update event
      B_0x0,
      --  Counter stops counting at the next update event (clearing the bit CEN)
      B_0x1)
     with Size => 1;
   for TIM2_CR1_OPM_Field use
     (B_0x0 => 0,
      B_0x1 => 1);

   --  Direction
   type TIM2_CR1_DIR_Field is
     (--  Counter used as upcounter
      B_0x0,
      --  Counter used as downcounter
      B_0x1)
     with Size => 1;
   for TIM2_CR1_DIR_Field use
     (B_0x0 => 0,
      B_0x1 => 1);

   --  Center-aligned mode selection
   type TIM2_CR1_CMS_Field is
     (--  Edge-aligned mode.
      B_0x0,
      --  Center-aligned mode 1.
      B_0x1,
      --  Center-aligned mode 2.
      B_0x2,
      --  Center-aligned mode 3.
      B_0x3)
     with Size => 2;
   for TIM2_CR1_CMS_Field use
     (B_0x0 => 0,
      B_0x1 => 1,
      B_0x2 => 2,
      B_0x3 => 3);

   --  Auto-reload preload enable
   type TIM2_CR1_ARPE_Field is
     (--  TIMx_ARR register is not buffered
      B_0x0,
      --  TIMx_ARR register is buffered
      B_0x1)
     with Size => 1;
   for TIM2_CR1_ARPE_Field use
     (B_0x0 => 0,
      B_0x1 => 1);

   --  Clock division
   type TIM2_CR1_CKD_Field is
     (--  tless thansub>DTSless than/sub>
      B_0x0,
      --  tless thansub>DTSless than/sub>
      B_0x1,
      --  tless thansub>DTSless than/sub>
      B_0x2)
     with Size => 2;
   for TIM2_CR1_CKD_Field use
     (B_0x0 => 0,
      B_0x1 => 1,
      B_0x2 => 2);

   --  UIF status bit remapping
   type TIM2_CR1_UIFREMAP_Field is
     (--  No remapping.
      B_0x0,
      --  Remapping enabled.
      B_0x1)
     with Size => 1;
   for TIM2_CR1_UIFREMAP_Field use
     (B_0x0 => 0,
      B_0x1 => 1);

   --  Dithering Enable
   type TIM2_CR1_DITHEN_Field is
     (--  Dithering disabled
      B_0x0,
      --  Dithering enabled
      B_0x1)
     with Size => 1;
   for TIM2_CR1_DITHEN_Field use
     (B_0x0 => 0,
      B_0x1 => 1);

   --  TIM2 control register 1
   type TIM2_CR1_Register is record
      --  Counter enable
      CEN            : TIM2_CR1_CEN_Field := STM32G4_SVD.TIM.B_0x0;
      --  Update disable
      UDIS           : TIM2_CR1_UDIS_Field := STM32G4_SVD.TIM.B_0x0;
      --  Update request source
      URS            : TIM2_CR1_URS_Field := STM32G4_SVD.TIM.B_0x0;
      --  One-pulse mode
      OPM            : TIM2_CR1_OPM_Field := STM32G4_SVD.TIM.B_0x0;
      --  Direction
      DIR            : TIM2_CR1_DIR_Field := STM32G4_SVD.TIM.B_0x0;
      --  Center-aligned mode selection
      CMS            : TIM2_CR1_CMS_Field := STM32G4_SVD.TIM.B_0x0;
      --  Auto-reload preload enable
      ARPE           : TIM2_CR1_ARPE_Field := STM32G4_SVD.TIM.B_0x0;
      --  Clock division
      CKD            : TIM2_CR1_CKD_Field := STM32G4_SVD.TIM.B_0x0;
      --  unspecified
      Reserved_10_10 : STM32G4_SVD.Bit := 16#0#;
      --  UIF status bit remapping
      UIFREMAP       : TIM2_CR1_UIFREMAP_Field := STM32G4_SVD.TIM.B_0x0;
      --  Dithering Enable
      DITHEN         : TIM2_CR1_DITHEN_Field := STM32G4_SVD.TIM.B_0x0;
      --  unspecified
      Reserved_13_15 : STM32G4_SVD.UInt3 := 16#0#;
   end record
     with Volatile_Full_Access, Object_Size => 16,
          Bit_Order => System.Low_Order_First;

   for TIM2_CR1_Register use record
      CEN            at 0 range 0 .. 0;
      UDIS           at 0 range 1 .. 1;
      URS            at 0 range 2 .. 2;
      OPM            at 0 range 3 .. 3;
      DIR            at 0 range 4 .. 4;
      CMS            at 0 range 5 .. 6;
      ARPE           at 0 range 7 .. 7;
      CKD            at 0 range 8 .. 9;
      Reserved_10_10 at 0 range 10 .. 10;
      UIFREMAP       at 0 range 11 .. 11;
      DITHEN         at 0 range 12 .. 12;
      Reserved_13_15 at 0 range 13 .. 15;
   end record;

   --  Capture/compare DMA selection
   type TIM2_CR2_CCDS_Field is
     (--  CCx DMA request sent when CCx event occurs
      B_0x0,
      --  CCx DMA requests sent when update event occurs
      B_0x1)
     with Size => 1;
   for TIM2_CR2_CCDS_Field use
     (B_0x0 => 0,
      B_0x1 => 1);

   --  MMS[0]: Master mode selection
   type TIM2_CR2_MMS_Field is
     (--  Reset - the UG bit from the TIMx_EGR register is used as trigger output
--  (tim_trgo).
      B_0x0,
      --  Enable - the Counter enable signal, CNT_EN, is used as trigger output
--  (tim_trgo).
      B_0x1,
      --  Update - The update event is selected as trigger output (tim_trgo).
      B_0x2,
      --  Compare Pulse - The trigger output send a positive pulse when the CC1IF
--  flag is to be set (even if it was already high), as soon as a capture or a
--  compare match occurred (tim_trgo).
      B_0x3,
      --  Compare - tim_oc1refc signal is used as trigger output (tim_trgo)
      B_0x4,
      --  Compare - tim_oc2refc signal is used as trigger output (tim_trgo)
      B_0x5,
      --  Compare - tim_oc3refc signal is used as trigger output (tim_trgo)
      B_0x6,
      --  Compare - tim_oc4refc signal is used as trigger output (tim_trgo)
      B_0x7)
     with Size => 3;
   for TIM2_CR2_MMS_Field use
     (B_0x0 => 0,
      B_0x1 => 1,
      B_0x2 => 2,
      B_0x3 => 3,
      B_0x4 => 4,
      B_0x5 => 5,
      B_0x6 => 6,
      B_0x7 => 7);

   --  tim_ti1 selection
   type TIM2_CR2_TI1S_Field is
     (--  The tim_ti1_in[15:0] multiplexer output is to tim_ti1 input
      B_0x0,
      --  The tim_ti1_in[15:0], tim_ti2_in[15:0] and tim_ti3_in[15:0] multiplexers
--  outputs are XORed and connected to the tim_ti1 input.
      B_0x1)
     with Size => 1;
   for TIM2_CR2_TI1S_Field use
     (B_0x0 => 0,
      B_0x1 => 1);

   --  TIM2 control register 2
   type TIM2_CR2_Register is record
      --  unspecified
      Reserved_0_2   : STM32G4_SVD.UInt3 := 16#0#;
      --  Capture/compare DMA selection
      CCDS           : TIM2_CR2_CCDS_Field := STM32G4_SVD.TIM.B_0x0;
      --  MMS[0]: Master mode selection
      MMS            : TIM2_CR2_MMS_Field := STM32G4_SVD.TIM.B_0x0;
      --  tim_ti1 selection
      TI1S           : TIM2_CR2_TI1S_Field := STM32G4_SVD.TIM.B_0x0;
      --  unspecified
      Reserved_8_24  : STM32G4_SVD.UInt17 := 16#0#;
      --  MMS[3]
      MMS_1          : Boolean := False;
      --  unspecified
      Reserved_26_31 : STM32G4_SVD.UInt6 := 16#0#;
   end record
     with Volatile_Full_Access, Object_Size => 32,
          Bit_Order => System.Low_Order_First;

   for TIM2_CR2_Register use record
      Reserved_0_2   at 0 range 0 .. 2;
      CCDS           at 0 range 3 .. 3;
      MMS            at 0 range 4 .. 6;
      TI1S           at 0 range 7 .. 7;
      Reserved_8_24  at 0 range 8 .. 24;
      MMS_1          at 0 range 25 .. 25;
      Reserved_26_31 at 0 range 26 .. 31;
   end record;

   --  SMS[0]: Slave mode selection
   type TIM2_SMCR_SMS_Field is
     (--  Slave mode disabled - if CEN = 1 then the prescaler is clocked directly by
--  the internal clock.
      B_0x0,
      --  Encoder mode 1 - Counter counts up/down on tim_ti1fp1 edge depending on
--  tim_ti2fp2 level.
      B_0x1,
      --  Encoder mode 2 - Counter counts up/down on tim_ti2fp2 edge depending on
--  tim_ti1fp1 level.
      B_0x2,
      --  Encoder mode 3 - Counter counts up/down on both tim_ti1fp1 and tim_ti2fp2
--  edges depending on the level of the other input.
      B_0x3,
      --  Reset Mode - Rising edge of the selected trigger input (tim_trgi)
--  reinitializes the counter and generates an update of the registers.
      B_0x4,
      --  Gated Mode - The counter clock is enabled when the trigger input (tim_trgi)
--  is high.
      B_0x5,
      --  Trigger Mode - The counter starts at a rising edge of the trigger tim_trgi
--  (but it is not reset).
      B_0x6,
      --  External Clock Mode 1 - Rising edges of the selected trigger (tim_trgi)
--  clock the counter.
      B_0x7)
     with Size => 3;
   for TIM2_SMCR_SMS_Field use
     (B_0x0 => 0,
      B_0x1 => 1,
      B_0x2 => 2,
      B_0x3 => 3,
      B_0x4 => 4,
      B_0x5 => 5,
      B_0x6 => 6,
      B_0x7 => 7);

   --  OCREF clear selection
   type TIM2_SMCR_OCCS_Field is
     (--  tim_ocref_clr_int is connected to the tim_ocref_clr input
      B_0x0,
      --  tim_ocref_clr_int is connected to tim_etrf
      B_0x1)
     with Size => 1;
   for TIM2_SMCR_OCCS_Field use
     (B_0x0 => 0,
      B_0x1 => 1);

   --  TS[0]: Trigger selection
   type TIM2_SMCR_TS_Field is
     (--  Internal trigger 0 (tim_itr0)
      B_0x0,
      --  Internal trigger 1 (tim_itr1)
      B_0x1,
      --  Internal trigger 2 (tim_itr2)
      B_0x2,
      --  Internal trigger 3 (tim_itr3)
      B_0x3,
      --  tim_ti1 edge detector (tim_ti1f_ed)
      B_0x4,
      --  Filtered timer input 1 (tim_ti1fp1)
      B_0x5,
      --  Filtered timer input 2 (tim_ti2fp2)
      B_0x6,
      --  External trigger input (tim_etrf)
      B_0x7)
     with Size => 3;
   for TIM2_SMCR_TS_Field use
     (B_0x0 => 0,
      B_0x1 => 1,
      B_0x2 => 2,
      B_0x3 => 3,
      B_0x4 => 4,
      B_0x5 => 5,
      B_0x6 => 6,
      B_0x7 => 7);

   --  Master/Slave mode
   type TIM2_SMCR_MSM_Field is
     (--  No action
      B_0x0,
      --  The effect of an event on the trigger input (tim_trgi) is delayed to allow
--  a perfect synchronization between the current timer and its slaves (through
--  tim_trgo).
      B_0x1)
     with Size => 1;
   for TIM2_SMCR_MSM_Field use
     (B_0x0 => 0,
      B_0x1 => 1);

   --  External trigger filter
   type TIM2_SMCR_ETF_Field is
     (--  No filter, sampling is done at fless thansub>DTSless than/sub>
      B_0x0,
      --  fless thansub>SAMPLINGless than/sub>=fless thansub>tim_ker_ckless
--  than/sub>, N=2
      B_0x1,
      --  fless thansub>SAMPLINGless than/sub>=fless thansub>tim_ker_ckless
--  than/sub>, N=4
      B_0x2,
      --  fless thansub>SAMPLINGless than/sub>=fless thansub>tim_ker_ckless
--  than/sub>, N=8
      B_0x3,
      --  fless thansub>SAMPLINGless than/sub>=fless thansub>DTSless than/sub>/2, N=6
      B_0x4,
      --  fless thansub>SAMPLINGless than/sub>=fless thansub>DTSless than/sub>/2, N=8
      B_0x5,
      --  fless thansub>SAMPLINGless than/sub>=fless thansub>DTSless than/sub>/4, N=6
      B_0x6,
      --  fless thansub>SAMPLINGless than/sub>=fless thansub>DTSless than/sub>/4, N=8
      B_0x7,
      --  fless thansub>SAMPLINGless than/sub>=fless thansub>DTSless than/sub>/8, N=6
      B_0x8,
      --  fless thansub>SAMPLINGless than/sub>=fless thansub>DTSless than/sub>/8, N=8
      B_0x9,
      --  fless thansub>SAMPLINGless than/sub>=fless thansub>DTSless than/sub>/16,
--  N=5
      B_0xA,
      --  fless thansub>SAMPLINGless than/sub>=fless thansub>DTSless than/sub>/16,
--  N=6
      B_0xB,
      --  fless thansub>SAMPLINGless than/sub>=fless thansub>DTSless than/sub>/16,
--  N=8
      B_0xC,
      --  fless thansub>SAMPLINGless than/sub>=fless thansub>DTSless than/sub>/32,
--  N=5
      B_0xD,
      --  fless thansub>SAMPLINGless than/sub>=fless thansub>DTSless than/sub>/32,
--  N=6
      B_0xE,
      --  fless thansub>SAMPLINGless than/sub>=fless thansub>DTSless than/sub>/32,
--  N=8
      B_0xF)
     with Size => 4;
   for TIM2_SMCR_ETF_Field use
     (B_0x0 => 0,
      B_0x1 => 1,
      B_0x2 => 2,
      B_0x3 => 3,
      B_0x4 => 4,
      B_0x5 => 5,
      B_0x6 => 6,
      B_0x7 => 7,
      B_0x8 => 8,
      B_0x9 => 9,
      B_0xA => 10,
      B_0xB => 11,
      B_0xC => 12,
      B_0xD => 13,
      B_0xE => 14,
      B_0xF => 15);

   --  External trigger prescaler
   type TIM2_SMCR_ETPS_Field is
     (--  Prescaler OFF
      B_0x0,
      --  tim_etrp frequency divided by 2
      B_0x1,
      --  tim_etrp frequency divided by 4
      B_0x2,
      --  tim_etrp frequency divided by 8
      B_0x3)
     with Size => 2;
   for TIM2_SMCR_ETPS_Field use
     (B_0x0 => 0,
      B_0x1 => 1,
      B_0x2 => 2,
      B_0x3 => 3);

   --  External clock enable
   type TIM2_SMCR_ECE_Field is
     (--  External clock mode 2 disabled
      B_0x0,
      --  External clock mode 2 enabled.
      B_0x1)
     with Size => 1;
   for TIM2_SMCR_ECE_Field use
     (B_0x0 => 0,
      B_0x1 => 1);

   --  External trigger polarity
   type TIM2_SMCR_ETP_Field is
     (--  tim_etr_in is non-inverted, active at high level or rising edge
      B_0x0,
      --  tim_etr_in is inverted, active at low level or falling edge
      B_0x1)
     with Size => 1;
   for TIM2_SMCR_ETP_Field use
     (B_0x0 => 0,
      B_0x1 => 1);

   subtype TIM2_SMCR_TS_1_Field is STM32G4_SVD.UInt2;

   --  SMS preload enable
   type TIM2_SMCR_SMSPE_Field is
     (--  SMS[3:0] bitfield is not preloaded
      B_0x0,
      --  SMS[3:0] preload is enabled
      B_0x1)
     with Size => 1;
   for TIM2_SMCR_SMSPE_Field use
     (B_0x0 => 0,
      B_0x1 => 1);

   --  SMS preload source
   type TIM2_SMCR_SMSPS_Field is
     (--  The transfer is triggered by the Timer's Update event
      B_0x0,
      --  The transfer is triggered by the Index event
      B_0x1)
     with Size => 1;
   for TIM2_SMCR_SMSPS_Field use
     (B_0x0 => 0,
      B_0x1 => 1);

   --  TIM2 slave mode control register
   type TIM2_SMCR_Register is record
      --  SMS[0]: Slave mode selection
      SMS            : TIM2_SMCR_SMS_Field := STM32G4_SVD.TIM.B_0x0;
      --  OCREF clear selection
      OCCS           : TIM2_SMCR_OCCS_Field := STM32G4_SVD.TIM.B_0x0;
      --  TS[0]: Trigger selection
      TS             : TIM2_SMCR_TS_Field := STM32G4_SVD.TIM.B_0x0;
      --  Master/Slave mode
      MSM            : TIM2_SMCR_MSM_Field := STM32G4_SVD.TIM.B_0x0;
      --  External trigger filter
      ETF            : TIM2_SMCR_ETF_Field := STM32G4_SVD.TIM.B_0x0;
      --  External trigger prescaler
      ETPS           : TIM2_SMCR_ETPS_Field := STM32G4_SVD.TIM.B_0x0;
      --  External clock enable
      ECE            : TIM2_SMCR_ECE_Field := STM32G4_SVD.TIM.B_0x0;
      --  External trigger polarity
      ETP            : TIM2_SMCR_ETP_Field := STM32G4_SVD.TIM.B_0x0;
      --  SMS[3]
      SMS_1          : Boolean := False;
      --  unspecified
      Reserved_17_19 : STM32G4_SVD.UInt3 := 16#0#;
      --  TS[4:3]
      TS_1           : TIM2_SMCR_TS_1_Field := 16#0#;
      --  unspecified
      Reserved_22_23 : STM32G4_SVD.UInt2 := 16#0#;
      --  SMS preload enable
      SMSPE          : TIM2_SMCR_SMSPE_Field := STM32G4_SVD.TIM.B_0x0;
      --  SMS preload source
      SMSPS          : TIM2_SMCR_SMSPS_Field := STM32G4_SVD.TIM.B_0x0;
      --  unspecified
      Reserved_26_31 : STM32G4_SVD.UInt6 := 16#0#;
   end record
     with Volatile_Full_Access, Object_Size => 32,
          Bit_Order => System.Low_Order_First;

   for TIM2_SMCR_Register use record
      SMS            at 0 range 0 .. 2;
      OCCS           at 0 range 3 .. 3;
      TS             at 0 range 4 .. 6;
      MSM            at 0 range 7 .. 7;
      ETF            at 0 range 8 .. 11;
      ETPS           at 0 range 12 .. 13;
      ECE            at 0 range 14 .. 14;
      ETP            at 0 range 15 .. 15;
      SMS_1          at 0 range 16 .. 16;
      Reserved_17_19 at 0 range 17 .. 19;
      TS_1           at 0 range 20 .. 21;
      Reserved_22_23 at 0 range 22 .. 23;
      SMSPE          at 0 range 24 .. 24;
      SMSPS          at 0 range 25 .. 25;
      Reserved_26_31 at 0 range 26 .. 31;
   end record;

   --  Update interrupt enable
   type TIM2_DIER_UIE_Field is
     (--  Update interrupt disabled.
      B_0x0,
      --  Update interrupt enabled.
      B_0x1)
     with Size => 1;
   for TIM2_DIER_UIE_Field use
     (B_0x0 => 0,
      B_0x1 => 1);

   --  Capture/Compare 1 interrupt enable
   type TIM2_DIER_CC1IE_Field is
     (--  CC1 interrupt disabled.
      B_0x0,
      --  CC1 interrupt enabled.
      B_0x1)
     with Size => 1;
   for TIM2_DIER_CC1IE_Field use
     (B_0x0 => 0,
      B_0x1 => 1);

   --  Capture/Compare 2 interrupt enable
   type TIM2_DIER_CC2IE_Field is
     (--  CC2 interrupt disabled.
      B_0x0,
      --  CC2 interrupt enabled.
      B_0x1)
     with Size => 1;
   for TIM2_DIER_CC2IE_Field use
     (B_0x0 => 0,
      B_0x1 => 1);

   --  Capture/Compare 3 interrupt enable
   type TIM2_DIER_CC3IE_Field is
     (--  CC3 interrupt disabled.
      B_0x0,
      --  CC3 interrupt enabled.
      B_0x1)
     with Size => 1;
   for TIM2_DIER_CC3IE_Field use
     (B_0x0 => 0,
      B_0x1 => 1);

   --  Capture/Compare 4 interrupt enable
   type TIM2_DIER_CC4IE_Field is
     (--  CC4 interrupt disabled.
      B_0x0,
      --  CC4 interrupt enabled.
      B_0x1)
     with Size => 1;
   for TIM2_DIER_CC4IE_Field use
     (B_0x0 => 0,
      B_0x1 => 1);

   --  Trigger interrupt enable
   type TIM2_DIER_TIE_Field is
     (--  Trigger interrupt disabled.
      B_0x0,
      --  Trigger interrupt enabled.
      B_0x1)
     with Size => 1;
   for TIM2_DIER_TIE_Field use
     (B_0x0 => 0,
      B_0x1 => 1);

   --  Update DMA request enable
   type TIM2_DIER_UDE_Field is
     (--  Update DMA request disabled.
      B_0x0,
      --  Update DMA request enabled.
      B_0x1)
     with Size => 1;
   for TIM2_DIER_UDE_Field use
     (B_0x0 => 0,
      B_0x1 => 1);

   --  Capture/Compare 1 DMA request enable
   type TIM2_DIER_CC1DE_Field is
     (--  CC1 DMA request disabled.
      B_0x0,
      --  CC1 DMA request enabled.
      B_0x1)
     with Size => 1;
   for TIM2_DIER_CC1DE_Field use
     (B_0x0 => 0,
      B_0x1 => 1);

   --  Capture/Compare 2 DMA request enable
   type TIM2_DIER_CC2DE_Field is
     (--  CC2 DMA request disabled.
      B_0x0,
      --  CC2 DMA request enabled.
      B_0x1)
     with Size => 1;
   for TIM2_DIER_CC2DE_Field use
     (B_0x0 => 0,
      B_0x1 => 1);

   --  Capture/Compare 3 DMA request enable
   type TIM2_DIER_CC3DE_Field is
     (--  CC3 DMA request disabled.
      B_0x0,
      --  CC3 DMA request enabled.
      B_0x1)
     with Size => 1;
   for TIM2_DIER_CC3DE_Field use
     (B_0x0 => 0,
      B_0x1 => 1);

   --  Capture/Compare 4 DMA request enable
   type TIM2_DIER_CC4DE_Field is
     (--  CC4 DMA request disabled.
      B_0x0,
      --  CC4 DMA request enabled.
      B_0x1)
     with Size => 1;
   for TIM2_DIER_CC4DE_Field use
     (B_0x0 => 0,
      B_0x1 => 1);

   --  Trigger DMA request enable
   type TIM2_DIER_TDE_Field is
     (--  Trigger DMA request disabled.
      B_0x0,
      --  Trigger DMA request enabled.
      B_0x1)
     with Size => 1;
   for TIM2_DIER_TDE_Field use
     (B_0x0 => 0,
      B_0x1 => 1);

   --  Index interrupt enable
   type TIM2_DIER_IDXIE_Field is
     (--  Index interrupt disabled
      B_0x0,
      --  Index interrupt enabled
      B_0x1)
     with Size => 1;
   for TIM2_DIER_IDXIE_Field use
     (B_0x0 => 0,
      B_0x1 => 1);

   --  Direction change interrupt enable
   type TIM2_DIER_DIRIE_Field is
     (--  Direction change interrupt disabled
      B_0x0,
      --  Direction change interrupt enabled
      B_0x1)
     with Size => 1;
   for TIM2_DIER_DIRIE_Field use
     (B_0x0 => 0,
      B_0x1 => 1);

   --  Index error interrupt enable
   type TIM2_DIER_IERRIE_Field is
     (--  Index error interrupt disabled
      B_0x0,
      --  Index error interrupt enabled
      B_0x1)
     with Size => 1;
   for TIM2_DIER_IERRIE_Field use
     (B_0x0 => 0,
      B_0x1 => 1);

   --  Transition error interrupt enable
   type TIM2_DIER_TERRIE_Field is
     (--  Transition error interrupt disabled
      B_0x0,
      --  Transition error interrupt enabled
      B_0x1)
     with Size => 1;
   for TIM2_DIER_TERRIE_Field use
     (B_0x0 => 0,
      B_0x1 => 1);

   --  TIM2 DMA/Interrupt enable register
   type TIM2_DIER_Register is record
      --  Update interrupt enable
      UIE            : TIM2_DIER_UIE_Field := STM32G4_SVD.TIM.B_0x0;
      --  Capture/Compare 1 interrupt enable
      CC1IE          : TIM2_DIER_CC1IE_Field := STM32G4_SVD.TIM.B_0x0;
      --  Capture/Compare 2 interrupt enable
      CC2IE          : TIM2_DIER_CC2IE_Field := STM32G4_SVD.TIM.B_0x0;
      --  Capture/Compare 3 interrupt enable
      CC3IE          : TIM2_DIER_CC3IE_Field := STM32G4_SVD.TIM.B_0x0;
      --  Capture/Compare 4 interrupt enable
      CC4IE          : TIM2_DIER_CC4IE_Field := STM32G4_SVD.TIM.B_0x0;
      --  unspecified
      Reserved_5_5   : STM32G4_SVD.Bit := 16#0#;
      --  Trigger interrupt enable
      TIE            : TIM2_DIER_TIE_Field := STM32G4_SVD.TIM.B_0x0;
      --  unspecified
      Reserved_7_7   : STM32G4_SVD.Bit := 16#0#;
      --  Update DMA request enable
      UDE            : TIM2_DIER_UDE_Field := STM32G4_SVD.TIM.B_0x0;
      --  Capture/Compare 1 DMA request enable
      CC1DE          : TIM2_DIER_CC1DE_Field := STM32G4_SVD.TIM.B_0x0;
      --  Capture/Compare 2 DMA request enable
      CC2DE          : TIM2_DIER_CC2DE_Field := STM32G4_SVD.TIM.B_0x0;
      --  Capture/Compare 3 DMA request enable
      CC3DE          : TIM2_DIER_CC3DE_Field := STM32G4_SVD.TIM.B_0x0;
      --  Capture/Compare 4 DMA request enable
      CC4DE          : TIM2_DIER_CC4DE_Field := STM32G4_SVD.TIM.B_0x0;
      --  unspecified
      Reserved_13_13 : STM32G4_SVD.Bit := 16#0#;
      --  Trigger DMA request enable
      TDE            : TIM2_DIER_TDE_Field := STM32G4_SVD.TIM.B_0x0;
      --  unspecified
      Reserved_15_19 : STM32G4_SVD.UInt5 := 16#0#;
      --  Index interrupt enable
      IDXIE          : TIM2_DIER_IDXIE_Field := STM32G4_SVD.TIM.B_0x0;
      --  Direction change interrupt enable
      DIRIE          : TIM2_DIER_DIRIE_Field := STM32G4_SVD.TIM.B_0x0;
      --  Index error interrupt enable
      IERRIE         : TIM2_DIER_IERRIE_Field := STM32G4_SVD.TIM.B_0x0;
      --  Transition error interrupt enable
      TERRIE         : TIM2_DIER_TERRIE_Field := STM32G4_SVD.TIM.B_0x0;
      --  unspecified
      Reserved_24_31 : STM32G4_SVD.Byte := 16#0#;
   end record
     with Volatile_Full_Access, Object_Size => 32,
          Bit_Order => System.Low_Order_First;

   for TIM2_DIER_Register use record
      UIE            at 0 range 0 .. 0;
      CC1IE          at 0 range 1 .. 1;
      CC2IE          at 0 range 2 .. 2;
      CC3IE          at 0 range 3 .. 3;
      CC4IE          at 0 range 4 .. 4;
      Reserved_5_5   at 0 range 5 .. 5;
      TIE            at 0 range 6 .. 6;
      Reserved_7_7   at 0 range 7 .. 7;
      UDE            at 0 range 8 .. 8;
      CC1DE          at 0 range 9 .. 9;
      CC2DE          at 0 range 10 .. 10;
      CC3DE          at 0 range 11 .. 11;
      CC4DE          at 0 range 12 .. 12;
      Reserved_13_13 at 0 range 13 .. 13;
      TDE            at 0 range 14 .. 14;
      Reserved_15_19 at 0 range 15 .. 19;
      IDXIE          at 0 range 20 .. 20;
      DIRIE          at 0 range 21 .. 21;
      IERRIE         at 0 range 22 .. 22;
      TERRIE         at 0 range 23 .. 23;
      Reserved_24_31 at 0 range 24 .. 31;
   end record;

   --  Update interrupt flag
   type TIM2_SR_UIF_Field is
     (--  No update occurred
      B_0x0,
      --  Update interrupt pending.
      B_0x1)
     with Size => 1;
   for TIM2_SR_UIF_Field use
     (B_0x0 => 0,
      B_0x1 => 1);

   --  Capture/compare 1 interrupt flag
   type TIM2_SR_CC1IF_Field is
     (--  No compare match / No input capture occurred
      B_0x0,
      --  A compare match or an input capture occurred
      B_0x1)
     with Size => 1;
   for TIM2_SR_CC1IF_Field use
     (B_0x0 => 0,
      B_0x1 => 1);

   --  Trigger interrupt flag
   type TIM2_SR_TIF_Field is
     (--  No trigger event occurred.
      B_0x0,
      --  Trigger interrupt pending.
      B_0x1)
     with Size => 1;
   for TIM2_SR_TIF_Field use
     (B_0x0 => 0,
      B_0x1 => 1);

   --  Capture/Compare 1 overcapture flag
   type TIM2_SR_CC1OF_Field is
     (--  No overcapture has been detected.
      B_0x0,
      --  The counter value has been captured in TIMx_CCR1 register while CC1IF flag
--  was already set
      B_0x1)
     with Size => 1;
   for TIM2_SR_CC1OF_Field use
     (B_0x0 => 0,
      B_0x1 => 1);

   --  Index interrupt flag
   type TIM2_SR_IDXF_Field is
     (--  No index event occurred.
      B_0x0,
      --  An index event has occurred
      B_0x1)
     with Size => 1;
   for TIM2_SR_IDXF_Field use
     (B_0x0 => 0,
      B_0x1 => 1);

   --  Direction change interrupt flag
   type TIM2_SR_DIRF_Field is
     (--  No direction change
      B_0x0,
      --  Direction change
      B_0x1)
     with Size => 1;
   for TIM2_SR_DIRF_Field use
     (B_0x0 => 0,
      B_0x1 => 1);

   --  Index error interrupt flag
   type TIM2_SR_IERRF_Field is
     (--  No index error has been detected.
      B_0x0,
      --  An index error has been detected
      B_0x1)
     with Size => 1;
   for TIM2_SR_IERRF_Field use
     (B_0x0 => 0,
      B_0x1 => 1);

   --  Transition error interrupt flag
   type TIM2_SR_TERRF_Field is
     (--  No encoder transition error has been detected.
      B_0x0,
      --  An encoder transition error has been detected
      B_0x1)
     with Size => 1;
   for TIM2_SR_TERRF_Field use
     (B_0x0 => 0,
      B_0x1 => 1);

   --  TIM2 status register
   type TIM2_SR_Register is record
      --  Update interrupt flag
      UIF            : TIM2_SR_UIF_Field := STM32G4_SVD.TIM.B_0x0;
      --  Capture/compare 1 interrupt flag
      CC1IF          : TIM2_SR_CC1IF_Field := STM32G4_SVD.TIM.B_0x0;
      --  Capture/Compare 2 interrupt flag
      CC2IF          : Boolean := False;
      --  Capture/Compare 3 interrupt flag
      CC3IF          : Boolean := False;
      --  Capture/Compare 4 interrupt flag
      CC4IF          : Boolean := False;
      --  unspecified
      Reserved_5_5   : STM32G4_SVD.Bit := 16#0#;
      --  Trigger interrupt flag
      TIF            : TIM2_SR_TIF_Field := STM32G4_SVD.TIM.B_0x0;
      --  unspecified
      Reserved_7_8   : STM32G4_SVD.UInt2 := 16#0#;
      --  Capture/Compare 1 overcapture flag
      CC1OF          : TIM2_SR_CC1OF_Field := STM32G4_SVD.TIM.B_0x0;
      --  Capture/compare 2 overcapture flag
      CC2OF          : Boolean := False;
      --  Capture/Compare 3 overcapture flag
      CC3OF          : Boolean := False;
      --  Capture/Compare 4 overcapture flag
      CC4OF          : Boolean := False;
      --  unspecified
      Reserved_13_19 : STM32G4_SVD.UInt7 := 16#0#;
      --  Index interrupt flag
      IDXF           : TIM2_SR_IDXF_Field := STM32G4_SVD.TIM.B_0x0;
      --  Direction change interrupt flag
      DIRF           : TIM2_SR_DIRF_Field := STM32G4_SVD.TIM.B_0x0;
      --  Index error interrupt flag
      IERRF          : TIM2_SR_IERRF_Field := STM32G4_SVD.TIM.B_0x0;
      --  Transition error interrupt flag
      TERRF          : TIM2_SR_TERRF_Field := STM32G4_SVD.TIM.B_0x0;
      --  unspecified
      Reserved_24_31 : STM32G4_SVD.Byte := 16#0#;
   end record
     with Volatile_Full_Access, Object_Size => 32,
          Bit_Order => System.Low_Order_First;

   for TIM2_SR_Register use record
      UIF            at 0 range 0 .. 0;
      CC1IF          at 0 range 1 .. 1;
      CC2IF          at 0 range 2 .. 2;
      CC3IF          at 0 range 3 .. 3;
      CC4IF          at 0 range 4 .. 4;
      Reserved_5_5   at 0 range 5 .. 5;
      TIF            at 0 range 6 .. 6;
      Reserved_7_8   at 0 range 7 .. 8;
      CC1OF          at 0 range 9 .. 9;
      CC2OF          at 0 range 10 .. 10;
      CC3OF          at 0 range 11 .. 11;
      CC4OF          at 0 range 12 .. 12;
      Reserved_13_19 at 0 range 13 .. 19;
      IDXF           at 0 range 20 .. 20;
      DIRF           at 0 range 21 .. 21;
      IERRF          at 0 range 22 .. 22;
      TERRF          at 0 range 23 .. 23;
      Reserved_24_31 at 0 range 24 .. 31;
   end record;

   --  Update generation
   type TIM2_EGR_UG_Field is
     (--  No action
      B_0x0,
      --  Re-initialize the counter and generates an update of the registers.
      B_0x1)
     with Size => 1;
   for TIM2_EGR_UG_Field use
     (B_0x0 => 0,
      B_0x1 => 1);

   --  Capture/compare 1 generation
   type TIM2_EGR_CC1G_Field is
     (--  No action
      B_0x0,
      --  A capture/compare event is generated on channel 1:
      B_0x1)
     with Size => 1;
   for TIM2_EGR_CC1G_Field use
     (B_0x0 => 0,
      B_0x1 => 1);

   --  Trigger generation
   type TIM2_EGR_TG_Field is
     (--  No action
      B_0x0,
      --  The TIF flag is set in TIMx_SR register.
      B_0x1)
     with Size => 1;
   for TIM2_EGR_TG_Field use
     (B_0x0 => 0,
      B_0x1 => 1);

   --  TIM2 event generation register
   type TIM2_EGR_Register is record
      --  Write-only. Update generation
      UG            : TIM2_EGR_UG_Field := STM32G4_SVD.TIM.B_0x0;
      --  Write-only. Capture/compare 1 generation
      CC1G          : TIM2_EGR_CC1G_Field := STM32G4_SVD.TIM.B_0x0;
      --  Write-only. Capture/compare 2 generation
      CC2G          : Boolean := False;
      --  Write-only. Capture/compare 3 generation
      CC3G          : Boolean := False;
      --  Write-only. Capture/compare 4 generation
      CC4G          : Boolean := False;
      --  unspecified
      Reserved_5_5  : STM32G4_SVD.Bit := 16#0#;
      --  Write-only. Trigger generation
      TG            : TIM2_EGR_TG_Field := STM32G4_SVD.TIM.B_0x0;
      --  unspecified
      Reserved_7_15 : STM32G4_SVD.UInt9 := 16#0#;
   end record
     with Volatile_Full_Access, Object_Size => 16,
          Bit_Order => System.Low_Order_First;

   for TIM2_EGR_Register use record
      UG            at 0 range 0 .. 0;
      CC1G          at 0 range 1 .. 1;
      CC2G          at 0 range 2 .. 2;
      CC3G          at 0 range 3 .. 3;
      CC4G          at 0 range 4 .. 4;
      Reserved_5_5  at 0 range 5 .. 5;
      TG            at 0 range 6 .. 6;
      Reserved_7_15 at 0 range 7 .. 15;
   end record;

   --  Capture/Compare 1 selection
   type TIM2_CCMR1_CC1S_Field is
     (--  CC1 channel is configured as output
      B_0x0,
      --  CC1 channel is configured as input, tim_ic1 is mapped on tim_ti1
      B_0x1,
      --  CC1 channel is configured as input, tim_ic1 is mapped on tim_ti2
      B_0x2,
      --  CC1 channel is configured as input, tim_ic1 is mapped on tim_trc.
      B_0x3)
     with Size => 2;
   for TIM2_CCMR1_CC1S_Field use
     (B_0x0 => 0,
      B_0x1 => 1,
      B_0x2 => 2,
      B_0x3 => 3);

   --  Input capture 1 prescaler
   type TIM2_CCMR1_IC1PSC_Field is
     (--  no prescaler, capture is done each time an edge is detected on the capture
--  input
      B_0x0,
      --  capture is done once every 2 events
      B_0x1,
      --  capture is done once every 4 events
      B_0x2,
      --  capture is done once every 8 events
      B_0x3)
     with Size => 2;
   for TIM2_CCMR1_IC1PSC_Field use
     (B_0x0 => 0,
      B_0x1 => 1,
      B_0x2 => 2,
      B_0x3 => 3);

   --  Input capture 1 filter
   type TIM2_CCMR1_IC1F_Field is
     (--  No filter, sampling is done at fless thansub>DTSless than/sub>
      B_0x0,
      --  fless thansub>SAMPLINGless than/sub>=fless thansub>tim_ker_ckless
--  than/sub>, N=2
      B_0x1,
      --  fless thansub>SAMPLINGless than/sub>=fless thansub>tim_ker_ckless
--  than/sub>, N=4
      B_0x2,
      --  fless thansub>SAMPLINGless than/sub>=fless thansub>tim_ker_ckless
--  than/sub>, N=8
      B_0x3,
      --  fless thansub>SAMPLINGless than/sub>=fless thansub>DTSless than/sub>/2, N=6
      B_0x4,
      --  fless thansub>SAMPLINGless than/sub>=fless thansub>DTSless than/sub>/2, N=8
      B_0x5,
      --  fless thansub>SAMPLINGless than/sub>=fless thansub>DTSless than/sub>/4, N=6
      B_0x6,
      --  fless thansub>SAMPLINGless than/sub>=fless thansub>DTSless than/sub>/4, N=8
      B_0x7,
      --  fless thansub>SAMPLINGless than/sub>=fless thansub>DTSless than/sub>/8, N=6
      B_0x8,
      --  fless thansub>SAMPLINGless than/sub>=fless thansub>DTSless than/sub>/8, N=8
      B_0x9,
      --  fless thansub>SAMPLINGless than/sub>=fless thansub>DTSless than/sub>/16,
--  N=5
      B_0xA,
      --  fless thansub>SAMPLINGless than/sub>=fless thansub>DTSless than/sub>/16,
--  N=6
      B_0xB,
      --  fless thansub>SAMPLINGless than/sub>=fless thansub>DTSless than/sub>/16,
--  N=8
      B_0xC,
      --  fless thansub>SAMPLINGless than/sub>=fless thansub>DTSless than/sub>/32,
--  N=5
      B_0xD,
      --  fless thansub>SAMPLINGless than/sub>=fless thansub>DTSless than/sub>/32,
--  N=6
      B_0xE,
      --  fless thansub>SAMPLINGless than/sub>=fless thansub>DTSless than/sub>/32,
--  N=8
      B_0xF)
     with Size => 4;
   for TIM2_CCMR1_IC1F_Field use
     (B_0x0 => 0,
      B_0x1 => 1,
      B_0x2 => 2,
      B_0x3 => 3,
      B_0x4 => 4,
      B_0x5 => 5,
      B_0x6 => 6,
      B_0x7 => 7,
      B_0x8 => 8,
      B_0x9 => 9,
      B_0xA => 10,
      B_0xB => 11,
      B_0xC => 12,
      B_0xD => 13,
      B_0xE => 14,
      B_0xF => 15);

   --  Capture/compare 2 selection
   type TIM2_CCMR1_CC2S_Field is
     (--  CC2 channel is configured as output.
      B_0x0,
      --  CC2 channel is configured as input, tim_ic2 is mapped on tim_ti2.
      B_0x1,
      --  CC2 channel is configured as input, tim_ic2 is mapped on tim_ti1.
      B_0x2,
      --  CC2 channel is configured as input, tim_ic2 is mapped on tim_trc.
      B_0x3)
     with Size => 2;
   for TIM2_CCMR1_CC2S_Field use
     (B_0x0 => 0,
      B_0x1 => 1,
      B_0x2 => 2,
      B_0x3 => 3);

   subtype TIM2_CCMR1_IC2PSC_Field is STM32G4_SVD.UInt2;
   subtype TIM2_CCMR1_IC2F_Field is STM32G4_SVD.UInt4;

   --  TIM2 capture/compare mode register 1 [alternate]
   type TIM2_CCMR1_Register is record
      --  Capture/Compare 1 selection
      CC1S           : TIM2_CCMR1_CC1S_Field := STM32G4_SVD.TIM.B_0x0;
      --  Input capture 1 prescaler
      IC1PSC         : TIM2_CCMR1_IC1PSC_Field := STM32G4_SVD.TIM.B_0x0;
      --  Input capture 1 filter
      IC1F           : TIM2_CCMR1_IC1F_Field := STM32G4_SVD.TIM.B_0x0;
      --  Capture/compare 2 selection
      CC2S           : TIM2_CCMR1_CC2S_Field := STM32G4_SVD.TIM.B_0x0;
      --  Input capture 2 prescaler
      IC2PSC         : TIM2_CCMR1_IC2PSC_Field := 16#0#;
      --  Input capture 2 filter
      IC2F           : TIM2_CCMR1_IC2F_Field := 16#0#;
      --  unspecified
      Reserved_16_31 : STM32G4_SVD.UInt16 := 16#0#;
   end record
     with Volatile_Full_Access, Object_Size => 32,
          Bit_Order => System.Low_Order_First;

   for TIM2_CCMR1_Register use record
      CC1S           at 0 range 0 .. 1;
      IC1PSC         at 0 range 2 .. 3;
      IC1F           at 0 range 4 .. 7;
      CC2S           at 0 range 8 .. 9;
      IC2PSC         at 0 range 10 .. 11;
      IC2F           at 0 range 12 .. 15;
      Reserved_16_31 at 0 range 16 .. 31;
   end record;

   --  Capture/Compare 1 selection
   type TIM2_CCMR1_Alternate_CC1S_Field is
     (--  CC1 channel is configured as output.
      B_0x0,
      --  CC1 channel is configured as input, tim_ic1 is mapped on tim_ti1.
      B_0x1,
      --  CC1 channel is configured as input, tim_ic1 is mapped on tim_ti2.
      B_0x2,
      --  CC1 channel is configured as input, tim_ic1 is mapped on tim_trc.
      B_0x3)
     with Size => 2;
   for TIM2_CCMR1_Alternate_CC1S_Field use
     (B_0x0 => 0,
      B_0x1 => 1,
      B_0x2 => 2,
      B_0x3 => 3);

   --  Output compare 1 fast enable
   type TIM2_CCMR1_Alternate_OC1FE_Field is
     (--  CC1 behaves normally depending on counter and CCR1 values even when the
--  trigger is ON.
      B_0x0,
      --  An active edge on the trigger input acts like a compare match on CC1
--  output.
      B_0x1)
     with Size => 1;
   for TIM2_CCMR1_Alternate_OC1FE_Field use
     (B_0x0 => 0,
      B_0x1 => 1);

   --  Output compare 1 preload enable
   type TIM2_CCMR1_Alternate_OC1PE_Field is
     (--  Preload register on TIMx_CCR1 disabled.
      B_0x0,
      --  Preload register on TIMx_CCR1 enabled.
      B_0x1)
     with Size => 1;
   for TIM2_CCMR1_Alternate_OC1PE_Field use
     (B_0x0 => 0,
      B_0x1 => 1);

   --  OC1M[2:0]: Output compare 1 mode
   type TIM2_CCMR1_Alternate_OC1M_Field is
     (--  Frozen - The comparison between the output compare register TIMx_CCR1 and
--  the counter TIMx_CNT has no effect on the outputs.
      B_0x0,
      --  Set channel 1 to active level on match.
      B_0x1,
      --  Set channel 1 to inactive level on match.
      B_0x2,
      --  Toggle - tim_oc1ref toggles when TIMx_CNT=TIMx_CCR1.
      B_0x3,
      --  Force inactive level - tim_oc1ref is forced low.
      B_0x4,
      --  Force active level - tim_oc1ref is forced high.
      B_0x5,
      --  PWM mode 1 - In upcounting, channel 1 is active as long as TIMx_CNTless
--  thanTIMx_CCR1 else inactive.
      B_0x6,
      --  PWM mode 2 - In upcounting, channel 1 is inactive as long as TIMx_CNTless
--  thanTIMx_CCR1 else active.
      B_0x7)
     with Size => 3;
   for TIM2_CCMR1_Alternate_OC1M_Field use
     (B_0x0 => 0,
      B_0x1 => 1,
      B_0x2 => 2,
      B_0x3 => 3,
      B_0x4 => 4,
      B_0x5 => 5,
      B_0x6 => 6,
      B_0x7 => 7);

   --  Output compare 1 clear enable
   type TIM2_CCMR1_Alternate_OC1CE_Field is
     (--  tim_oc1ref is not affected by the tim_ocref_clr_int input
      B_0x0,
      --  tim_oc1ref is cleared as soon as a High level is detected on
--  tim_ocref_clr_int input
      B_0x1)
     with Size => 1;
   for TIM2_CCMR1_Alternate_OC1CE_Field use
     (B_0x0 => 0,
      B_0x1 => 1);

   --  Capture/Compare 2 selection
   type TIM2_CCMR1_Alternate_CC2S_Field is
     (--  CC2 channel is configured as output
      B_0x0,
      --  CC2 channel is configured as input, tim_ic2 is mapped on tim_ti2
      B_0x1,
      --  CC2 channel is configured as input, tim_ic2 is mapped on tim_ti1
      B_0x2,
      --  CC2 channel is configured as input, tim_ic2 is mapped on tim_trc.
      B_0x3)
     with Size => 2;
   for TIM2_CCMR1_Alternate_CC2S_Field use
     (B_0x0 => 0,
      B_0x1 => 1,
      B_0x2 => 2,
      B_0x3 => 3);

   subtype TIM2_CCMR1_Alternate_OC2M_Field is STM32G4_SVD.UInt3;

   --  TIM2 capture/compare mode register 1
   type TIM2_CCMR1_Alternate_Register is record
      --  Capture/Compare 1 selection
      CC1S           : TIM2_CCMR1_Alternate_CC1S_Field :=
                        STM32G4_SVD.TIM.B_0x0;
      --  Output compare 1 fast enable
      OC1FE          : TIM2_CCMR1_Alternate_OC1FE_Field :=
                        STM32G4_SVD.TIM.B_0x0;
      --  Output compare 1 preload enable
      OC1PE          : TIM2_CCMR1_Alternate_OC1PE_Field :=
                        STM32G4_SVD.TIM.B_0x0;
      --  OC1M[2:0]: Output compare 1 mode
      OC1M           : TIM2_CCMR1_Alternate_OC1M_Field :=
                        STM32G4_SVD.TIM.B_0x0;
      --  Output compare 1 clear enable
      OC1CE          : TIM2_CCMR1_Alternate_OC1CE_Field :=
                        STM32G4_SVD.TIM.B_0x0;
      --  Capture/Compare 2 selection
      CC2S           : TIM2_CCMR1_Alternate_CC2S_Field :=
                        STM32G4_SVD.TIM.B_0x0;
      --  Output compare 2 fast enable
      OC2FE          : Boolean := False;
      --  Output compare 2 preload enable
      OC2PE          : Boolean := False;
      --  OC2M[2:0]: Output compare 2 mode
      OC2M           : TIM2_CCMR1_Alternate_OC2M_Field := 16#0#;
      --  Output compare 2 clear enable
      OC2CE          : Boolean := False;
      --  OC1M[3]
      OC1M_1         : Boolean := False;
      --  unspecified
      Reserved_17_23 : STM32G4_SVD.UInt7 := 16#0#;
      --  OC2M[3]
      OC2M_1         : Boolean := False;
      --  unspecified
      Reserved_25_31 : STM32G4_SVD.UInt7 := 16#0#;
   end record
     with Volatile_Full_Access, Object_Size => 32,
          Bit_Order => System.Low_Order_First;

   for TIM2_CCMR1_Alternate_Register use record
      CC1S           at 0 range 0 .. 1;
      OC1FE          at 0 range 2 .. 2;
      OC1PE          at 0 range 3 .. 3;
      OC1M           at 0 range 4 .. 6;
      OC1CE          at 0 range 7 .. 7;
      CC2S           at 0 range 8 .. 9;
      OC2FE          at 0 range 10 .. 10;
      OC2PE          at 0 range 11 .. 11;
      OC2M           at 0 range 12 .. 14;
      OC2CE          at 0 range 15 .. 15;
      OC1M_1         at 0 range 16 .. 16;
      Reserved_17_23 at 0 range 17 .. 23;
      OC2M_1         at 0 range 24 .. 24;
      Reserved_25_31 at 0 range 25 .. 31;
   end record;

   --  Capture/Compare 3 selection
   type TIM2_CCMR2_CC3S_Field is
     (--  CC3 channel is configured as output
      B_0x0,
      --  CC3 channel is configured as input, tim_ic3 is mapped on tim_ti3
      B_0x1,
      --  CC3 channel is configured as input, tim_ic3 is mapped on tim_ti4
      B_0x2,
      --  CC3 channel is configured as input, tim_ic3 is mapped on tim_trc.
      B_0x3)
     with Size => 2;
   for TIM2_CCMR2_CC3S_Field use
     (B_0x0 => 0,
      B_0x1 => 1,
      B_0x2 => 2,
      B_0x3 => 3);

   subtype TIM2_CCMR2_IC3PSC_Field is STM32G4_SVD.UInt2;
   subtype TIM2_CCMR2_IC3F_Field is STM32G4_SVD.UInt4;

   --  Capture/Compare 4 selection
   type TIM2_CCMR2_CC4S_Field is
     (--  CC4 channel is configured as output
      B_0x0,
      --  CC4 channel is configured as input, tim_ic4 is mapped on tim_ti4
      B_0x1,
      --  CC4 channel is configured as input, tim_ic4 is mapped on tim_ti3
      B_0x2,
      --  CC4 channel is configured as input, tim_ic4 is mapped on tim_trc.
      B_0x3)
     with Size => 2;
   for TIM2_CCMR2_CC4S_Field use
     (B_0x0 => 0,
      B_0x1 => 1,
      B_0x2 => 2,
      B_0x3 => 3);

   subtype TIM2_CCMR2_IC4PSC_Field is STM32G4_SVD.UInt2;
   subtype TIM2_CCMR2_IC4F_Field is STM32G4_SVD.UInt4;

   --  TIM2 capture/compare mode register 2 [alternate]
   type TIM2_CCMR2_Register is record
      --  Capture/Compare 3 selection
      CC3S           : TIM2_CCMR2_CC3S_Field := STM32G4_SVD.TIM.B_0x0;
      --  Input capture 3 prescaler
      IC3PSC         : TIM2_CCMR2_IC3PSC_Field := 16#0#;
      --  Input capture 3 filter
      IC3F           : TIM2_CCMR2_IC3F_Field := 16#0#;
      --  Capture/Compare 4 selection
      CC4S           : TIM2_CCMR2_CC4S_Field := STM32G4_SVD.TIM.B_0x0;
      --  Input capture 4 prescaler
      IC4PSC         : TIM2_CCMR2_IC4PSC_Field := 16#0#;
      --  Input capture 4 filter
      IC4F           : TIM2_CCMR2_IC4F_Field := 16#0#;
      --  unspecified
      Reserved_16_31 : STM32G4_SVD.UInt16 := 16#0#;
   end record
     with Volatile_Full_Access, Object_Size => 32,
          Bit_Order => System.Low_Order_First;

   for TIM2_CCMR2_Register use record
      CC3S           at 0 range 0 .. 1;
      IC3PSC         at 0 range 2 .. 3;
      IC3F           at 0 range 4 .. 7;
      CC4S           at 0 range 8 .. 9;
      IC4PSC         at 0 range 10 .. 11;
      IC4F           at 0 range 12 .. 15;
      Reserved_16_31 at 0 range 16 .. 31;
   end record;

   --  Capture/Compare 3 selection
   type TIM2_CCMR2_Alternate_CC3S_Field is
     (--  CC3 channel is configured as output
      B_0x0,
      --  CC3 channel is configured as input, tim_ic3 is mapped on tim_ti3
      B_0x1,
      --  CC3 channel is configured as input, tim_ic3 is mapped on tim_ti4
      B_0x2,
      --  CC3 channel is configured as input, tim_ic3 is mapped on tim_trc.
      B_0x3)
     with Size => 2;
   for TIM2_CCMR2_Alternate_CC3S_Field use
     (B_0x0 => 0,
      B_0x1 => 1,
      B_0x2 => 2,
      B_0x3 => 3);

   subtype TIM2_CCMR2_Alternate_OC3M_Field is STM32G4_SVD.UInt3;

   --  Capture/Compare 4 selection
   type TIM2_CCMR2_Alternate_CC4S_Field is
     (--  CC4 channel is configured as output
      B_0x0,
      --  CC4 channel is configured as input, tim_ic4 is mapped on tim_ti4
      B_0x1,
      --  CC4 channel is configured as input, tim_ic4 is mapped on tim_ti3
      B_0x2,
      --  CC4 channel is configured as input, tim_ic4 is mapped on tim_trc.
      B_0x3)
     with Size => 2;
   for TIM2_CCMR2_Alternate_CC4S_Field use
     (B_0x0 => 0,
      B_0x1 => 1,
      B_0x2 => 2,
      B_0x3 => 3);

   subtype TIM2_CCMR2_Alternate_OC4M_Field is STM32G4_SVD.UInt3;

   --  TIM2 capture/compare mode register 2
   type TIM2_CCMR2_Alternate_Register is record
      --  Capture/Compare 3 selection
      CC3S           : TIM2_CCMR2_Alternate_CC3S_Field :=
                        STM32G4_SVD.TIM.B_0x0;
      --  Output compare 3 fast enable
      OC3FE          : Boolean := False;
      --  Output compare 3 preload enable
      OC3PE          : Boolean := False;
      --  OC3M[2:0]: Output compare 3 mode
      OC3M           : TIM2_CCMR2_Alternate_OC3M_Field := 16#0#;
      --  Output compare 3 clear enable
      OC3CE          : Boolean := False;
      --  Capture/Compare 4 selection
      CC4S           : TIM2_CCMR2_Alternate_CC4S_Field :=
                        STM32G4_SVD.TIM.B_0x0;
      --  Output compare 4 fast enable
      OC4FE          : Boolean := False;
      --  Output compare 4 preload enable
      OC4PE          : Boolean := False;
      --  OC4M[2:0]: Output compare 4 mode
      OC4M           : TIM2_CCMR2_Alternate_OC4M_Field := 16#0#;
      --  Output compare 4 clear enable
      OC4CE          : Boolean := False;
      --  OC3M[3]
      OC3M_1         : Boolean := False;
      --  unspecified
      Reserved_17_23 : STM32G4_SVD.UInt7 := 16#0#;
      --  OC4M[3]
      OC4M_1         : Boolean := False;
      --  unspecified
      Reserved_25_31 : STM32G4_SVD.UInt7 := 16#0#;
   end record
     with Volatile_Full_Access, Object_Size => 32,
          Bit_Order => System.Low_Order_First;

   for TIM2_CCMR2_Alternate_Register use record
      CC3S           at 0 range 0 .. 1;
      OC3FE          at 0 range 2 .. 2;
      OC3PE          at 0 range 3 .. 3;
      OC3M           at 0 range 4 .. 6;
      OC3CE          at 0 range 7 .. 7;
      CC4S           at 0 range 8 .. 9;
      OC4FE          at 0 range 10 .. 10;
      OC4PE          at 0 range 11 .. 11;
      OC4M           at 0 range 12 .. 14;
      OC4CE          at 0 range 15 .. 15;
      OC3M_1         at 0 range 16 .. 16;
      Reserved_17_23 at 0 range 17 .. 23;
      OC4M_1         at 0 range 24 .. 24;
      Reserved_25_31 at 0 range 25 .. 31;
   end record;

   --  Capture/Compare 1 output enable.
   type TIM2_CCER_CC1E_Field is
     (--  Capture mode disabled / OC1 is not active
      B_0x0,
      --  Capture mode enabled / OC1 signal is output on the corresponding output pin
      B_0x1)
     with Size => 1;
   for TIM2_CCER_CC1E_Field use
     (B_0x0 => 0,
      B_0x1 => 1);

   --  Capture/Compare 1 output Polarity.
   type TIM2_CCER_CC1P_Field is
     (--  OC1 active high (output mode) / Edge sensitivity selection (input mode, see
--  below)
      B_0x0,
      --  OC1 active low (output mode) / Edge sensitivity selection (input mode, see
--  below)
      B_0x1)
     with Size => 1;
   for TIM2_CCER_CC1P_Field use
     (B_0x0 => 0,
      B_0x1 => 1);

   --  TIM2 capture/compare enable register
   type TIM2_CCER_Register is record
      --  Capture/Compare 1 output enable.
      CC1E           : TIM2_CCER_CC1E_Field := STM32G4_SVD.TIM.B_0x0;
      --  Capture/Compare 1 output Polarity.
      CC1P           : TIM2_CCER_CC1P_Field := STM32G4_SVD.TIM.B_0x0;
      --  unspecified
      Reserved_2_2   : STM32G4_SVD.Bit := 16#0#;
      --  Capture/Compare 1 output Polarity.
      CC1NP          : Boolean := False;
      --  Capture/Compare 2 output enable.
      CC2E           : Boolean := False;
      --  Capture/Compare 2 output Polarity.
      CC2P           : Boolean := False;
      --  unspecified
      Reserved_6_6   : STM32G4_SVD.Bit := 16#0#;
      --  Capture/Compare 2 output Polarity.
      CC2NP          : Boolean := False;
      --  Capture/Compare 3 output enable.
      CC3E           : Boolean := False;
      --  Capture/Compare 3 output Polarity.
      CC3P           : Boolean := False;
      --  unspecified
      Reserved_10_10 : STM32G4_SVD.Bit := 16#0#;
      --  Capture/Compare 3 output Polarity.
      CC3NP          : Boolean := False;
      --  Capture/Compare 4 output enable.
      CC4E           : Boolean := False;
      --  Capture/Compare 4 output Polarity.
      CC4P           : Boolean := False;
      --  unspecified
      Reserved_14_14 : STM32G4_SVD.Bit := 16#0#;
      --  Capture/Compare 4 output Polarity.
      CC4NP          : Boolean := False;
   end record
     with Volatile_Full_Access, Object_Size => 16,
          Bit_Order => System.Low_Order_First;

   for TIM2_CCER_Register use record
      CC1E           at 0 range 0 .. 0;
      CC1P           at 0 range 1 .. 1;
      Reserved_2_2   at 0 range 2 .. 2;
      CC1NP          at 0 range 3 .. 3;
      CC2E           at 0 range 4 .. 4;
      CC2P           at 0 range 5 .. 5;
      Reserved_6_6   at 0 range 6 .. 6;
      CC2NP          at 0 range 7 .. 7;
      CC3E           at 0 range 8 .. 8;
      CC3P           at 0 range 9 .. 9;
      Reserved_10_10 at 0 range 10 .. 10;
      CC3NP          at 0 range 11 .. 11;
      CC4E           at 0 range 12 .. 12;
      CC4P           at 0 range 13 .. 13;
      Reserved_14_14 at 0 range 14 .. 14;
      CC4NP          at 0 range 15 .. 15;
   end record;

   subtype TIM2_CNT_CNT_Field is STM32G4_SVD.UInt31;

   --  TIM2 counter
   type TIM2_CNT_Register is record
      --  Least significant part of counter value
      CNT        : TIM2_CNT_CNT_Field := 16#0#;
      --  Value depends on IUFREMAP in TIMx_CR1.
      UIFCPY_CNT : Boolean := False;
   end record
     with Volatile_Full_Access, Object_Size => 32,
          Bit_Order => System.Low_Order_First;

   for TIM2_CNT_Register use record
      CNT        at 0 range 0 .. 30;
      UIFCPY_CNT at 0 range 31 .. 31;
   end record;

   --  Index enable
   type TIM2_ECR_IE_Field is
     (--  Index disabled
      B_0x0,
      --  Index enabled
      B_0x1)
     with Size => 1;
   for TIM2_ECR_IE_Field use
     (B_0x0 => 0,
      B_0x1 => 1);

   --  Index direction
   type TIM2_ECR_IDIR_Field is
     (--  Index resets the counter whatever the direction
      B_0x0,
      --  Index resets the counter when up-counting only
      B_0x1,
      --  Index resets the counter when down-counting only
      B_0x2)
     with Size => 2;
   for TIM2_ECR_IDIR_Field use
     (B_0x0 => 0,
      B_0x1 => 1,
      B_0x2 => 2);

   --  First index
   type TIM2_ECR_FIDX_Field is
     (--  Index is always active
      B_0x0,
      --  the first Index only resets the counter
      B_0x1)
     with Size => 1;
   for TIM2_ECR_FIDX_Field use
     (B_0x0 => 0,
      B_0x1 => 1);

   --  Index positioning
   type TIM2_ECR_IPOS_Field is
     (--  Index resets the counter when AB = 00
      B_0x0,
      --  Index resets the counter when AB = 01
      B_0x1,
      --  Index resets the counter when AB = 10
      B_0x2,
      --  Index resets the counter when AB = 11
      B_0x3)
     with Size => 2;
   for TIM2_ECR_IPOS_Field use
     (B_0x0 => 0,
      B_0x1 => 1,
      B_0x2 => 2,
      B_0x3 => 3);

   subtype TIM2_ECR_PW_Field is STM32G4_SVD.Byte;
   subtype TIM2_ECR_PWPRSC_Field is STM32G4_SVD.UInt3;

   --  TIM2 timer encoder control register
   type TIM2_ECR_Register is record
      --  Index enable
      IE             : TIM2_ECR_IE_Field := STM32G4_SVD.TIM.B_0x0;
      --  Index direction
      IDIR           : TIM2_ECR_IDIR_Field := STM32G4_SVD.TIM.B_0x0;
      --  unspecified
      Reserved_3_4   : STM32G4_SVD.UInt2 := 16#0#;
      --  First index
      FIDX           : TIM2_ECR_FIDX_Field := STM32G4_SVD.TIM.B_0x0;
      --  Index positioning
      IPOS           : TIM2_ECR_IPOS_Field := STM32G4_SVD.TIM.B_0x0;
      --  unspecified
      Reserved_8_15  : STM32G4_SVD.Byte := 16#0#;
      --  Pulse width
      PW             : TIM2_ECR_PW_Field := 16#0#;
      --  Pulse width prescaler
      PWPRSC         : TIM2_ECR_PWPRSC_Field := 16#0#;
      --  unspecified
      Reserved_27_31 : STM32G4_SVD.UInt5 := 16#0#;
   end record
     with Volatile_Full_Access, Object_Size => 32,
          Bit_Order => System.Low_Order_First;

   for TIM2_ECR_Register use record
      IE             at 0 range 0 .. 0;
      IDIR           at 0 range 1 .. 2;
      Reserved_3_4   at 0 range 3 .. 4;
      FIDX           at 0 range 5 .. 5;
      IPOS           at 0 range 6 .. 7;
      Reserved_8_15  at 0 range 8 .. 15;
      PW             at 0 range 16 .. 23;
      PWPRSC         at 0 range 24 .. 26;
      Reserved_27_31 at 0 range 27 .. 31;
   end record;

   --  Selects tim_ti1[15:0] input
   type TIM2_TISEL_TI1SEL_Field is
     (--  tim_ti1_in0: TIMx_CH1
      B_0x0,
      --  tim_ti1_in1
      B_0x1,
      --  tim_ti1_in15
      B_0xF)
     with Size => 4;
   for TIM2_TISEL_TI1SEL_Field use
     (B_0x0 => 0,
      B_0x1 => 1,
      B_0xF => 15);

   --  Selects tim_ti2[15:0] input
   type TIM2_TISEL_TI2SEL_Field is
     (--  tim_ti2_in0: TIMx_CH2
      B_0x0,
      --  tim_ti2_in1
      B_0x1,
      --  tim_ti2_in15
      B_0xF)
     with Size => 4;
   for TIM2_TISEL_TI2SEL_Field use
     (B_0x0 => 0,
      B_0x1 => 1,
      B_0xF => 15);

   --  Selects tim_ti3[15:0] input
   type TIM2_TISEL_TI3SEL_Field is
     (--  tim_ti3_in0: TIMx_CH3
      B_0x0,
      --  tim_ti3_in1
      B_0x1,
      --  tim_ti3_in15
      B_0xF)
     with Size => 4;
   for TIM2_TISEL_TI3SEL_Field use
     (B_0x0 => 0,
      B_0x1 => 1,
      B_0xF => 15);

   --  Selects tim_ti4[15:0] input
   type TIM2_TISEL_TI4SEL_Field is
     (--  tim_ti4_in0: TIMx_CH4
      B_0x0,
      --  tim_ti4_in1
      B_0x1,
      --  tim_ti4_in15
      B_0xF)
     with Size => 4;
   for TIM2_TISEL_TI4SEL_Field use
     (B_0x0 => 0,
      B_0x1 => 1,
      B_0xF => 15);

   --  TIM2 timer input selection register
   type TIM2_TISEL_Register is record
      --  Selects tim_ti1[15:0] input
      TI1SEL         : TIM2_TISEL_TI1SEL_Field := STM32G4_SVD.TIM.B_0x0;
      --  unspecified
      Reserved_4_7   : STM32G4_SVD.UInt4 := 16#0#;
      --  Selects tim_ti2[15:0] input
      TI2SEL         : TIM2_TISEL_TI2SEL_Field := STM32G4_SVD.TIM.B_0x0;
      --  unspecified
      Reserved_12_15 : STM32G4_SVD.UInt4 := 16#0#;
      --  Selects tim_ti3[15:0] input
      TI3SEL         : TIM2_TISEL_TI3SEL_Field := STM32G4_SVD.TIM.B_0x0;
      --  unspecified
      Reserved_20_23 : STM32G4_SVD.UInt4 := 16#0#;
      --  Selects tim_ti4[15:0] input
      TI4SEL         : TIM2_TISEL_TI4SEL_Field := STM32G4_SVD.TIM.B_0x0;
      --  unspecified
      Reserved_28_31 : STM32G4_SVD.UInt4 := 16#0#;
   end record
     with Volatile_Full_Access, Object_Size => 32,
          Bit_Order => System.Low_Order_First;

   for TIM2_TISEL_Register use record
      TI1SEL         at 0 range 0 .. 3;
      Reserved_4_7   at 0 range 4 .. 7;
      TI2SEL         at 0 range 8 .. 11;
      Reserved_12_15 at 0 range 12 .. 15;
      TI3SEL         at 0 range 16 .. 19;
      Reserved_20_23 at 0 range 20 .. 23;
      TI4SEL         at 0 range 24 .. 27;
      Reserved_28_31 at 0 range 28 .. 31;
   end record;

   --  etr_in source selection
   type TIM2_AF1_ETRSEL_Field is
     (--  tim_etr0: TIMx_ETR input
      B_0x0,
      --  tim_etr1
      B_0x1,
      --  tim_etr15
      B_0xF)
     with Size => 4;
   for TIM2_AF1_ETRSEL_Field use
     (B_0x0 => 0,
      B_0x1 => 1,
      B_0xF => 15);

   --  TIM2 alternate function register 1
   type TIM2_AF1_Register is record
      --  unspecified
      Reserved_0_13  : STM32G4_SVD.UInt14 := 16#0#;
      --  etr_in source selection
      ETRSEL         : TIM2_AF1_ETRSEL_Field := STM32G4_SVD.TIM.B_0x0;
      --  unspecified
      Reserved_18_31 : STM32G4_SVD.UInt14 := 16#0#;
   end record
     with Volatile_Full_Access, Object_Size => 32,
          Bit_Order => System.Low_Order_First;

   for TIM2_AF1_Register use record
      Reserved_0_13  at 0 range 0 .. 13;
      ETRSEL         at 0 range 14 .. 17;
      Reserved_18_31 at 0 range 18 .. 31;
   end record;

   --  ocref_clr source selection
   type TIM2_AF2_OCRSEL_Field is
     (--  tim_ocref_clr0
      B_0x0,
      --  tim_ocref_clr1
      B_0x1,
      --  tim_ocref_clr7
      B_0x7)
     with Size => 3;
   for TIM2_AF2_OCRSEL_Field use
     (B_0x0 => 0,
      B_0x1 => 1,
      B_0x7 => 7);

   --  TIM2 alternate function register 2
   type TIM2_AF2_Register is record
      --  unspecified
      Reserved_0_15  : STM32G4_SVD.UInt16 := 16#0#;
      --  ocref_clr source selection
      OCRSEL         : TIM2_AF2_OCRSEL_Field := STM32G4_SVD.TIM.B_0x0;
      --  unspecified
      Reserved_19_31 : STM32G4_SVD.UInt13 := 16#0#;
   end record
     with Volatile_Full_Access, Object_Size => 32,
          Bit_Order => System.Low_Order_First;

   for TIM2_AF2_Register use record
      Reserved_0_15  at 0 range 0 .. 15;
      OCRSEL         at 0 range 16 .. 18;
      Reserved_19_31 at 0 range 19 .. 31;
   end record;

   --  DMA base address
   type TIM2_DCR_DBA_Field is
     (--  TIMx_CR1,
      B_0x0,
      --  TIMx_CR2,
      B_0x1,
      --  TIMx_SMCR,
      B_0x2)
     with Size => 5;
   for TIM2_DCR_DBA_Field use
     (B_0x0 => 0,
      B_0x1 => 1,
      B_0x2 => 2);

   --  DMA burst length
   type TIM2_DCR_DBL_Field is
     (--  1 transfer
      B_0x0,
      --  2 transfers
      B_0x1,
      --  3 transfers
      B_0x2,
      --  26 transfers
      B_0x1A)
     with Size => 5;
   for TIM2_DCR_DBL_Field use
     (B_0x0 => 0,
      B_0x1 => 1,
      B_0x2 => 2,
      B_0x1A => 26);

   --  TIM2 DMA control register
   type TIM2_DCR_Register is record
      --  DMA base address
      DBA            : TIM2_DCR_DBA_Field := STM32G4_SVD.TIM.B_0x0;
      --  unspecified
      Reserved_5_7   : STM32G4_SVD.UInt3 := 16#0#;
      --  DMA burst length
      DBL            : TIM2_DCR_DBL_Field := STM32G4_SVD.TIM.B_0x0;
      --  unspecified
      Reserved_13_31 : STM32G4_SVD.UInt19 := 16#0#;
   end record
     with Volatile_Full_Access, Object_Size => 32,
          Bit_Order => System.Low_Order_First;

   for TIM2_DCR_Register use record
      DBA            at 0 range 0 .. 4;
      Reserved_5_7   at 0 range 5 .. 7;
      DBL            at 0 range 8 .. 12;
      Reserved_13_31 at 0 range 13 .. 31;
   end record;

   --  Counter enable
   type TIM3_CR1_CEN_Field is
     (--  Counter disabled
      B_0x0,
      --  Counter enabled
      B_0x1)
     with Size => 1;
   for TIM3_CR1_CEN_Field use
     (B_0x0 => 0,
      B_0x1 => 1);

   --  Update disable
   type TIM3_CR1_UDIS_Field is
     (--  UEV enabled.
      B_0x0,
      --  UEV disabled.
      B_0x1)
     with Size => 1;
   for TIM3_CR1_UDIS_Field use
     (B_0x0 => 0,
      B_0x1 => 1);

   --  Update request source
   type TIM3_CR1_URS_Field is
     (--  Any of the following events generate an update interrupt or DMA request if
--  enabled.
      B_0x0,
      --  Only counter overflow/underflow generates an update interrupt or DMA
--  request if enabled.
      B_0x1)
     with Size => 1;
   for TIM3_CR1_URS_Field use
     (B_0x0 => 0,
      B_0x1 => 1);

   --  One-pulse mode
   type TIM3_CR1_OPM_Field is
     (--  Counter is not stopped at update event
      B_0x0,
      --  Counter stops counting at the next update event (clearing the bit CEN)
      B_0x1)
     with Size => 1;
   for TIM3_CR1_OPM_Field use
     (B_0x0 => 0,
      B_0x1 => 1);

   --  Direction
   type TIM3_CR1_DIR_Field is
     (--  Counter used as upcounter
      B_0x0,
      --  Counter used as downcounter
      B_0x1)
     with Size => 1;
   for TIM3_CR1_DIR_Field use
     (B_0x0 => 0,
      B_0x1 => 1);

   --  Center-aligned mode selection
   type TIM3_CR1_CMS_Field is
     (--  Edge-aligned mode.
      B_0x0,
      --  Center-aligned mode 1.
      B_0x1,
      --  Center-aligned mode 2.
      B_0x2,
      --  Center-aligned mode 3.
      B_0x3)
     with Size => 2;
   for TIM3_CR1_CMS_Field use
     (B_0x0 => 0,
      B_0x1 => 1,
      B_0x2 => 2,
      B_0x3 => 3);

   --  Auto-reload preload enable
   type TIM3_CR1_ARPE_Field is
     (--  TIMx_ARR register is not buffered
      B_0x0,
      --  TIMx_ARR register is buffered
      B_0x1)
     with Size => 1;
   for TIM3_CR1_ARPE_Field use
     (B_0x0 => 0,
      B_0x1 => 1);

   --  Clock division
   type TIM3_CR1_CKD_Field is
     (--  tless thansub>DTSless than/sub>
      B_0x0,
      --  tless thansub>DTSless than/sub>
      B_0x1,
      --  tless thansub>DTSless than/sub>
      B_0x2)
     with Size => 2;
   for TIM3_CR1_CKD_Field use
     (B_0x0 => 0,
      B_0x1 => 1,
      B_0x2 => 2);

   --  UIF status bit remapping
   type TIM3_CR1_UIFREMAP_Field is
     (--  No remapping.
      B_0x0,
      --  Remapping enabled.
      B_0x1)
     with Size => 1;
   for TIM3_CR1_UIFREMAP_Field use
     (B_0x0 => 0,
      B_0x1 => 1);

   --  Dithering Enable
   type TIM3_CR1_DITHEN_Field is
     (--  Dithering disabled
      B_0x0,
      --  Dithering enabled
      B_0x1)
     with Size => 1;
   for TIM3_CR1_DITHEN_Field use
     (B_0x0 => 0,
      B_0x1 => 1);

   --  TIM3 control register 1
   type TIM3_CR1_Register is record
      --  Counter enable
      CEN            : TIM3_CR1_CEN_Field := STM32G4_SVD.TIM.B_0x0;
      --  Update disable
      UDIS           : TIM3_CR1_UDIS_Field := STM32G4_SVD.TIM.B_0x0;
      --  Update request source
      URS            : TIM3_CR1_URS_Field := STM32G4_SVD.TIM.B_0x0;
      --  One-pulse mode
      OPM            : TIM3_CR1_OPM_Field := STM32G4_SVD.TIM.B_0x0;
      --  Direction
      DIR            : TIM3_CR1_DIR_Field := STM32G4_SVD.TIM.B_0x0;
      --  Center-aligned mode selection
      CMS            : TIM3_CR1_CMS_Field := STM32G4_SVD.TIM.B_0x0;
      --  Auto-reload preload enable
      ARPE           : TIM3_CR1_ARPE_Field := STM32G4_SVD.TIM.B_0x0;
      --  Clock division
      CKD            : TIM3_CR1_CKD_Field := STM32G4_SVD.TIM.B_0x0;
      --  unspecified
      Reserved_10_10 : STM32G4_SVD.Bit := 16#0#;
      --  UIF status bit remapping
      UIFREMAP       : TIM3_CR1_UIFREMAP_Field := STM32G4_SVD.TIM.B_0x0;
      --  Dithering Enable
      DITHEN         : TIM3_CR1_DITHEN_Field := STM32G4_SVD.TIM.B_0x0;
      --  unspecified
      Reserved_13_15 : STM32G4_SVD.UInt3 := 16#0#;
   end record
     with Volatile_Full_Access, Object_Size => 16,
          Bit_Order => System.Low_Order_First;

   for TIM3_CR1_Register use record
      CEN            at 0 range 0 .. 0;
      UDIS           at 0 range 1 .. 1;
      URS            at 0 range 2 .. 2;
      OPM            at 0 range 3 .. 3;
      DIR            at 0 range 4 .. 4;
      CMS            at 0 range 5 .. 6;
      ARPE           at 0 range 7 .. 7;
      CKD            at 0 range 8 .. 9;
      Reserved_10_10 at 0 range 10 .. 10;
      UIFREMAP       at 0 range 11 .. 11;
      DITHEN         at 0 range 12 .. 12;
      Reserved_13_15 at 0 range 13 .. 15;
   end record;

   --  Capture/compare DMA selection
   type TIM3_CR2_CCDS_Field is
     (--  CCx DMA request sent when CCx event occurs
      B_0x0,
      --  CCx DMA requests sent when update event occurs
      B_0x1)
     with Size => 1;
   for TIM3_CR2_CCDS_Field use
     (B_0x0 => 0,
      B_0x1 => 1);

   --  MMS[0]: Master mode selection
   type TIM3_CR2_MMS_Field is
     (--  Reset - the UG bit from the TIMx_EGR register is used as trigger output
--  (tim_trgo).
      B_0x0,
      --  Enable - the Counter enable signal, CNT_EN, is used as trigger output
--  (tim_trgo).
      B_0x1,
      --  Update - The update event is selected as trigger output (tim_trgo).
      B_0x2,
      --  Compare Pulse - The trigger output send a positive pulse when the CC1IF
--  flag is to be set (even if it was already high), as soon as a capture or a
--  compare match occurred (tim_trgo).
      B_0x3,
      --  Compare - tim_oc1refc signal is used as trigger output (tim_trgo)
      B_0x4,
      --  Compare - tim_oc2refc signal is used as trigger output (tim_trgo)
      B_0x5,
      --  Compare - tim_oc3refc signal is used as trigger output (tim_trgo)
      B_0x6,
      --  Compare - tim_oc4refc signal is used as trigger output (tim_trgo)
      B_0x7)
     with Size => 3;
   for TIM3_CR2_MMS_Field use
     (B_0x0 => 0,
      B_0x1 => 1,
      B_0x2 => 2,
      B_0x3 => 3,
      B_0x4 => 4,
      B_0x5 => 5,
      B_0x6 => 6,
      B_0x7 => 7);

   --  tim_ti1 selection
   type TIM3_CR2_TI1S_Field is
     (--  The tim_ti1_in[15:0] multiplexer output is to tim_ti1 input
      B_0x0,
      --  The tim_ti1_in[15:0], tim_ti2_in[15:0] and tim_ti3_in[15:0] multiplexers
--  outputs are XORed and connected to the tim_ti1 input.
      B_0x1)
     with Size => 1;
   for TIM3_CR2_TI1S_Field use
     (B_0x0 => 0,
      B_0x1 => 1);

   --  TIM3 control register 2
   type TIM3_CR2_Register is record
      --  unspecified
      Reserved_0_2   : STM32G4_SVD.UInt3 := 16#0#;
      --  Capture/compare DMA selection
      CCDS           : TIM3_CR2_CCDS_Field := STM32G4_SVD.TIM.B_0x0;
      --  MMS[0]: Master mode selection
      MMS            : TIM3_CR2_MMS_Field := STM32G4_SVD.TIM.B_0x0;
      --  tim_ti1 selection
      TI1S           : TIM3_CR2_TI1S_Field := STM32G4_SVD.TIM.B_0x0;
      --  unspecified
      Reserved_8_24  : STM32G4_SVD.UInt17 := 16#0#;
      --  MMS[3]
      MMS_1          : Boolean := False;
      --  unspecified
      Reserved_26_31 : STM32G4_SVD.UInt6 := 16#0#;
   end record
     with Volatile_Full_Access, Object_Size => 32,
          Bit_Order => System.Low_Order_First;

   for TIM3_CR2_Register use record
      Reserved_0_2   at 0 range 0 .. 2;
      CCDS           at 0 range 3 .. 3;
      MMS            at 0 range 4 .. 6;
      TI1S           at 0 range 7 .. 7;
      Reserved_8_24  at 0 range 8 .. 24;
      MMS_1          at 0 range 25 .. 25;
      Reserved_26_31 at 0 range 26 .. 31;
   end record;

   --  SMS[0]: Slave mode selection
   type TIM3_SMCR_SMS_Field is
     (--  Slave mode disabled - if CEN = 1 then the prescaler is clocked directly by
--  the internal clock.
      B_0x0,
      --  Encoder mode 1 - Counter counts up/down on tim_ti1fp1 edge depending on
--  tim_ti2fp2 level.
      B_0x1,
      --  Encoder mode 2 - Counter counts up/down on tim_ti2fp2 edge depending on
--  tim_ti1fp1 level.
      B_0x2,
      --  Encoder mode 3 - Counter counts up/down on both tim_ti1fp1 and tim_ti2fp2
--  edges depending on the level of the other input.
      B_0x3,
      --  Reset Mode - Rising edge of the selected trigger input (tim_trgi)
--  reinitializes the counter and generates an update of the registers.
      B_0x4,
      --  Gated Mode - The counter clock is enabled when the trigger input (tim_trgi)
--  is high.
      B_0x5,
      --  Trigger Mode - The counter starts at a rising edge of the trigger tim_trgi
--  (but it is not reset).
      B_0x6,
      --  External Clock Mode 1 - Rising edges of the selected trigger (tim_trgi)
--  clock the counter.
      B_0x7)
     with Size => 3;
   for TIM3_SMCR_SMS_Field use
     (B_0x0 => 0,
      B_0x1 => 1,
      B_0x2 => 2,
      B_0x3 => 3,
      B_0x4 => 4,
      B_0x5 => 5,
      B_0x6 => 6,
      B_0x7 => 7);

   --  OCREF clear selection
   type TIM3_SMCR_OCCS_Field is
     (--  tim_ocref_clr_int is connected to the tim_ocref_clr input
      B_0x0,
      --  tim_ocref_clr_int is connected to tim_etrf
      B_0x1)
     with Size => 1;
   for TIM3_SMCR_OCCS_Field use
     (B_0x0 => 0,
      B_0x1 => 1);

   --  TS[0]: Trigger selection
   type TIM3_SMCR_TS_Field is
     (--  Internal trigger 0 (tim_itr0)
      B_0x0,
      --  Internal trigger 1 (tim_itr1)
      B_0x1,
      --  Internal trigger 2 (tim_itr2)
      B_0x2,
      --  Internal trigger 3 (tim_itr3)
      B_0x3,
      --  tim_ti1 edge detector (tim_ti1f_ed)
      B_0x4,
      --  Filtered timer input 1 (tim_ti1fp1)
      B_0x5,
      --  Filtered timer input 2 (tim_ti2fp2)
      B_0x6,
      --  External trigger input (tim_etrf)
      B_0x7)
     with Size => 3;
   for TIM3_SMCR_TS_Field use
     (B_0x0 => 0,
      B_0x1 => 1,
      B_0x2 => 2,
      B_0x3 => 3,
      B_0x4 => 4,
      B_0x5 => 5,
      B_0x6 => 6,
      B_0x7 => 7);

   --  Master/Slave mode
   type TIM3_SMCR_MSM_Field is
     (--  No action
      B_0x0,
      --  The effect of an event on the trigger input (tim_trgi) is delayed to allow
--  a perfect synchronization between the current timer and its slaves (through
--  tim_trgo).
      B_0x1)
     with Size => 1;
   for TIM3_SMCR_MSM_Field use
     (B_0x0 => 0,
      B_0x1 => 1);

   --  External trigger filter
   type TIM3_SMCR_ETF_Field is
     (--  No filter, sampling is done at fless thansub>DTSless than/sub>
      B_0x0,
      --  fless thansub>SAMPLINGless than/sub>=fless thansub>tim_ker_ckless
--  than/sub>, N=2
      B_0x1,
      --  fless thansub>SAMPLINGless than/sub>=fless thansub>tim_ker_ckless
--  than/sub>, N=4
      B_0x2,
      --  fless thansub>SAMPLINGless than/sub>=fless thansub>tim_ker_ckless
--  than/sub>, N=8
      B_0x3,
      --  fless thansub>SAMPLINGless than/sub>=fless thansub>DTSless than/sub>/2, N=6
      B_0x4,
      --  fless thansub>SAMPLINGless than/sub>=fless thansub>DTSless than/sub>/2, N=8
      B_0x5,
      --  fless thansub>SAMPLINGless than/sub>=fless thansub>DTSless than/sub>/4, N=6
      B_0x6,
      --  fless thansub>SAMPLINGless than/sub>=fless thansub>DTSless than/sub>/4, N=8
      B_0x7,
      --  fless thansub>SAMPLINGless than/sub>=fless thansub>DTSless than/sub>/8, N=6
      B_0x8,
      --  fless thansub>SAMPLINGless than/sub>=fless thansub>DTSless than/sub>/8, N=8
      B_0x9,
      --  fless thansub>SAMPLINGless than/sub>=fless thansub>DTSless than/sub>/16,
--  N=5
      B_0xA,
      --  fless thansub>SAMPLINGless than/sub>=fless thansub>DTSless than/sub>/16,
--  N=6
      B_0xB,
      --  fless thansub>SAMPLINGless than/sub>=fless thansub>DTSless than/sub>/16,
--  N=8
      B_0xC,
      --  fless thansub>SAMPLINGless than/sub>=fless thansub>DTSless than/sub>/32,
--  N=5
      B_0xD,
      --  fless thansub>SAMPLINGless than/sub>=fless thansub>DTSless than/sub>/32,
--  N=6
      B_0xE,
      --  fless thansub>SAMPLINGless than/sub>=fless thansub>DTSless than/sub>/32,
--  N=8
      B_0xF)
     with Size => 4;
   for TIM3_SMCR_ETF_Field use
     (B_0x0 => 0,
      B_0x1 => 1,
      B_0x2 => 2,
      B_0x3 => 3,
      B_0x4 => 4,
      B_0x5 => 5,
      B_0x6 => 6,
      B_0x7 => 7,
      B_0x8 => 8,
      B_0x9 => 9,
      B_0xA => 10,
      B_0xB => 11,
      B_0xC => 12,
      B_0xD => 13,
      B_0xE => 14,
      B_0xF => 15);

   --  External trigger prescaler
   type TIM3_SMCR_ETPS_Field is
     (--  Prescaler OFF
      B_0x0,
      --  tim_etrp frequency divided by 2
      B_0x1,
      --  tim_etrp frequency divided by 4
      B_0x2,
      --  tim_etrp frequency divided by 8
      B_0x3)
     with Size => 2;
   for TIM3_SMCR_ETPS_Field use
     (B_0x0 => 0,
      B_0x1 => 1,
      B_0x2 => 2,
      B_0x3 => 3);

   --  External clock enable
   type TIM3_SMCR_ECE_Field is
     (--  External clock mode 2 disabled
      B_0x0,
      --  External clock mode 2 enabled.
      B_0x1)
     with Size => 1;
   for TIM3_SMCR_ECE_Field use
     (B_0x0 => 0,
      B_0x1 => 1);

   --  External trigger polarity
   type TIM3_SMCR_ETP_Field is
     (--  tim_etr_in is non-inverted, active at high level or rising edge
      B_0x0,
      --  tim_etr_in is inverted, active at low level or falling edge
      B_0x1)
     with Size => 1;
   for TIM3_SMCR_ETP_Field use
     (B_0x0 => 0,
      B_0x1 => 1);

   subtype TIM3_SMCR_TS_1_Field is STM32G4_SVD.UInt2;

   --  SMS preload enable
   type TIM3_SMCR_SMSPE_Field is
     (--  SMS[3:0] bitfield is not preloaded
      B_0x0,
      --  SMS[3:0] preload is enabled
      B_0x1)
     with Size => 1;
   for TIM3_SMCR_SMSPE_Field use
     (B_0x0 => 0,
      B_0x1 => 1);

   --  SMS preload source
   type TIM3_SMCR_SMSPS_Field is
     (--  The transfer is triggered by the Timer's Update event
      B_0x0,
      --  The transfer is triggered by the Index event
      B_0x1)
     with Size => 1;
   for TIM3_SMCR_SMSPS_Field use
     (B_0x0 => 0,
      B_0x1 => 1);

   --  TIM3 slave mode control register
   type TIM3_SMCR_Register is record
      --  SMS[0]: Slave mode selection
      SMS            : TIM3_SMCR_SMS_Field := STM32G4_SVD.TIM.B_0x0;
      --  OCREF clear selection
      OCCS           : TIM3_SMCR_OCCS_Field := STM32G4_SVD.TIM.B_0x0;
      --  TS[0]: Trigger selection
      TS             : TIM3_SMCR_TS_Field := STM32G4_SVD.TIM.B_0x0;
      --  Master/Slave mode
      MSM            : TIM3_SMCR_MSM_Field := STM32G4_SVD.TIM.B_0x0;
      --  External trigger filter
      ETF            : TIM3_SMCR_ETF_Field := STM32G4_SVD.TIM.B_0x0;
      --  External trigger prescaler
      ETPS           : TIM3_SMCR_ETPS_Field := STM32G4_SVD.TIM.B_0x0;
      --  External clock enable
      ECE            : TIM3_SMCR_ECE_Field := STM32G4_SVD.TIM.B_0x0;
      --  External trigger polarity
      ETP            : TIM3_SMCR_ETP_Field := STM32G4_SVD.TIM.B_0x0;
      --  SMS[3]
      SMS_1          : Boolean := False;
      --  unspecified
      Reserved_17_19 : STM32G4_SVD.UInt3 := 16#0#;
      --  TS[4:3]
      TS_1           : TIM3_SMCR_TS_1_Field := 16#0#;
      --  unspecified
      Reserved_22_23 : STM32G4_SVD.UInt2 := 16#0#;
      --  SMS preload enable
      SMSPE          : TIM3_SMCR_SMSPE_Field := STM32G4_SVD.TIM.B_0x0;
      --  SMS preload source
      SMSPS          : TIM3_SMCR_SMSPS_Field := STM32G4_SVD.TIM.B_0x0;
      --  unspecified
      Reserved_26_31 : STM32G4_SVD.UInt6 := 16#0#;
   end record
     with Volatile_Full_Access, Object_Size => 32,
          Bit_Order => System.Low_Order_First;

   for TIM3_SMCR_Register use record
      SMS            at 0 range 0 .. 2;
      OCCS           at 0 range 3 .. 3;
      TS             at 0 range 4 .. 6;
      MSM            at 0 range 7 .. 7;
      ETF            at 0 range 8 .. 11;
      ETPS           at 0 range 12 .. 13;
      ECE            at 0 range 14 .. 14;
      ETP            at 0 range 15 .. 15;
      SMS_1          at 0 range 16 .. 16;
      Reserved_17_19 at 0 range 17 .. 19;
      TS_1           at 0 range 20 .. 21;
      Reserved_22_23 at 0 range 22 .. 23;
      SMSPE          at 0 range 24 .. 24;
      SMSPS          at 0 range 25 .. 25;
      Reserved_26_31 at 0 range 26 .. 31;
   end record;

   --  Update interrupt enable
   type TIM3_DIER_UIE_Field is
     (--  Update interrupt disabled.
      B_0x0,
      --  Update interrupt enabled.
      B_0x1)
     with Size => 1;
   for TIM3_DIER_UIE_Field use
     (B_0x0 => 0,
      B_0x1 => 1);

   --  Capture/Compare 1 interrupt enable
   type TIM3_DIER_CC1IE_Field is
     (--  CC1 interrupt disabled.
      B_0x0,
      --  CC1 interrupt enabled.
      B_0x1)
     with Size => 1;
   for TIM3_DIER_CC1IE_Field use
     (B_0x0 => 0,
      B_0x1 => 1);

   --  Capture/Compare 2 interrupt enable
   type TIM3_DIER_CC2IE_Field is
     (--  CC2 interrupt disabled.
      B_0x0,
      --  CC2 interrupt enabled.
      B_0x1)
     with Size => 1;
   for TIM3_DIER_CC2IE_Field use
     (B_0x0 => 0,
      B_0x1 => 1);

   --  Capture/Compare 3 interrupt enable
   type TIM3_DIER_CC3IE_Field is
     (--  CC3 interrupt disabled.
      B_0x0,
      --  CC3 interrupt enabled.
      B_0x1)
     with Size => 1;
   for TIM3_DIER_CC3IE_Field use
     (B_0x0 => 0,
      B_0x1 => 1);

   --  Capture/Compare 4 interrupt enable
   type TIM3_DIER_CC4IE_Field is
     (--  CC4 interrupt disabled.
      B_0x0,
      --  CC4 interrupt enabled.
      B_0x1)
     with Size => 1;
   for TIM3_DIER_CC4IE_Field use
     (B_0x0 => 0,
      B_0x1 => 1);

   --  Trigger interrupt enable
   type TIM3_DIER_TIE_Field is
     (--  Trigger interrupt disabled.
      B_0x0,
      --  Trigger interrupt enabled.
      B_0x1)
     with Size => 1;
   for TIM3_DIER_TIE_Field use
     (B_0x0 => 0,
      B_0x1 => 1);

   --  Update DMA request enable
   type TIM3_DIER_UDE_Field is
     (--  Update DMA request disabled.
      B_0x0,
      --  Update DMA request enabled.
      B_0x1)
     with Size => 1;
   for TIM3_DIER_UDE_Field use
     (B_0x0 => 0,
      B_0x1 => 1);

   --  Capture/Compare 1 DMA request enable
   type TIM3_DIER_CC1DE_Field is
     (--  CC1 DMA request disabled.
      B_0x0,
      --  CC1 DMA request enabled.
      B_0x1)
     with Size => 1;
   for TIM3_DIER_CC1DE_Field use
     (B_0x0 => 0,
      B_0x1 => 1);

   --  Capture/Compare 2 DMA request enable
   type TIM3_DIER_CC2DE_Field is
     (--  CC2 DMA request disabled.
      B_0x0,
      --  CC2 DMA request enabled.
      B_0x1)
     with Size => 1;
   for TIM3_DIER_CC2DE_Field use
     (B_0x0 => 0,
      B_0x1 => 1);

   --  Capture/Compare 3 DMA request enable
   type TIM3_DIER_CC3DE_Field is
     (--  CC3 DMA request disabled.
      B_0x0,
      --  CC3 DMA request enabled.
      B_0x1)
     with Size => 1;
   for TIM3_DIER_CC3DE_Field use
     (B_0x0 => 0,
      B_0x1 => 1);

   --  Capture/Compare 4 DMA request enable
   type TIM3_DIER_CC4DE_Field is
     (--  CC4 DMA request disabled.
      B_0x0,
      --  CC4 DMA request enabled.
      B_0x1)
     with Size => 1;
   for TIM3_DIER_CC4DE_Field use
     (B_0x0 => 0,
      B_0x1 => 1);

   --  Trigger DMA request enable
   type TIM3_DIER_TDE_Field is
     (--  Trigger DMA request disabled.
      B_0x0,
      --  Trigger DMA request enabled.
      B_0x1)
     with Size => 1;
   for TIM3_DIER_TDE_Field use
     (B_0x0 => 0,
      B_0x1 => 1);

   --  Index interrupt enable
   type TIM3_DIER_IDXIE_Field is
     (--  Index interrupt disabled
      B_0x0,
      --  Index interrupt enabled
      B_0x1)
     with Size => 1;
   for TIM3_DIER_IDXIE_Field use
     (B_0x0 => 0,
      B_0x1 => 1);

   --  Direction change interrupt enable
   type TIM3_DIER_DIRIE_Field is
     (--  Direction change interrupt disabled
      B_0x0,
      --  Direction change interrupt enabled
      B_0x1)
     with Size => 1;
   for TIM3_DIER_DIRIE_Field use
     (B_0x0 => 0,
      B_0x1 => 1);

   --  Index error interrupt enable
   type TIM3_DIER_IERRIE_Field is
     (--  Index error interrupt disabled
      B_0x0,
      --  Index error interrupt enabled
      B_0x1)
     with Size => 1;
   for TIM3_DIER_IERRIE_Field use
     (B_0x0 => 0,
      B_0x1 => 1);

   --  Transition error interrupt enable
   type TIM3_DIER_TERRIE_Field is
     (--  Transition error interrupt disabled
      B_0x0,
      --  Transition error interrupt enabled
      B_0x1)
     with Size => 1;
   for TIM3_DIER_TERRIE_Field use
     (B_0x0 => 0,
      B_0x1 => 1);

   --  TIM3 DMA/Interrupt enable register
   type TIM3_DIER_Register is record
      --  Update interrupt enable
      UIE            : TIM3_DIER_UIE_Field := STM32G4_SVD.TIM.B_0x0;
      --  Capture/Compare 1 interrupt enable
      CC1IE          : TIM3_DIER_CC1IE_Field := STM32G4_SVD.TIM.B_0x0;
      --  Capture/Compare 2 interrupt enable
      CC2IE          : TIM3_DIER_CC2IE_Field := STM32G4_SVD.TIM.B_0x0;
      --  Capture/Compare 3 interrupt enable
      CC3IE          : TIM3_DIER_CC3IE_Field := STM32G4_SVD.TIM.B_0x0;
      --  Capture/Compare 4 interrupt enable
      CC4IE          : TIM3_DIER_CC4IE_Field := STM32G4_SVD.TIM.B_0x0;
      --  unspecified
      Reserved_5_5   : STM32G4_SVD.Bit := 16#0#;
      --  Trigger interrupt enable
      TIE            : TIM3_DIER_TIE_Field := STM32G4_SVD.TIM.B_0x0;
      --  unspecified
      Reserved_7_7   : STM32G4_SVD.Bit := 16#0#;
      --  Update DMA request enable
      UDE            : TIM3_DIER_UDE_Field := STM32G4_SVD.TIM.B_0x0;
      --  Capture/Compare 1 DMA request enable
      CC1DE          : TIM3_DIER_CC1DE_Field := STM32G4_SVD.TIM.B_0x0;
      --  Capture/Compare 2 DMA request enable
      CC2DE          : TIM3_DIER_CC2DE_Field := STM32G4_SVD.TIM.B_0x0;
      --  Capture/Compare 3 DMA request enable
      CC3DE          : TIM3_DIER_CC3DE_Field := STM32G4_SVD.TIM.B_0x0;
      --  Capture/Compare 4 DMA request enable
      CC4DE          : TIM3_DIER_CC4DE_Field := STM32G4_SVD.TIM.B_0x0;
      --  unspecified
      Reserved_13_13 : STM32G4_SVD.Bit := 16#0#;
      --  Trigger DMA request enable
      TDE            : TIM3_DIER_TDE_Field := STM32G4_SVD.TIM.B_0x0;
      --  unspecified
      Reserved_15_19 : STM32G4_SVD.UInt5 := 16#0#;
      --  Index interrupt enable
      IDXIE          : TIM3_DIER_IDXIE_Field := STM32G4_SVD.TIM.B_0x0;
      --  Direction change interrupt enable
      DIRIE          : TIM3_DIER_DIRIE_Field := STM32G4_SVD.TIM.B_0x0;
      --  Index error interrupt enable
      IERRIE         : TIM3_DIER_IERRIE_Field := STM32G4_SVD.TIM.B_0x0;
      --  Transition error interrupt enable
      TERRIE         : TIM3_DIER_TERRIE_Field := STM32G4_SVD.TIM.B_0x0;
      --  unspecified
      Reserved_24_31 : STM32G4_SVD.Byte := 16#0#;
   end record
     with Volatile_Full_Access, Object_Size => 32,
          Bit_Order => System.Low_Order_First;

   for TIM3_DIER_Register use record
      UIE            at 0 range 0 .. 0;
      CC1IE          at 0 range 1 .. 1;
      CC2IE          at 0 range 2 .. 2;
      CC3IE          at 0 range 3 .. 3;
      CC4IE          at 0 range 4 .. 4;
      Reserved_5_5   at 0 range 5 .. 5;
      TIE            at 0 range 6 .. 6;
      Reserved_7_7   at 0 range 7 .. 7;
      UDE            at 0 range 8 .. 8;
      CC1DE          at 0 range 9 .. 9;
      CC2DE          at 0 range 10 .. 10;
      CC3DE          at 0 range 11 .. 11;
      CC4DE          at 0 range 12 .. 12;
      Reserved_13_13 at 0 range 13 .. 13;
      TDE            at 0 range 14 .. 14;
      Reserved_15_19 at 0 range 15 .. 19;
      IDXIE          at 0 range 20 .. 20;
      DIRIE          at 0 range 21 .. 21;
      IERRIE         at 0 range 22 .. 22;
      TERRIE         at 0 range 23 .. 23;
      Reserved_24_31 at 0 range 24 .. 31;
   end record;

   --  Update interrupt flag
   type TIM3_SR_UIF_Field is
     (--  No update occurred
      B_0x0,
      --  Update interrupt pending.
      B_0x1)
     with Size => 1;
   for TIM3_SR_UIF_Field use
     (B_0x0 => 0,
      B_0x1 => 1);

   --  Capture/compare 1 interrupt flag
   type TIM3_SR_CC1IF_Field is
     (--  No compare match / No input capture occurred
      B_0x0,
      --  A compare match or an input capture occurred
      B_0x1)
     with Size => 1;
   for TIM3_SR_CC1IF_Field use
     (B_0x0 => 0,
      B_0x1 => 1);

   --  Trigger interrupt flag
   type TIM3_SR_TIF_Field is
     (--  No trigger event occurred.
      B_0x0,
      --  Trigger interrupt pending.
      B_0x1)
     with Size => 1;
   for TIM3_SR_TIF_Field use
     (B_0x0 => 0,
      B_0x1 => 1);

   --  Capture/Compare 1 overcapture flag
   type TIM3_SR_CC1OF_Field is
     (--  No overcapture has been detected.
      B_0x0,
      --  The counter value has been captured in TIMx_CCR1 register while CC1IF flag
--  was already set
      B_0x1)
     with Size => 1;
   for TIM3_SR_CC1OF_Field use
     (B_0x0 => 0,
      B_0x1 => 1);

   --  Index interrupt flag
   type TIM3_SR_IDXF_Field is
     (--  No index event occurred.
      B_0x0,
      --  An index event has occurred
      B_0x1)
     with Size => 1;
   for TIM3_SR_IDXF_Field use
     (B_0x0 => 0,
      B_0x1 => 1);

   --  Direction change interrupt flag
   type TIM3_SR_DIRF_Field is
     (--  No direction change
      B_0x0,
      --  Direction change
      B_0x1)
     with Size => 1;
   for TIM3_SR_DIRF_Field use
     (B_0x0 => 0,
      B_0x1 => 1);

   --  Index error interrupt flag
   type TIM3_SR_IERRF_Field is
     (--  No index error has been detected.
      B_0x0,
      --  An index error has been detected
      B_0x1)
     with Size => 1;
   for TIM3_SR_IERRF_Field use
     (B_0x0 => 0,
      B_0x1 => 1);

   --  Transition error interrupt flag
   type TIM3_SR_TERRF_Field is
     (--  No encoder transition error has been detected.
      B_0x0,
      --  An encoder transition error has been detected
      B_0x1)
     with Size => 1;
   for TIM3_SR_TERRF_Field use
     (B_0x0 => 0,
      B_0x1 => 1);

   --  TIM3 status register
   type TIM3_SR_Register is record
      --  Update interrupt flag
      UIF            : TIM3_SR_UIF_Field := STM32G4_SVD.TIM.B_0x0;
      --  Capture/compare 1 interrupt flag
      CC1IF          : TIM3_SR_CC1IF_Field := STM32G4_SVD.TIM.B_0x0;
      --  Capture/Compare 2 interrupt flag
      CC2IF          : Boolean := False;
      --  Capture/Compare 3 interrupt flag
      CC3IF          : Boolean := False;
      --  Capture/Compare 4 interrupt flag
      CC4IF          : Boolean := False;
      --  unspecified
      Reserved_5_5   : STM32G4_SVD.Bit := 16#0#;
      --  Trigger interrupt flag
      TIF            : TIM3_SR_TIF_Field := STM32G4_SVD.TIM.B_0x0;
      --  unspecified
      Reserved_7_8   : STM32G4_SVD.UInt2 := 16#0#;
      --  Capture/Compare 1 overcapture flag
      CC1OF          : TIM3_SR_CC1OF_Field := STM32G4_SVD.TIM.B_0x0;
      --  Capture/compare 2 overcapture flag
      CC2OF          : Boolean := False;
      --  Capture/Compare 3 overcapture flag
      CC3OF          : Boolean := False;
      --  Capture/Compare 4 overcapture flag
      CC4OF          : Boolean := False;
      --  unspecified
      Reserved_13_19 : STM32G4_SVD.UInt7 := 16#0#;
      --  Index interrupt flag
      IDXF           : TIM3_SR_IDXF_Field := STM32G4_SVD.TIM.B_0x0;
      --  Direction change interrupt flag
      DIRF           : TIM3_SR_DIRF_Field := STM32G4_SVD.TIM.B_0x0;
      --  Index error interrupt flag
      IERRF          : TIM3_SR_IERRF_Field := STM32G4_SVD.TIM.B_0x0;
      --  Transition error interrupt flag
      TERRF          : TIM3_SR_TERRF_Field := STM32G4_SVD.TIM.B_0x0;
      --  unspecified
      Reserved_24_31 : STM32G4_SVD.Byte := 16#0#;
   end record
     with Volatile_Full_Access, Object_Size => 32,
          Bit_Order => System.Low_Order_First;

   for TIM3_SR_Register use record
      UIF            at 0 range 0 .. 0;
      CC1IF          at 0 range 1 .. 1;
      CC2IF          at 0 range 2 .. 2;
      CC3IF          at 0 range 3 .. 3;
      CC4IF          at 0 range 4 .. 4;
      Reserved_5_5   at 0 range 5 .. 5;
      TIF            at 0 range 6 .. 6;
      Reserved_7_8   at 0 range 7 .. 8;
      CC1OF          at 0 range 9 .. 9;
      CC2OF          at 0 range 10 .. 10;
      CC3OF          at 0 range 11 .. 11;
      CC4OF          at 0 range 12 .. 12;
      Reserved_13_19 at 0 range 13 .. 19;
      IDXF           at 0 range 20 .. 20;
      DIRF           at 0 range 21 .. 21;
      IERRF          at 0 range 22 .. 22;
      TERRF          at 0 range 23 .. 23;
      Reserved_24_31 at 0 range 24 .. 31;
   end record;

   --  Update generation
   type TIM3_EGR_UG_Field is
     (--  No action
      B_0x0,
      --  Re-initialize the counter and generates an update of the registers.
      B_0x1)
     with Size => 1;
   for TIM3_EGR_UG_Field use
     (B_0x0 => 0,
      B_0x1 => 1);

   --  Capture/compare 1 generation
   type TIM3_EGR_CC1G_Field is
     (--  No action
      B_0x0,
      --  A capture/compare event is generated on channel 1:
      B_0x1)
     with Size => 1;
   for TIM3_EGR_CC1G_Field use
     (B_0x0 => 0,
      B_0x1 => 1);

   --  Trigger generation
   type TIM3_EGR_TG_Field is
     (--  No action
      B_0x0,
      --  The TIF flag is set in TIMx_SR register.
      B_0x1)
     with Size => 1;
   for TIM3_EGR_TG_Field use
     (B_0x0 => 0,
      B_0x1 => 1);

   --  TIM3 event generation register
   type TIM3_EGR_Register is record
      --  Write-only. Update generation
      UG            : TIM3_EGR_UG_Field := STM32G4_SVD.TIM.B_0x0;
      --  Write-only. Capture/compare 1 generation
      CC1G          : TIM3_EGR_CC1G_Field := STM32G4_SVD.TIM.B_0x0;
      --  Write-only. Capture/compare 2 generation
      CC2G          : Boolean := False;
      --  Write-only. Capture/compare 3 generation
      CC3G          : Boolean := False;
      --  Write-only. Capture/compare 4 generation
      CC4G          : Boolean := False;
      --  unspecified
      Reserved_5_5  : STM32G4_SVD.Bit := 16#0#;
      --  Write-only. Trigger generation
      TG            : TIM3_EGR_TG_Field := STM32G4_SVD.TIM.B_0x0;
      --  unspecified
      Reserved_7_15 : STM32G4_SVD.UInt9 := 16#0#;
   end record
     with Volatile_Full_Access, Object_Size => 16,
          Bit_Order => System.Low_Order_First;

   for TIM3_EGR_Register use record
      UG            at 0 range 0 .. 0;
      CC1G          at 0 range 1 .. 1;
      CC2G          at 0 range 2 .. 2;
      CC3G          at 0 range 3 .. 3;
      CC4G          at 0 range 4 .. 4;
      Reserved_5_5  at 0 range 5 .. 5;
      TG            at 0 range 6 .. 6;
      Reserved_7_15 at 0 range 7 .. 15;
   end record;

   --  Capture/Compare 1 selection
   type TIM3_CCMR1_CC1S_Field is
     (--  CC1 channel is configured as output
      B_0x0,
      --  CC1 channel is configured as input, tim_ic1 is mapped on tim_ti1
      B_0x1,
      --  CC1 channel is configured as input, tim_ic1 is mapped on tim_ti2
      B_0x2,
      --  CC1 channel is configured as input, tim_ic1 is mapped on tim_trc.
      B_0x3)
     with Size => 2;
   for TIM3_CCMR1_CC1S_Field use
     (B_0x0 => 0,
      B_0x1 => 1,
      B_0x2 => 2,
      B_0x3 => 3);

   --  Input capture 1 prescaler
   type TIM3_CCMR1_IC1PSC_Field is
     (--  no prescaler, capture is done each time an edge is detected on the capture
--  input
      B_0x0,
      --  capture is done once every 2 events
      B_0x1,
      --  capture is done once every 4 events
      B_0x2,
      --  capture is done once every 8 events
      B_0x3)
     with Size => 2;
   for TIM3_CCMR1_IC1PSC_Field use
     (B_0x0 => 0,
      B_0x1 => 1,
      B_0x2 => 2,
      B_0x3 => 3);

   --  Input capture 1 filter
   type TIM3_CCMR1_IC1F_Field is
     (--  No filter, sampling is done at fless thansub>DTSless than/sub>
      B_0x0,
      --  fless thansub>SAMPLINGless than/sub>=fless thansub>tim_ker_ckless
--  than/sub>, N=2
      B_0x1,
      --  fless thansub>SAMPLINGless than/sub>=fless thansub>tim_ker_ckless
--  than/sub>, N=4
      B_0x2,
      --  fless thansub>SAMPLINGless than/sub>=fless thansub>tim_ker_ckless
--  than/sub>, N=8
      B_0x3,
      --  fless thansub>SAMPLINGless than/sub>=fless thansub>DTSless than/sub>/2, N=6
      B_0x4,
      --  fless thansub>SAMPLINGless than/sub>=fless thansub>DTSless than/sub>/2, N=8
      B_0x5,
      --  fless thansub>SAMPLINGless than/sub>=fless thansub>DTSless than/sub>/4, N=6
      B_0x6,
      --  fless thansub>SAMPLINGless than/sub>=fless thansub>DTSless than/sub>/4, N=8
      B_0x7,
      --  fless thansub>SAMPLINGless than/sub>=fless thansub>DTSless than/sub>/8, N=6
      B_0x8,
      --  fless thansub>SAMPLINGless than/sub>=fless thansub>DTSless than/sub>/8, N=8
      B_0x9,
      --  fless thansub>SAMPLINGless than/sub>=fless thansub>DTSless than/sub>/16,
--  N=5
      B_0xA,
      --  fless thansub>SAMPLINGless than/sub>=fless thansub>DTSless than/sub>/16,
--  N=6
      B_0xB,
      --  fless thansub>SAMPLINGless than/sub>=fless thansub>DTSless than/sub>/16,
--  N=8
      B_0xC,
      --  fless thansub>SAMPLINGless than/sub>=fless thansub>DTSless than/sub>/32,
--  N=5
      B_0xD,
      --  fless thansub>SAMPLINGless than/sub>=fless thansub>DTSless than/sub>/32,
--  N=6
      B_0xE,
      --  fless thansub>SAMPLINGless than/sub>=fless thansub>DTSless than/sub>/32,
--  N=8
      B_0xF)
     with Size => 4;
   for TIM3_CCMR1_IC1F_Field use
     (B_0x0 => 0,
      B_0x1 => 1,
      B_0x2 => 2,
      B_0x3 => 3,
      B_0x4 => 4,
      B_0x5 => 5,
      B_0x6 => 6,
      B_0x7 => 7,
      B_0x8 => 8,
      B_0x9 => 9,
      B_0xA => 10,
      B_0xB => 11,
      B_0xC => 12,
      B_0xD => 13,
      B_0xE => 14,
      B_0xF => 15);

   --  Capture/compare 2 selection
   type TIM3_CCMR1_CC2S_Field is
     (--  CC2 channel is configured as output.
      B_0x0,
      --  CC2 channel is configured as input, tim_ic2 is mapped on tim_ti2.
      B_0x1,
      --  CC2 channel is configured as input, tim_ic2 is mapped on tim_ti1.
      B_0x2,
      --  CC2 channel is configured as input, tim_ic2 is mapped on tim_trc.
      B_0x3)
     with Size => 2;
   for TIM3_CCMR1_CC2S_Field use
     (B_0x0 => 0,
      B_0x1 => 1,
      B_0x2 => 2,
      B_0x3 => 3);

   subtype TIM3_CCMR1_IC2PSC_Field is STM32G4_SVD.UInt2;
   subtype TIM3_CCMR1_IC2F_Field is STM32G4_SVD.UInt4;

   --  TIM3 capture/compare mode register 1 [alternate]
   type TIM3_CCMR1_Register is record
      --  Capture/Compare 1 selection
      CC1S           : TIM3_CCMR1_CC1S_Field := STM32G4_SVD.TIM.B_0x0;
      --  Input capture 1 prescaler
      IC1PSC         : TIM3_CCMR1_IC1PSC_Field := STM32G4_SVD.TIM.B_0x0;
      --  Input capture 1 filter
      IC1F           : TIM3_CCMR1_IC1F_Field := STM32G4_SVD.TIM.B_0x0;
      --  Capture/compare 2 selection
      CC2S           : TIM3_CCMR1_CC2S_Field := STM32G4_SVD.TIM.B_0x0;
      --  Input capture 2 prescaler
      IC2PSC         : TIM3_CCMR1_IC2PSC_Field := 16#0#;
      --  Input capture 2 filter
      IC2F           : TIM3_CCMR1_IC2F_Field := 16#0#;
      --  unspecified
      Reserved_16_31 : STM32G4_SVD.UInt16 := 16#0#;
   end record
     with Volatile_Full_Access, Object_Size => 32,
          Bit_Order => System.Low_Order_First;

   for TIM3_CCMR1_Register use record
      CC1S           at 0 range 0 .. 1;
      IC1PSC         at 0 range 2 .. 3;
      IC1F           at 0 range 4 .. 7;
      CC2S           at 0 range 8 .. 9;
      IC2PSC         at 0 range 10 .. 11;
      IC2F           at 0 range 12 .. 15;
      Reserved_16_31 at 0 range 16 .. 31;
   end record;

   --  Capture/Compare 1 selection
   type TIM3_CCMR1_Alternate_CC1S_Field is
     (--  CC1 channel is configured as output.
      B_0x0,
      --  CC1 channel is configured as input, tim_ic1 is mapped on tim_ti1.
      B_0x1,
      --  CC1 channel is configured as input, tim_ic1 is mapped on tim_ti2.
      B_0x2,
      --  CC1 channel is configured as input, tim_ic1 is mapped on tim_trc.
      B_0x3)
     with Size => 2;
   for TIM3_CCMR1_Alternate_CC1S_Field use
     (B_0x0 => 0,
      B_0x1 => 1,
      B_0x2 => 2,
      B_0x3 => 3);

   --  Output compare 1 fast enable
   type TIM3_CCMR1_Alternate_OC1FE_Field is
     (--  CC1 behaves normally depending on counter and CCR1 values even when the
--  trigger is ON.
      B_0x0,
      --  An active edge on the trigger input acts like a compare match on CC1
--  output.
      B_0x1)
     with Size => 1;
   for TIM3_CCMR1_Alternate_OC1FE_Field use
     (B_0x0 => 0,
      B_0x1 => 1);

   --  Output compare 1 preload enable
   type TIM3_CCMR1_Alternate_OC1PE_Field is
     (--  Preload register on TIMx_CCR1 disabled.
      B_0x0,
      --  Preload register on TIMx_CCR1 enabled.
      B_0x1)
     with Size => 1;
   for TIM3_CCMR1_Alternate_OC1PE_Field use
     (B_0x0 => 0,
      B_0x1 => 1);

   --  OC1M[2:0]: Output compare 1 mode
   type TIM3_CCMR1_Alternate_OC1M_Field is
     (--  Frozen - The comparison between the output compare register TIMx_CCR1 and
--  the counter TIMx_CNT has no effect on the outputs.
      B_0x0,
      --  Set channel 1 to active level on match.
      B_0x1,
      --  Set channel 1 to inactive level on match.
      B_0x2,
      --  Toggle - tim_oc1ref toggles when TIMx_CNT=TIMx_CCR1.
      B_0x3,
      --  Force inactive level - tim_oc1ref is forced low.
      B_0x4,
      --  Force active level - tim_oc1ref is forced high.
      B_0x5,
      --  PWM mode 1 - In upcounting, channel 1 is active as long as TIMx_CNTless
--  thanTIMx_CCR1 else inactive.
      B_0x6,
      --  PWM mode 2 - In upcounting, channel 1 is inactive as long as TIMx_CNTless
--  thanTIMx_CCR1 else active.
      B_0x7)
     with Size => 3;
   for TIM3_CCMR1_Alternate_OC1M_Field use
     (B_0x0 => 0,
      B_0x1 => 1,
      B_0x2 => 2,
      B_0x3 => 3,
      B_0x4 => 4,
      B_0x5 => 5,
      B_0x6 => 6,
      B_0x7 => 7);

   --  Output compare 1 clear enable
   type TIM3_CCMR1_Alternate_OC1CE_Field is
     (--  tim_oc1ref is not affected by the tim_ocref_clr_int input
      B_0x0,
      --  tim_oc1ref is cleared as soon as a High level is detected on
--  tim_ocref_clr_int input
      B_0x1)
     with Size => 1;
   for TIM3_CCMR1_Alternate_OC1CE_Field use
     (B_0x0 => 0,
      B_0x1 => 1);

   --  Capture/Compare 2 selection
   type TIM3_CCMR1_Alternate_CC2S_Field is
     (--  CC2 channel is configured as output
      B_0x0,
      --  CC2 channel is configured as input, tim_ic2 is mapped on tim_ti2
      B_0x1,
      --  CC2 channel is configured as input, tim_ic2 is mapped on tim_ti1
      B_0x2,
      --  CC2 channel is configured as input, tim_ic2 is mapped on tim_trc.
      B_0x3)
     with Size => 2;
   for TIM3_CCMR1_Alternate_CC2S_Field use
     (B_0x0 => 0,
      B_0x1 => 1,
      B_0x2 => 2,
      B_0x3 => 3);

   subtype TIM3_CCMR1_Alternate_OC2M_Field is STM32G4_SVD.UInt3;

   --  TIM3 capture/compare mode register 1
   type TIM3_CCMR1_Alternate_Register is record
      --  Capture/Compare 1 selection
      CC1S           : TIM3_CCMR1_Alternate_CC1S_Field :=
                        STM32G4_SVD.TIM.B_0x0;
      --  Output compare 1 fast enable
      OC1FE          : TIM3_CCMR1_Alternate_OC1FE_Field :=
                        STM32G4_SVD.TIM.B_0x0;
      --  Output compare 1 preload enable
      OC1PE          : TIM3_CCMR1_Alternate_OC1PE_Field :=
                        STM32G4_SVD.TIM.B_0x0;
      --  OC1M[2:0]: Output compare 1 mode
      OC1M           : TIM3_CCMR1_Alternate_OC1M_Field :=
                        STM32G4_SVD.TIM.B_0x0;
      --  Output compare 1 clear enable
      OC1CE          : TIM3_CCMR1_Alternate_OC1CE_Field :=
                        STM32G4_SVD.TIM.B_0x0;
      --  Capture/Compare 2 selection
      CC2S           : TIM3_CCMR1_Alternate_CC2S_Field :=
                        STM32G4_SVD.TIM.B_0x0;
      --  Output compare 2 fast enable
      OC2FE          : Boolean := False;
      --  Output compare 2 preload enable
      OC2PE          : Boolean := False;
      --  OC2M[2:0]: Output compare 2 mode
      OC2M           : TIM3_CCMR1_Alternate_OC2M_Field := 16#0#;
      --  Output compare 2 clear enable
      OC2CE          : Boolean := False;
      --  OC1M[3]
      OC1M_1         : Boolean := False;
      --  unspecified
      Reserved_17_23 : STM32G4_SVD.UInt7 := 16#0#;
      --  OC2M[3]
      OC2M_1         : Boolean := False;
      --  unspecified
      Reserved_25_31 : STM32G4_SVD.UInt7 := 16#0#;
   end record
     with Volatile_Full_Access, Object_Size => 32,
          Bit_Order => System.Low_Order_First;

   for TIM3_CCMR1_Alternate_Register use record
      CC1S           at 0 range 0 .. 1;
      OC1FE          at 0 range 2 .. 2;
      OC1PE          at 0 range 3 .. 3;
      OC1M           at 0 range 4 .. 6;
      OC1CE          at 0 range 7 .. 7;
      CC2S           at 0 range 8 .. 9;
      OC2FE          at 0 range 10 .. 10;
      OC2PE          at 0 range 11 .. 11;
      OC2M           at 0 range 12 .. 14;
      OC2CE          at 0 range 15 .. 15;
      OC1M_1         at 0 range 16 .. 16;
      Reserved_17_23 at 0 range 17 .. 23;
      OC2M_1         at 0 range 24 .. 24;
      Reserved_25_31 at 0 range 25 .. 31;
   end record;

   --  Capture/Compare 3 selection
   type TIM3_CCMR2_CC3S_Field is
     (--  CC3 channel is configured as output
      B_0x0,
      --  CC3 channel is configured as input, tim_ic3 is mapped on tim_ti3
      B_0x1,
      --  CC3 channel is configured as input, tim_ic3 is mapped on tim_ti4
      B_0x2,
      --  CC3 channel is configured as input, tim_ic3 is mapped on tim_trc.
      B_0x3)
     with Size => 2;
   for TIM3_CCMR2_CC3S_Field use
     (B_0x0 => 0,
      B_0x1 => 1,
      B_0x2 => 2,
      B_0x3 => 3);

   subtype TIM3_CCMR2_IC3PSC_Field is STM32G4_SVD.UInt2;
   subtype TIM3_CCMR2_IC3F_Field is STM32G4_SVD.UInt4;

   --  Capture/Compare 4 selection
   type TIM3_CCMR2_CC4S_Field is
     (--  CC4 channel is configured as output
      B_0x0,
      --  CC4 channel is configured as input, tim_ic4 is mapped on tim_ti4
      B_0x1,
      --  CC4 channel is configured as input, tim_ic4 is mapped on tim_ti3
      B_0x2,
      --  CC4 channel is configured as input, tim_ic4 is mapped on tim_trc.
      B_0x3)
     with Size => 2;
   for TIM3_CCMR2_CC4S_Field use
     (B_0x0 => 0,
      B_0x1 => 1,
      B_0x2 => 2,
      B_0x3 => 3);

   subtype TIM3_CCMR2_IC4PSC_Field is STM32G4_SVD.UInt2;
   subtype TIM3_CCMR2_IC4F_Field is STM32G4_SVD.UInt4;

   --  TIM3 capture/compare mode register 2 [alternate]
   type TIM3_CCMR2_Register is record
      --  Capture/Compare 3 selection
      CC3S           : TIM3_CCMR2_CC3S_Field := STM32G4_SVD.TIM.B_0x0;
      --  Input capture 3 prescaler
      IC3PSC         : TIM3_CCMR2_IC3PSC_Field := 16#0#;
      --  Input capture 3 filter
      IC3F           : TIM3_CCMR2_IC3F_Field := 16#0#;
      --  Capture/Compare 4 selection
      CC4S           : TIM3_CCMR2_CC4S_Field := STM32G4_SVD.TIM.B_0x0;
      --  Input capture 4 prescaler
      IC4PSC         : TIM3_CCMR2_IC4PSC_Field := 16#0#;
      --  Input capture 4 filter
      IC4F           : TIM3_CCMR2_IC4F_Field := 16#0#;
      --  unspecified
      Reserved_16_31 : STM32G4_SVD.UInt16 := 16#0#;
   end record
     with Volatile_Full_Access, Object_Size => 32,
          Bit_Order => System.Low_Order_First;

   for TIM3_CCMR2_Register use record
      CC3S           at 0 range 0 .. 1;
      IC3PSC         at 0 range 2 .. 3;
      IC3F           at 0 range 4 .. 7;
      CC4S           at 0 range 8 .. 9;
      IC4PSC         at 0 range 10 .. 11;
      IC4F           at 0 range 12 .. 15;
      Reserved_16_31 at 0 range 16 .. 31;
   end record;

   --  Capture/Compare 3 selection
   type TIM3_CCMR2_Alternate_CC3S_Field is
     (--  CC3 channel is configured as output
      B_0x0,
      --  CC3 channel is configured as input, tim_ic3 is mapped on tim_ti3
      B_0x1,
      --  CC3 channel is configured as input, tim_ic3 is mapped on tim_ti4
      B_0x2,
      --  CC3 channel is configured as input, tim_ic3 is mapped on tim_trc.
      B_0x3)
     with Size => 2;
   for TIM3_CCMR2_Alternate_CC3S_Field use
     (B_0x0 => 0,
      B_0x1 => 1,
      B_0x2 => 2,
      B_0x3 => 3);

   subtype TIM3_CCMR2_Alternate_OC3M_Field is STM32G4_SVD.UInt3;

   --  Capture/Compare 4 selection
   type TIM3_CCMR2_Alternate_CC4S_Field is
     (--  CC4 channel is configured as output
      B_0x0,
      --  CC4 channel is configured as input, tim_ic4 is mapped on tim_ti4
      B_0x1,
      --  CC4 channel is configured as input, tim_ic4 is mapped on tim_ti3
      B_0x2,
      --  CC4 channel is configured as input, tim_ic4 is mapped on tim_trc.
      B_0x3)
     with Size => 2;
   for TIM3_CCMR2_Alternate_CC4S_Field use
     (B_0x0 => 0,
      B_0x1 => 1,
      B_0x2 => 2,
      B_0x3 => 3);

   subtype TIM3_CCMR2_Alternate_OC4M_Field is STM32G4_SVD.UInt3;

   --  TIM3 capture/compare mode register 2
   type TIM3_CCMR2_Alternate_Register is record
      --  Capture/Compare 3 selection
      CC3S           : TIM3_CCMR2_Alternate_CC3S_Field :=
                        STM32G4_SVD.TIM.B_0x0;
      --  Output compare 3 fast enable
      OC3FE          : Boolean := False;
      --  Output compare 3 preload enable
      OC3PE          : Boolean := False;
      --  OC3M[2:0]: Output compare 3 mode
      OC3M           : TIM3_CCMR2_Alternate_OC3M_Field := 16#0#;
      --  Output compare 3 clear enable
      OC3CE          : Boolean := False;
      --  Capture/Compare 4 selection
      CC4S           : TIM3_CCMR2_Alternate_CC4S_Field :=
                        STM32G4_SVD.TIM.B_0x0;
      --  Output compare 4 fast enable
      OC4FE          : Boolean := False;
      --  Output compare 4 preload enable
      OC4PE          : Boolean := False;
      --  OC4M[2:0]: Output compare 4 mode
      OC4M           : TIM3_CCMR2_Alternate_OC4M_Field := 16#0#;
      --  Output compare 4 clear enable
      OC4CE          : Boolean := False;
      --  OC3M[3]
      OC3M_1         : Boolean := False;
      --  unspecified
      Reserved_17_23 : STM32G4_SVD.UInt7 := 16#0#;
      --  OC4M[3]
      OC4M_1         : Boolean := False;
      --  unspecified
      Reserved_25_31 : STM32G4_SVD.UInt7 := 16#0#;
   end record
     with Volatile_Full_Access, Object_Size => 32,
          Bit_Order => System.Low_Order_First;

   for TIM3_CCMR2_Alternate_Register use record
      CC3S           at 0 range 0 .. 1;
      OC3FE          at 0 range 2 .. 2;
      OC3PE          at 0 range 3 .. 3;
      OC3M           at 0 range 4 .. 6;
      OC3CE          at 0 range 7 .. 7;
      CC4S           at 0 range 8 .. 9;
      OC4FE          at 0 range 10 .. 10;
      OC4PE          at 0 range 11 .. 11;
      OC4M           at 0 range 12 .. 14;
      OC4CE          at 0 range 15 .. 15;
      OC3M_1         at 0 range 16 .. 16;
      Reserved_17_23 at 0 range 17 .. 23;
      OC4M_1         at 0 range 24 .. 24;
      Reserved_25_31 at 0 range 25 .. 31;
   end record;

   --  Capture/Compare 1 output enable.
   type TIM3_CCER_CC1E_Field is
     (--  Capture mode disabled / OC1 is not active
      B_0x0,
      --  Capture mode enabled / OC1 signal is output on the corresponding output pin
      B_0x1)
     with Size => 1;
   for TIM3_CCER_CC1E_Field use
     (B_0x0 => 0,
      B_0x1 => 1);

   --  Capture/Compare 1 output Polarity.
   type TIM3_CCER_CC1P_Field is
     (--  OC1 active high (output mode) / Edge sensitivity selection (input mode, see
--  below)
      B_0x0,
      --  OC1 active low (output mode) / Edge sensitivity selection (input mode, see
--  below)
      B_0x1)
     with Size => 1;
   for TIM3_CCER_CC1P_Field use
     (B_0x0 => 0,
      B_0x1 => 1);

   --  TIM3 capture/compare enable register
   type TIM3_CCER_Register is record
      --  Capture/Compare 1 output enable.
      CC1E           : TIM3_CCER_CC1E_Field := STM32G4_SVD.TIM.B_0x0;
      --  Capture/Compare 1 output Polarity.
      CC1P           : TIM3_CCER_CC1P_Field := STM32G4_SVD.TIM.B_0x0;
      --  unspecified
      Reserved_2_2   : STM32G4_SVD.Bit := 16#0#;
      --  Capture/Compare 1 output Polarity.
      CC1NP          : Boolean := False;
      --  Capture/Compare 2 output enable.
      CC2E           : Boolean := False;
      --  Capture/Compare 2 output Polarity.
      CC2P           : Boolean := False;
      --  unspecified
      Reserved_6_6   : STM32G4_SVD.Bit := 16#0#;
      --  Capture/Compare 2 output Polarity.
      CC2NP          : Boolean := False;
      --  Capture/Compare 3 output enable.
      CC3E           : Boolean := False;
      --  Capture/Compare 3 output Polarity.
      CC3P           : Boolean := False;
      --  unspecified
      Reserved_10_10 : STM32G4_SVD.Bit := 16#0#;
      --  Capture/Compare 3 output Polarity.
      CC3NP          : Boolean := False;
      --  Capture/Compare 4 output enable.
      CC4E           : Boolean := False;
      --  Capture/Compare 4 output Polarity.
      CC4P           : Boolean := False;
      --  unspecified
      Reserved_14_14 : STM32G4_SVD.Bit := 16#0#;
      --  Capture/Compare 4 output Polarity.
      CC4NP          : Boolean := False;
   end record
     with Volatile_Full_Access, Object_Size => 16,
          Bit_Order => System.Low_Order_First;

   for TIM3_CCER_Register use record
      CC1E           at 0 range 0 .. 0;
      CC1P           at 0 range 1 .. 1;
      Reserved_2_2   at 0 range 2 .. 2;
      CC1NP          at 0 range 3 .. 3;
      CC2E           at 0 range 4 .. 4;
      CC2P           at 0 range 5 .. 5;
      Reserved_6_6   at 0 range 6 .. 6;
      CC2NP          at 0 range 7 .. 7;
      CC3E           at 0 range 8 .. 8;
      CC3P           at 0 range 9 .. 9;
      Reserved_10_10 at 0 range 10 .. 10;
      CC3NP          at 0 range 11 .. 11;
      CC4E           at 0 range 12 .. 12;
      CC4P           at 0 range 13 .. 13;
      Reserved_14_14 at 0 range 14 .. 14;
      CC4NP          at 0 range 15 .. 15;
   end record;

   subtype TIM3_CNT_CNT_Field is STM32G4_SVD.UInt16;

   --  TIM3 counter
   type TIM3_CNT_Register is record
      --  Counter value
      CNT            : TIM3_CNT_CNT_Field := 16#0#;
      --  unspecified
      Reserved_16_30 : STM32G4_SVD.UInt15 := 16#0#;
      --  Value depends on IUFREMAP in TIMx_CR1.
      UIFCPY         : Boolean := False;
   end record
     with Volatile_Full_Access, Object_Size => 32,
          Bit_Order => System.Low_Order_First;

   for TIM3_CNT_Register use record
      CNT            at 0 range 0 .. 15;
      Reserved_16_30 at 0 range 16 .. 30;
      UIFCPY         at 0 range 31 .. 31;
   end record;

   subtype TIM3_ARR_ARR_Field is STM32G4_SVD.UInt20;

   --  TIM3 auto-reload register
   type TIM3_ARR_Register is record
      --  Low Auto-reload value
      ARR            : TIM3_ARR_ARR_Field := 16#FFFF#;
      --  unspecified
      Reserved_20_31 : STM32G4_SVD.UInt12 := 16#0#;
   end record
     with Volatile_Full_Access, Object_Size => 32,
          Bit_Order => System.Low_Order_First;

   for TIM3_ARR_Register use record
      ARR            at 0 range 0 .. 19;
      Reserved_20_31 at 0 range 20 .. 31;
   end record;

   subtype TIM3_CCR1_CCR1_Field is STM32G4_SVD.UInt20;

   --  TIM3 capture/compare register 1
   type TIM3_CCR1_Register is record
      --  Capture/compare 1 value
      CCR1           : TIM3_CCR1_CCR1_Field := 16#0#;
      --  unspecified
      Reserved_20_31 : STM32G4_SVD.UInt12 := 16#0#;
   end record
     with Volatile_Full_Access, Object_Size => 32,
          Bit_Order => System.Low_Order_First;

   for TIM3_CCR1_Register use record
      CCR1           at 0 range 0 .. 19;
      Reserved_20_31 at 0 range 20 .. 31;
   end record;

   subtype TIM3_CCR2_CCR2_Field is STM32G4_SVD.UInt20;

   --  TIM3 capture/compare register 2
   type TIM3_CCR2_Register is record
      --  Capture/compare 1 value
      CCR2           : TIM3_CCR2_CCR2_Field := 16#0#;
      --  unspecified
      Reserved_20_31 : STM32G4_SVD.UInt12 := 16#0#;
   end record
     with Volatile_Full_Access, Object_Size => 32,
          Bit_Order => System.Low_Order_First;

   for TIM3_CCR2_Register use record
      CCR2           at 0 range 0 .. 19;
      Reserved_20_31 at 0 range 20 .. 31;
   end record;

   subtype TIM3_CCR3_CCR3_Field is STM32G4_SVD.UInt20;

   --  TIM3 capture/compare register 3
   type TIM3_CCR3_Register is record
      --  Capture/compare 3 value
      CCR3           : TIM3_CCR3_CCR3_Field := 16#0#;
      --  unspecified
      Reserved_20_31 : STM32G4_SVD.UInt12 := 16#0#;
   end record
     with Volatile_Full_Access, Object_Size => 32,
          Bit_Order => System.Low_Order_First;

   for TIM3_CCR3_Register use record
      CCR3           at 0 range 0 .. 19;
      Reserved_20_31 at 0 range 20 .. 31;
   end record;

   subtype TIM3_CCR4_CCR4_Field is STM32G4_SVD.UInt20;

   --  TIM3 capture/compare register 4
   type TIM3_CCR4_Register is record
      --  Capture/compare 4 value
      CCR4           : TIM3_CCR4_CCR4_Field := 16#0#;
      --  unspecified
      Reserved_20_31 : STM32G4_SVD.UInt12 := 16#0#;
   end record
     with Volatile_Full_Access, Object_Size => 32,
          Bit_Order => System.Low_Order_First;

   for TIM3_CCR4_Register use record
      CCR4           at 0 range 0 .. 19;
      Reserved_20_31 at 0 range 20 .. 31;
   end record;

   --  Index enable
   type TIM3_ECR_IE_Field is
     (--  Index disabled
      B_0x0,
      --  Index enabled
      B_0x1)
     with Size => 1;
   for TIM3_ECR_IE_Field use
     (B_0x0 => 0,
      B_0x1 => 1);

   --  Index direction
   type TIM3_ECR_IDIR_Field is
     (--  Index resets the counter whatever the direction
      B_0x0,
      --  Index resets the counter when up-counting only
      B_0x1,
      --  Index resets the counter when down-counting only
      B_0x2)
     with Size => 2;
   for TIM3_ECR_IDIR_Field use
     (B_0x0 => 0,
      B_0x1 => 1,
      B_0x2 => 2);

   --  First index
   type TIM3_ECR_FIDX_Field is
     (--  Index is always active
      B_0x0,
      --  the first Index only resets the counter
      B_0x1)
     with Size => 1;
   for TIM3_ECR_FIDX_Field use
     (B_0x0 => 0,
      B_0x1 => 1);

   --  Index positioning
   type TIM3_ECR_IPOS_Field is
     (--  Index resets the counter when AB = 00
      B_0x0,
      --  Index resets the counter when AB = 01
      B_0x1,
      --  Index resets the counter when AB = 10
      B_0x2,
      --  Index resets the counter when AB = 11
      B_0x3)
     with Size => 2;
   for TIM3_ECR_IPOS_Field use
     (B_0x0 => 0,
      B_0x1 => 1,
      B_0x2 => 2,
      B_0x3 => 3);

   subtype TIM3_ECR_PW_Field is STM32G4_SVD.Byte;
   subtype TIM3_ECR_PWPRSC_Field is STM32G4_SVD.UInt3;

   --  TIM3 timer encoder control register
   type TIM3_ECR_Register is record
      --  Index enable
      IE             : TIM3_ECR_IE_Field := STM32G4_SVD.TIM.B_0x0;
      --  Index direction
      IDIR           : TIM3_ECR_IDIR_Field := STM32G4_SVD.TIM.B_0x0;
      --  unspecified
      Reserved_3_4   : STM32G4_SVD.UInt2 := 16#0#;
      --  First index
      FIDX           : TIM3_ECR_FIDX_Field := STM32G4_SVD.TIM.B_0x0;
      --  Index positioning
      IPOS           : TIM3_ECR_IPOS_Field := STM32G4_SVD.TIM.B_0x0;
      --  unspecified
      Reserved_8_15  : STM32G4_SVD.Byte := 16#0#;
      --  Pulse width
      PW             : TIM3_ECR_PW_Field := 16#0#;
      --  Pulse width prescaler
      PWPRSC         : TIM3_ECR_PWPRSC_Field := 16#0#;
      --  unspecified
      Reserved_27_31 : STM32G4_SVD.UInt5 := 16#0#;
   end record
     with Volatile_Full_Access, Object_Size => 32,
          Bit_Order => System.Low_Order_First;

   for TIM3_ECR_Register use record
      IE             at 0 range 0 .. 0;
      IDIR           at 0 range 1 .. 2;
      Reserved_3_4   at 0 range 3 .. 4;
      FIDX           at 0 range 5 .. 5;
      IPOS           at 0 range 6 .. 7;
      Reserved_8_15  at 0 range 8 .. 15;
      PW             at 0 range 16 .. 23;
      PWPRSC         at 0 range 24 .. 26;
      Reserved_27_31 at 0 range 27 .. 31;
   end record;

   --  Selects tim_ti1[15:0] input
   type TIM3_TISEL_TI1SEL_Field is
     (--  tim_ti1_in0: TIMx_CH1
      B_0x0,
      --  tim_ti1_in1
      B_0x1,
      --  tim_ti1_in15
      B_0xF)
     with Size => 4;
   for TIM3_TISEL_TI1SEL_Field use
     (B_0x0 => 0,
      B_0x1 => 1,
      B_0xF => 15);

   --  Selects tim_ti2[15:0] input
   type TIM3_TISEL_TI2SEL_Field is
     (--  tim_ti2_in0: TIMx_CH2
      B_0x0,
      --  tim_ti2_in1
      B_0x1,
      --  tim_ti2_in15
      B_0xF)
     with Size => 4;
   for TIM3_TISEL_TI2SEL_Field use
     (B_0x0 => 0,
      B_0x1 => 1,
      B_0xF => 15);

   --  Selects tim_ti3[15:0] input
   type TIM3_TISEL_TI3SEL_Field is
     (--  tim_ti3_in0: TIMx_CH3
      B_0x0,
      --  tim_ti3_in1
      B_0x1,
      --  tim_ti3_in15
      B_0xF)
     with Size => 4;
   for TIM3_TISEL_TI3SEL_Field use
     (B_0x0 => 0,
      B_0x1 => 1,
      B_0xF => 15);

   --  Selects tim_ti4[15:0] input
   type TIM3_TISEL_TI4SEL_Field is
     (--  tim_ti4_in0: TIMx_CH4
      B_0x0,
      --  tim_ti4_in1
      B_0x1,
      --  tim_ti4_in15
      B_0xF)
     with Size => 4;
   for TIM3_TISEL_TI4SEL_Field use
     (B_0x0 => 0,
      B_0x1 => 1,
      B_0xF => 15);

   --  TIM3 timer input selection register
   type TIM3_TISEL_Register is record
      --  Selects tim_ti1[15:0] input
      TI1SEL         : TIM3_TISEL_TI1SEL_Field := STM32G4_SVD.TIM.B_0x0;
      --  unspecified
      Reserved_4_7   : STM32G4_SVD.UInt4 := 16#0#;
      --  Selects tim_ti2[15:0] input
      TI2SEL         : TIM3_TISEL_TI2SEL_Field := STM32G4_SVD.TIM.B_0x0;
      --  unspecified
      Reserved_12_15 : STM32G4_SVD.UInt4 := 16#0#;
      --  Selects tim_ti3[15:0] input
      TI3SEL         : TIM3_TISEL_TI3SEL_Field := STM32G4_SVD.TIM.B_0x0;
      --  unspecified
      Reserved_20_23 : STM32G4_SVD.UInt4 := 16#0#;
      --  Selects tim_ti4[15:0] input
      TI4SEL         : TIM3_TISEL_TI4SEL_Field := STM32G4_SVD.TIM.B_0x0;
      --  unspecified
      Reserved_28_31 : STM32G4_SVD.UInt4 := 16#0#;
   end record
     with Volatile_Full_Access, Object_Size => 32,
          Bit_Order => System.Low_Order_First;

   for TIM3_TISEL_Register use record
      TI1SEL         at 0 range 0 .. 3;
      Reserved_4_7   at 0 range 4 .. 7;
      TI2SEL         at 0 range 8 .. 11;
      Reserved_12_15 at 0 range 12 .. 15;
      TI3SEL         at 0 range 16 .. 19;
      Reserved_20_23 at 0 range 20 .. 23;
      TI4SEL         at 0 range 24 .. 27;
      Reserved_28_31 at 0 range 28 .. 31;
   end record;

   --  etr_in source selection
   type TIM3_AF1_ETRSEL_Field is
     (--  tim_etr0: TIMx_ETR input
      B_0x0,
      --  tim_etr1
      B_0x1,
      --  tim_etr15
      B_0xF)
     with Size => 4;
   for TIM3_AF1_ETRSEL_Field use
     (B_0x0 => 0,
      B_0x1 => 1,
      B_0xF => 15);

   --  TIM3 alternate function register 1
   type TIM3_AF1_Register is record
      --  unspecified
      Reserved_0_13  : STM32G4_SVD.UInt14 := 16#0#;
      --  etr_in source selection
      ETRSEL         : TIM3_AF1_ETRSEL_Field := STM32G4_SVD.TIM.B_0x0;
      --  unspecified
      Reserved_18_31 : STM32G4_SVD.UInt14 := 16#0#;
   end record
     with Volatile_Full_Access, Object_Size => 32,
          Bit_Order => System.Low_Order_First;

   for TIM3_AF1_Register use record
      Reserved_0_13  at 0 range 0 .. 13;
      ETRSEL         at 0 range 14 .. 17;
      Reserved_18_31 at 0 range 18 .. 31;
   end record;

   --  ocref_clr source selection
   type TIM3_AF2_OCRSEL_Field is
     (--  tim_ocref_clr0
      B_0x0,
      --  tim_ocref_clr1
      B_0x1,
      --  tim_ocref_clr7
      B_0x7)
     with Size => 3;
   for TIM3_AF2_OCRSEL_Field use
     (B_0x0 => 0,
      B_0x1 => 1,
      B_0x7 => 7);

   --  TIM3 alternate function register 2
   type TIM3_AF2_Register is record
      --  unspecified
      Reserved_0_15  : STM32G4_SVD.UInt16 := 16#0#;
      --  ocref_clr source selection
      OCRSEL         : TIM3_AF2_OCRSEL_Field := STM32G4_SVD.TIM.B_0x0;
      --  unspecified
      Reserved_19_31 : STM32G4_SVD.UInt13 := 16#0#;
   end record
     with Volatile_Full_Access, Object_Size => 32,
          Bit_Order => System.Low_Order_First;

   for TIM3_AF2_Register use record
      Reserved_0_15  at 0 range 0 .. 15;
      OCRSEL         at 0 range 16 .. 18;
      Reserved_19_31 at 0 range 19 .. 31;
   end record;

   --  DMA base address
   type TIM3_DCR_DBA_Field is
     (--  TIMx_CR1,
      B_0x0,
      --  TIMx_CR2,
      B_0x1,
      --  TIMx_SMCR,
      B_0x2)
     with Size => 5;
   for TIM3_DCR_DBA_Field use
     (B_0x0 => 0,
      B_0x1 => 1,
      B_0x2 => 2);

   --  DMA burst length
   type TIM3_DCR_DBL_Field is
     (--  1 transfer
      B_0x0,
      --  2 transfers
      B_0x1,
      --  3 transfers
      B_0x2,
      --  26 transfers
      B_0x1A)
     with Size => 5;
   for TIM3_DCR_DBL_Field use
     (B_0x0 => 0,
      B_0x1 => 1,
      B_0x2 => 2,
      B_0x1A => 26);

   --  TIM3 DMA control register
   type TIM3_DCR_Register is record
      --  DMA base address
      DBA            : TIM3_DCR_DBA_Field := STM32G4_SVD.TIM.B_0x0;
      --  unspecified
      Reserved_5_7   : STM32G4_SVD.UInt3 := 16#0#;
      --  DMA burst length
      DBL            : TIM3_DCR_DBL_Field := STM32G4_SVD.TIM.B_0x0;
      --  unspecified
      Reserved_13_31 : STM32G4_SVD.UInt19 := 16#0#;
   end record
     with Volatile_Full_Access, Object_Size => 32,
          Bit_Order => System.Low_Order_First;

   for TIM3_DCR_Register use record
      DBA            at 0 range 0 .. 4;
      Reserved_5_7   at 0 range 5 .. 7;
      DBL            at 0 range 8 .. 12;
      Reserved_13_31 at 0 range 13 .. 31;
   end record;

   --  Counter enable
   type TIM6_CR1_CEN_Field is
     (--  Counter disabled
      B_0x0,
      --  Counter enabled
      B_0x1)
     with Size => 1;
   for TIM6_CR1_CEN_Field use
     (B_0x0 => 0,
      B_0x1 => 1);

   --  Update disable
   type TIM6_CR1_UDIS_Field is
     (--  UEV enabled.
      B_0x0,
      --  UEV disabled.
      B_0x1)
     with Size => 1;
   for TIM6_CR1_UDIS_Field use
     (B_0x0 => 0,
      B_0x1 => 1);

   --  Update request source
   type TIM6_CR1_URS_Field is
     (--  Any of the following events generates an update interrupt or DMA request if
--  enabled.
      B_0x0,
      --  Only counter overflow/underflow generates an update interrupt or DMA
--  request if enabled.
      B_0x1)
     with Size => 1;
   for TIM6_CR1_URS_Field use
     (B_0x0 => 0,
      B_0x1 => 1);

   --  One-pulse mode
   type TIM6_CR1_OPM_Field is
     (--  Counter is not stopped at update event
      B_0x0,
      --  Counter stops counting at the next update event (clearing the CEN bit).
      B_0x1)
     with Size => 1;
   for TIM6_CR1_OPM_Field use
     (B_0x0 => 0,
      B_0x1 => 1);

   --  Auto-reload preload enable
   type TIM6_CR1_ARPE_Field is
     (--  TIMx_ARR register is not buffered.
      B_0x0,
      --  TIMx_ARR register is buffered.
      B_0x1)
     with Size => 1;
   for TIM6_CR1_ARPE_Field use
     (B_0x0 => 0,
      B_0x1 => 1);

   --  UIF status bit remapping
   type TIM6_CR1_UIFREMAP_Field is
     (--  No remapping.
      B_0x0,
      --  Remapping enabled.
      B_0x1)
     with Size => 1;
   for TIM6_CR1_UIFREMAP_Field use
     (B_0x0 => 0,
      B_0x1 => 1);

   --  Dithering enable
   type TIM6_CR1_DITHEN_Field is
     (--  Dithering disabled
      B_0x0,
      --  Dithering enabled
      B_0x1)
     with Size => 1;
   for TIM6_CR1_DITHEN_Field use
     (B_0x0 => 0,
      B_0x1 => 1);

   --  TIM6 control register 1
   type TIM6_CR1_Register is record
      --  Counter enable
      CEN            : TIM6_CR1_CEN_Field := STM32G4_SVD.TIM.B_0x0;
      --  Update disable
      UDIS           : TIM6_CR1_UDIS_Field := STM32G4_SVD.TIM.B_0x0;
      --  Update request source
      URS            : TIM6_CR1_URS_Field := STM32G4_SVD.TIM.B_0x0;
      --  One-pulse mode
      OPM            : TIM6_CR1_OPM_Field := STM32G4_SVD.TIM.B_0x0;
      --  unspecified
      Reserved_4_6   : STM32G4_SVD.UInt3 := 16#0#;
      --  Auto-reload preload enable
      ARPE           : TIM6_CR1_ARPE_Field := STM32G4_SVD.TIM.B_0x0;
      --  unspecified
      Reserved_8_10  : STM32G4_SVD.UInt3 := 16#0#;
      --  UIF status bit remapping
      UIFREMAP       : TIM6_CR1_UIFREMAP_Field := STM32G4_SVD.TIM.B_0x0;
      --  Dithering enable
      DITHEN         : TIM6_CR1_DITHEN_Field := STM32G4_SVD.TIM.B_0x0;
      --  unspecified
      Reserved_13_15 : STM32G4_SVD.UInt3 := 16#0#;
   end record
     with Volatile_Full_Access, Object_Size => 16,
          Bit_Order => System.Low_Order_First;

   for TIM6_CR1_Register use record
      CEN            at 0 range 0 .. 0;
      UDIS           at 0 range 1 .. 1;
      URS            at 0 range 2 .. 2;
      OPM            at 0 range 3 .. 3;
      Reserved_4_6   at 0 range 4 .. 6;
      ARPE           at 0 range 7 .. 7;
      Reserved_8_10  at 0 range 8 .. 10;
      UIFREMAP       at 0 range 11 .. 11;
      DITHEN         at 0 range 12 .. 12;
      Reserved_13_15 at 0 range 13 .. 15;
   end record;

   --  Master mode selection
   type TIM6_CR2_MMS_Field is
     (--  Reset - the UG bit from the TIMx_EGR register is used as a trigger output
--  (tim_trgo).
      B_0x0,
      --  Enable - the Counter enable signal, tim_cnt_en, is used as a trigger output
--  (tim_trgo).
      B_0x1,
      --  Update - The update event is selected as a trigger output (tim_trgo).
      B_0x2)
     with Size => 3;
   for TIM6_CR2_MMS_Field use
     (B_0x0 => 0,
      B_0x1 => 1,
      B_0x2 => 2);

   --  TIM6 control register 2
   type TIM6_CR2_Register is record
      --  unspecified
      Reserved_0_3  : STM32G4_SVD.UInt4 := 16#0#;
      --  Master mode selection
      MMS           : TIM6_CR2_MMS_Field := STM32G4_SVD.TIM.B_0x0;
      --  unspecified
      Reserved_7_15 : STM32G4_SVD.UInt9 := 16#0#;
   end record
     with Volatile_Full_Access, Object_Size => 16,
          Bit_Order => System.Low_Order_First;

   for TIM6_CR2_Register use record
      Reserved_0_3  at 0 range 0 .. 3;
      MMS           at 0 range 4 .. 6;
      Reserved_7_15 at 0 range 7 .. 15;
   end record;

   --  Update interrupt enable
   type TIM6_DIER_UIE_Field is
     (--  Update interrupt disabled.
      B_0x0,
      --  Update interrupt enabled.
      B_0x1)
     with Size => 1;
   for TIM6_DIER_UIE_Field use
     (B_0x0 => 0,
      B_0x1 => 1);

   --  Update DMA request enable
   type TIM6_DIER_UDE_Field is
     (--  Update DMA request disabled.
      B_0x0,
      --  Update DMA request enabled.
      B_0x1)
     with Size => 1;
   for TIM6_DIER_UDE_Field use
     (B_0x0 => 0,
      B_0x1 => 1);

   --  TIM6 DMA/Interrupt enable register
   type TIM6_DIER_Register is record
      --  Update interrupt enable
      UIE           : TIM6_DIER_UIE_Field := STM32G4_SVD.TIM.B_0x0;
      --  unspecified
      Reserved_1_7  : STM32G4_SVD.UInt7 := 16#0#;
      --  Update DMA request enable
      UDE           : TIM6_DIER_UDE_Field := STM32G4_SVD.TIM.B_0x0;
      --  unspecified
      Reserved_9_15 : STM32G4_SVD.UInt7 := 16#0#;
   end record
     with Volatile_Full_Access, Object_Size => 16,
          Bit_Order => System.Low_Order_First;

   for TIM6_DIER_Register use record
      UIE           at 0 range 0 .. 0;
      Reserved_1_7  at 0 range 1 .. 7;
      UDE           at 0 range 8 .. 8;
      Reserved_9_15 at 0 range 9 .. 15;
   end record;

   --  Update interrupt flag
   type TIM6_SR_UIF_Field is
     (--  No update occurred.
      B_0x0,
      --  Update interrupt pending.
      B_0x1)
     with Size => 1;
   for TIM6_SR_UIF_Field use
     (B_0x0 => 0,
      B_0x1 => 1);

   --  TIM6 status register
   type TIM6_SR_Register is record
      --  Update interrupt flag
      UIF           : TIM6_SR_UIF_Field := STM32G4_SVD.TIM.B_0x0;
      --  unspecified
      Reserved_1_15 : STM32G4_SVD.UInt15 := 16#0#;
   end record
     with Volatile_Full_Access, Object_Size => 16,
          Bit_Order => System.Low_Order_First;

   for TIM6_SR_Register use record
      UIF           at 0 range 0 .. 0;
      Reserved_1_15 at 0 range 1 .. 15;
   end record;

   --  Update generation
   type TIM6_EGR_UG_Field is
     (--  No action.
      B_0x0,
      --  Re-initializes the timer counter and generates an update of the registers.
      B_0x1)
     with Size => 1;
   for TIM6_EGR_UG_Field use
     (B_0x0 => 0,
      B_0x1 => 1);

   --  TIM6 event generation register
   type TIM6_EGR_Register is record
      --  Write-only. Update generation
      UG            : TIM6_EGR_UG_Field := STM32G4_SVD.TIM.B_0x0;
      --  unspecified
      Reserved_1_15 : STM32G4_SVD.UInt15 := 16#0#;
   end record
     with Volatile_Full_Access, Object_Size => 16,
          Bit_Order => System.Low_Order_First;

   for TIM6_EGR_Register use record
      UG            at 0 range 0 .. 0;
      Reserved_1_15 at 0 range 1 .. 15;
   end record;

   subtype TIM6_CNT_CNT_Field is STM32G4_SVD.UInt16;

   --  TIM6 counter
   type TIM6_CNT_Register is record
      --  Counter value
      CNT            : TIM6_CNT_CNT_Field := 16#0#;
      --  unspecified
      Reserved_16_30 : STM32G4_SVD.UInt15 := 16#0#;
      --  Read-only. UIF copy
      UIFCPY         : Boolean := False;
   end record
     with Volatile_Full_Access, Object_Size => 32,
          Bit_Order => System.Low_Order_First;

   for TIM6_CNT_Register use record
      CNT            at 0 range 0 .. 15;
      Reserved_16_30 at 0 range 16 .. 30;
      UIFCPY         at 0 range 31 .. 31;
   end record;

   subtype TIM6_ARR_ARR_Field is STM32G4_SVD.UInt20;

   --  TIM6 auto-reload register
   type TIM6_ARR_Register is record
      --  Auto-reload value
      ARR            : TIM6_ARR_ARR_Field := 16#FFFF#;
      --  unspecified
      Reserved_20_31 : STM32G4_SVD.UInt12 := 16#0#;
   end record
     with Volatile_Full_Access, Object_Size => 32,
          Bit_Order => System.Low_Order_First;

   for TIM6_ARR_Register use record
      ARR            at 0 range 0 .. 19;
      Reserved_20_31 at 0 range 20 .. 31;
   end record;

   subtype CR1_CKD_Field is STM32G4_SVD.UInt2;

   --  control register 1
   type CR1_Register is record
      --  Counter enable
      CEN            : Boolean := False;
      --  Update disable
      UDIS           : Boolean := False;
      --  Update request source
      URS            : Boolean := False;
      --  One-pulse mode
      OPM            : Boolean := False;
      --  unspecified
      Reserved_4_6   : STM32G4_SVD.UInt3 := 16#0#;
      --  Auto-reload preload enable
      ARPE           : Boolean := False;
      --  Clock division
      CKD            : CR1_CKD_Field := 16#0#;
      --  unspecified
      Reserved_10_10 : STM32G4_SVD.Bit := 16#0#;
      --  UIF status bit remapping
      UIFREMAP       : Boolean := False;
      --  Dithering Enable
      DITHEN         : Boolean := False;
      --  unspecified
      Reserved_13_31 : STM32G4_SVD.UInt19 := 16#0#;
   end record
     with Volatile_Full_Access, Object_Size => 32,
          Bit_Order => System.Low_Order_First;

   for CR1_Register use record
      CEN            at 0 range 0 .. 0;
      UDIS           at 0 range 1 .. 1;
      URS            at 0 range 2 .. 2;
      OPM            at 0 range 3 .. 3;
      Reserved_4_6   at 0 range 4 .. 6;
      ARPE           at 0 range 7 .. 7;
      CKD            at 0 range 8 .. 9;
      Reserved_10_10 at 0 range 10 .. 10;
      UIFREMAP       at 0 range 11 .. 11;
      DITHEN         at 0 range 12 .. 12;
      Reserved_13_31 at 0 range 13 .. 31;
   end record;

   subtype CR2_MMS_Field is STM32G4_SVD.UInt3;

   --  control register 2
   type CR2_Register is record
      --  Capture/compare preloaded control
      CCPC           : Boolean := False;
      --  unspecified
      Reserved_1_1   : STM32G4_SVD.Bit := 16#0#;
      --  Capture/compare control update selection
      CCUS           : Boolean := False;
      --  Capture/compare DMA selection
      CCDS           : Boolean := False;
      --  Master mode selection
      MMS            : CR2_MMS_Field := 16#0#;
      --  TI1 selection
      TI1S           : Boolean := False;
      --  Output Idle state 1
      OIS1           : Boolean := False;
      --  Output Idle state 1
      OIS1N          : Boolean := False;
      --  Output idle state 2 (OC2 output)
      OIS2           : Boolean := False;
      --  unspecified
      Reserved_11_31 : STM32G4_SVD.UInt21 := 16#0#;
   end record
     with Volatile_Full_Access, Object_Size => 32,
          Bit_Order => System.Low_Order_First;

   for CR2_Register use record
      CCPC           at 0 range 0 .. 0;
      Reserved_1_1   at 0 range 1 .. 1;
      CCUS           at 0 range 2 .. 2;
      CCDS           at 0 range 3 .. 3;
      MMS            at 0 range 4 .. 6;
      TI1S           at 0 range 7 .. 7;
      OIS1           at 0 range 8 .. 8;
      OIS1N          at 0 range 9 .. 9;
      OIS2           at 0 range 10 .. 10;
      Reserved_11_31 at 0 range 11 .. 31;
   end record;

   subtype SMCR_SMS_Field is STM32G4_SVD.UInt3;
   subtype SMCR_TS_Field is STM32G4_SVD.UInt3;
   subtype SMCR_TS_4_3_Field is STM32G4_SVD.UInt2;

   --  slave mode control register
   type SMCR_Register is record
      --  Slave mode selection
      SMS            : SMCR_SMS_Field := 16#0#;
      --  unspecified
      Reserved_3_3   : STM32G4_SVD.Bit := 16#0#;
      --  Trigger selection
      TS             : SMCR_TS_Field := 16#0#;
      --  Master/Slave mode
      MSM            : Boolean := False;
      --  unspecified
      Reserved_8_15  : STM32G4_SVD.Byte := 16#0#;
      --  Slave mode selection - bit 3
      SMS_3          : Boolean := False;
      --  unspecified
      Reserved_17_19 : STM32G4_SVD.UInt3 := 16#0#;
      --  Trigger selection - bit 4:3
      TS_4_3         : SMCR_TS_4_3_Field := 16#0#;
      --  unspecified
      Reserved_22_31 : STM32G4_SVD.UInt10 := 16#0#;
   end record
     with Volatile_Full_Access, Object_Size => 32,
          Bit_Order => System.Low_Order_First;

   for SMCR_Register use record
      SMS            at 0 range 0 .. 2;
      Reserved_3_3   at 0 range 3 .. 3;
      TS             at 0 range 4 .. 6;
      MSM            at 0 range 7 .. 7;
      Reserved_8_15  at 0 range 8 .. 15;
      SMS_3          at 0 range 16 .. 16;
      Reserved_17_19 at 0 range 17 .. 19;
      TS_4_3         at 0 range 20 .. 21;
      Reserved_22_31 at 0 range 22 .. 31;
   end record;

   --  DMA/Interrupt enable register
   type DIER_Register is record
      --  Update interrupt enable
      UIE            : Boolean := False;
      --  Capture/Compare 1 interrupt enable
      CC1IE          : Boolean := False;
      --  Capture/Compare 2 interrupt enable
      CC2IE          : Boolean := False;
      --  unspecified
      Reserved_3_4   : STM32G4_SVD.UInt2 := 16#0#;
      --  COM interrupt enable
      COMIE          : Boolean := False;
      --  Trigger interrupt enable
      TIE            : Boolean := False;
      --  Break interrupt enable
      BIE            : Boolean := False;
      --  Update DMA request enable
      UDE            : Boolean := False;
      --  Capture/Compare 1 DMA request enable
      CC1DE          : Boolean := False;
      --  Capture/Compare 2 DMA request enable
      CC2DE          : Boolean := False;
      --  unspecified
      Reserved_11_12 : STM32G4_SVD.UInt2 := 16#0#;
      --  COM DMA request enable
      COMDE          : Boolean := False;
      --  Trigger DMA request enable
      TDE            : Boolean := False;
      --  unspecified
      Reserved_15_31 : STM32G4_SVD.UInt17 := 16#0#;
   end record
     with Volatile_Full_Access, Object_Size => 32,
          Bit_Order => System.Low_Order_First;

   for DIER_Register use record
      UIE            at 0 range 0 .. 0;
      CC1IE          at 0 range 1 .. 1;
      CC2IE          at 0 range 2 .. 2;
      Reserved_3_4   at 0 range 3 .. 4;
      COMIE          at 0 range 5 .. 5;
      TIE            at 0 range 6 .. 6;
      BIE            at 0 range 7 .. 7;
      UDE            at 0 range 8 .. 8;
      CC1DE          at 0 range 9 .. 9;
      CC2DE          at 0 range 10 .. 10;
      Reserved_11_12 at 0 range 11 .. 12;
      COMDE          at 0 range 13 .. 13;
      TDE            at 0 range 14 .. 14;
      Reserved_15_31 at 0 range 15 .. 31;
   end record;

   --  status register
   type SR_Register is record
      --  Update interrupt flag
      UIF            : Boolean := False;
      --  Capture/compare 1 interrupt flag
      CC1IF          : Boolean := False;
      --  Capture/compare 2 interrupt flag
      CC2IF          : Boolean := False;
      --  unspecified
      Reserved_3_4   : STM32G4_SVD.UInt2 := 16#0#;
      --  COM interrupt flag
      COMIF          : Boolean := False;
      --  Trigger interrupt flag
      TIF            : Boolean := False;
      --  Break interrupt flag
      BIF            : Boolean := False;
      --  unspecified
      Reserved_8_8   : STM32G4_SVD.Bit := 16#0#;
      --  Capture/Compare 1 overcapture flag
      CC1OF          : Boolean := False;
      --  Capture/Compare 2 overcapture flag
      CC2OF          : Boolean := False;
      --  unspecified
      Reserved_11_31 : STM32G4_SVD.UInt21 := 16#0#;
   end record
     with Volatile_Full_Access, Object_Size => 32,
          Bit_Order => System.Low_Order_First;

   for SR_Register use record
      UIF            at 0 range 0 .. 0;
      CC1IF          at 0 range 1 .. 1;
      CC2IF          at 0 range 2 .. 2;
      Reserved_3_4   at 0 range 3 .. 4;
      COMIF          at 0 range 5 .. 5;
      TIF            at 0 range 6 .. 6;
      BIF            at 0 range 7 .. 7;
      Reserved_8_8   at 0 range 8 .. 8;
      CC1OF          at 0 range 9 .. 9;
      CC2OF          at 0 range 10 .. 10;
      Reserved_11_31 at 0 range 11 .. 31;
   end record;

   --  event generation register
   type EGR_Register is record
      --  Write-only. Update generation
      UG            : Boolean := False;
      --  Write-only. Capture/compare 1 generation
      CC1G          : Boolean := False;
      --  Write-only. Capture/compare 2 generation
      CC2G          : Boolean := False;
      --  unspecified
      Reserved_3_4  : STM32G4_SVD.UInt2 := 16#0#;
      --  Write-only. Capture/Compare control update generation
      COMG          : Boolean := False;
      --  Write-only. Trigger generation
      TG            : Boolean := False;
      --  Write-only. Break generation
      BG            : Boolean := False;
      --  unspecified
      Reserved_8_31 : STM32G4_SVD.UInt24 := 16#0#;
   end record
     with Volatile_Full_Access, Object_Size => 32,
          Bit_Order => System.Low_Order_First;

   for EGR_Register use record
      UG            at 0 range 0 .. 0;
      CC1G          at 0 range 1 .. 1;
      CC2G          at 0 range 2 .. 2;
      Reserved_3_4  at 0 range 3 .. 4;
      COMG          at 0 range 5 .. 5;
      TG            at 0 range 6 .. 6;
      BG            at 0 range 7 .. 7;
      Reserved_8_31 at 0 range 8 .. 31;
   end record;

   subtype CCMR1_Output_CC1S_Field is STM32G4_SVD.UInt2;
   subtype CCMR1_Output_OC1M_Field is STM32G4_SVD.UInt3;
   subtype CCMR1_Output_CC2S_Field is STM32G4_SVD.UInt2;
   subtype CCMR1_Output_OC2M_Field is STM32G4_SVD.UInt3;

   --  capture/compare mode register (output mode)
   type CCMR1_Output_Register is record
      --  Capture/Compare 1 selection
      CC1S           : CCMR1_Output_CC1S_Field := 16#0#;
      --  Output Compare 1 fast enable
      OC1FE          : Boolean := False;
      --  Output Compare 1 preload enable
      OC1PE          : Boolean := False;
      --  Output Compare 1 mode
      OC1M           : CCMR1_Output_OC1M_Field := 16#0#;
      --  OC1CE
      OC1CE          : Boolean := False;
      --  CC2S
      CC2S           : CCMR1_Output_CC2S_Field := 16#0#;
      --  OC2FE
      OC2FE          : Boolean := False;
      --  OC2PE
      OC2PE          : Boolean := False;
      --  OC2M
      OC2M           : CCMR1_Output_OC2M_Field := 16#0#;
      --  unspecified
      Reserved_15_15 : STM32G4_SVD.Bit := 16#0#;
      --  Output Compare 1 mode
      OC1M_3         : Boolean := False;
      --  unspecified
      Reserved_17_23 : STM32G4_SVD.UInt7 := 16#0#;
      --  Output Compare 2 mode - bit 3
      OC2M_3         : Boolean := False;
      --  unspecified
      Reserved_25_31 : STM32G4_SVD.UInt7 := 16#0#;
   end record
     with Volatile_Full_Access, Object_Size => 32,
          Bit_Order => System.Low_Order_First;

   for CCMR1_Output_Register use record
      CC1S           at 0 range 0 .. 1;
      OC1FE          at 0 range 2 .. 2;
      OC1PE          at 0 range 3 .. 3;
      OC1M           at 0 range 4 .. 6;
      OC1CE          at 0 range 7 .. 7;
      CC2S           at 0 range 8 .. 9;
      OC2FE          at 0 range 10 .. 10;
      OC2PE          at 0 range 11 .. 11;
      OC2M           at 0 range 12 .. 14;
      Reserved_15_15 at 0 range 15 .. 15;
      OC1M_3         at 0 range 16 .. 16;
      Reserved_17_23 at 0 range 17 .. 23;
      OC2M_3         at 0 range 24 .. 24;
      Reserved_25_31 at 0 range 25 .. 31;
   end record;

   subtype CCMR1_Input_CC1S_Field is STM32G4_SVD.UInt2;
   subtype CCMR1_Input_IC1PSC_Field is STM32G4_SVD.UInt2;
   subtype CCMR1_Input_IC1F_Field is STM32G4_SVD.UInt4;
   subtype CCMR1_Input_CC2S_Field is STM32G4_SVD.UInt2;
   subtype CCMR1_Input_IC2PSC_Field is STM32G4_SVD.UInt2;
   subtype CCMR1_Input_IC2F_Field is STM32G4_SVD.UInt4;

   --  capture/compare mode register 1 (input mode)
   type CCMR1_Input_Register is record
      --  Capture/Compare 1 selection
      CC1S           : CCMR1_Input_CC1S_Field := 16#0#;
      --  Input capture 1 prescaler
      IC1PSC         : CCMR1_Input_IC1PSC_Field := 16#0#;
      --  Input capture 1 filter
      IC1F           : CCMR1_Input_IC1F_Field := 16#0#;
      --  CC2S
      CC2S           : CCMR1_Input_CC2S_Field := 16#0#;
      --  IC2PSC
      IC2PSC         : CCMR1_Input_IC2PSC_Field := 16#0#;
      --  IC2F
      IC2F           : CCMR1_Input_IC2F_Field := 16#0#;
      --  unspecified
      Reserved_16_31 : STM32G4_SVD.UInt16 := 16#0#;
   end record
     with Volatile_Full_Access, Object_Size => 32,
          Bit_Order => System.Low_Order_First;

   for CCMR1_Input_Register use record
      CC1S           at 0 range 0 .. 1;
      IC1PSC         at 0 range 2 .. 3;
      IC1F           at 0 range 4 .. 7;
      CC2S           at 0 range 8 .. 9;
      IC2PSC         at 0 range 10 .. 11;
      IC2F           at 0 range 12 .. 15;
      Reserved_16_31 at 0 range 16 .. 31;
   end record;

   --  capture/compare enable register
   type CCER_Register is record
      --  Capture/Compare 1 output enable
      CC1E          : Boolean := False;
      --  Capture/Compare 1 output Polarity
      CC1P          : Boolean := False;
      --  Capture/Compare 1 complementary output enable
      CC1NE         : Boolean := False;
      --  Capture/Compare 1 output Polarity
      CC1NP         : Boolean := False;
      --  Capture/Compare 2 output enable
      CC2E          : Boolean := False;
      --  Capture/Compare 2 output polarity
      CC2P          : Boolean := False;
      --  unspecified
      Reserved_6_6  : STM32G4_SVD.Bit := 16#0#;
      --  Capture/Compare 2 complementary output polarity
      CC2NP         : Boolean := False;
      --  unspecified
      Reserved_8_31 : STM32G4_SVD.UInt24 := 16#0#;
   end record
     with Volatile_Full_Access, Object_Size => 32,
          Bit_Order => System.Low_Order_First;

   for CCER_Register use record
      CC1E          at 0 range 0 .. 0;
      CC1P          at 0 range 1 .. 1;
      CC1NE         at 0 range 2 .. 2;
      CC1NP         at 0 range 3 .. 3;
      CC2E          at 0 range 4 .. 4;
      CC2P          at 0 range 5 .. 5;
      Reserved_6_6  at 0 range 6 .. 6;
      CC2NP         at 0 range 7 .. 7;
      Reserved_8_31 at 0 range 8 .. 31;
   end record;

   subtype CNT_CNT_Field is STM32G4_SVD.UInt16;

   --  counter
   type CNT_Register is record
      --  counter value
      CNT            : CNT_CNT_Field := 16#0#;
      --  unspecified
      Reserved_16_30 : STM32G4_SVD.UInt15 := 16#0#;
      --  Read-only. UIF Copy
      UIFCPY         : Boolean := False;
   end record
     with Volatile_Full_Access, Object_Size => 32,
          Bit_Order => System.Low_Order_First;

   for CNT_Register use record
      CNT            at 0 range 0 .. 15;
      Reserved_16_30 at 0 range 16 .. 30;
      UIFCPY         at 0 range 31 .. 31;
   end record;

   subtype PSC_PSC_Field is STM32G4_SVD.UInt16;

   --  prescaler
   type PSC_Register is record
      --  Prescaler value
      PSC            : PSC_PSC_Field := 16#0#;
      --  unspecified
      Reserved_16_31 : STM32G4_SVD.UInt16 := 16#0#;
   end record
     with Volatile_Full_Access, Object_Size => 32,
          Bit_Order => System.Low_Order_First;

   for PSC_Register use record
      PSC            at 0 range 0 .. 15;
      Reserved_16_31 at 0 range 16 .. 31;
   end record;

   subtype ARR_ARR_Field is STM32G4_SVD.UInt16;

   --  auto-reload register
   type ARR_Register is record
      --  Auto-reload value
      ARR            : ARR_ARR_Field := 16#FFFF#;
      --  unspecified
      Reserved_16_31 : STM32G4_SVD.UInt16 := 16#0#;
   end record
     with Volatile_Full_Access, Object_Size => 32,
          Bit_Order => System.Low_Order_First;

   for ARR_Register use record
      ARR            at 0 range 0 .. 15;
      Reserved_16_31 at 0 range 16 .. 31;
   end record;

   subtype RCR_REP_Field is STM32G4_SVD.Byte;

   --  repetition counter register
   type RCR_Register is record
      --  Repetition counter value
      REP           : RCR_REP_Field := 16#0#;
      --  unspecified
      Reserved_8_31 : STM32G4_SVD.UInt24 := 16#0#;
   end record
     with Volatile_Full_Access, Object_Size => 32,
          Bit_Order => System.Low_Order_First;

   for RCR_Register use record
      REP           at 0 range 0 .. 7;
      Reserved_8_31 at 0 range 8 .. 31;
   end record;

   subtype CCR1_CCR1_Field is STM32G4_SVD.UInt16;

   --  capture/compare register 1
   type CCR1_Register is record
      --  Capture/Compare 1 value
      CCR1           : CCR1_CCR1_Field := 16#0#;
      --  unspecified
      Reserved_16_31 : STM32G4_SVD.UInt16 := 16#0#;
   end record
     with Volatile_Full_Access, Object_Size => 32,
          Bit_Order => System.Low_Order_First;

   for CCR1_Register use record
      CCR1           at 0 range 0 .. 15;
      Reserved_16_31 at 0 range 16 .. 31;
   end record;

   subtype CCR2_CCR2_Field is STM32G4_SVD.UInt16;

   --  capture/compare register 2
   type CCR2_Register is record
      --  Capture/Compare 1 value
      CCR2           : CCR2_CCR2_Field := 16#0#;
      --  unspecified
      Reserved_16_31 : STM32G4_SVD.UInt16 := 16#0#;
   end record
     with Volatile_Full_Access, Object_Size => 32,
          Bit_Order => System.Low_Order_First;

   for CCR2_Register use record
      CCR2           at 0 range 0 .. 15;
      Reserved_16_31 at 0 range 16 .. 31;
   end record;

   subtype BDTR_DTG_Field is STM32G4_SVD.Byte;
   subtype BDTR_LOCK_Field is STM32G4_SVD.UInt2;
   subtype BDTR_BKF_Field is STM32G4_SVD.UInt4;

   --  break and dead-time register
   type BDTR_Register is record
      --  Dead-time generator setup
      DTG            : BDTR_DTG_Field := 16#0#;
      --  Lock configuration
      LOCK           : BDTR_LOCK_Field := 16#0#;
      --  Off-state selection for Idle mode
      OSSI           : Boolean := False;
      --  Off-state selection for Run mode
      OSSR           : Boolean := False;
      --  Break enable
      BKE            : Boolean := False;
      --  Break polarity
      BKP            : Boolean := False;
      --  Automatic output enable
      AOE            : Boolean := False;
      --  Main output enable
      MOE            : Boolean := False;
      --  Break filter
      BKF            : BDTR_BKF_Field := 16#0#;
      --  unspecified
      Reserved_20_25 : STM32G4_SVD.UInt6 := 16#0#;
      --  BKDSRM
      BKDSRM         : Boolean := False;
      --  unspecified
      Reserved_27_27 : STM32G4_SVD.Bit := 16#0#;
      --  BKBID
      BKBID          : Boolean := False;
      --  unspecified
      Reserved_29_31 : STM32G4_SVD.UInt3 := 16#0#;
   end record
     with Volatile_Full_Access, Object_Size => 32,
          Bit_Order => System.Low_Order_First;

   for BDTR_Register use record
      DTG            at 0 range 0 .. 7;
      LOCK           at 0 range 8 .. 9;
      OSSI           at 0 range 10 .. 10;
      OSSR           at 0 range 11 .. 11;
      BKE            at 0 range 12 .. 12;
      BKP            at 0 range 13 .. 13;
      AOE            at 0 range 14 .. 14;
      MOE            at 0 range 15 .. 15;
      BKF            at 0 range 16 .. 19;
      Reserved_20_25 at 0 range 20 .. 25;
      BKDSRM         at 0 range 26 .. 26;
      Reserved_27_27 at 0 range 27 .. 27;
      BKBID          at 0 range 28 .. 28;
      Reserved_29_31 at 0 range 29 .. 31;
   end record;

   subtype DTR2_DTGF_Field is STM32G4_SVD.Byte;

   --  timer Deadtime Register 2
   type DTR2_Register is record
      --  Dead-time generator setup
      DTGF           : DTR2_DTGF_Field := 16#0#;
      --  unspecified
      Reserved_8_15  : STM32G4_SVD.Byte := 16#0#;
      --  Deadtime Asymmetric Enable
      DTAE           : Boolean := False;
      --  Deadtime Preload Enable
      DTPE           : Boolean := False;
      --  unspecified
      Reserved_18_31 : STM32G4_SVD.UInt14 := 16#0#;
   end record
     with Volatile_Full_Access, Object_Size => 32,
          Bit_Order => System.Low_Order_First;

   for DTR2_Register use record
      DTGF           at 0 range 0 .. 7;
      Reserved_8_15  at 0 range 8 .. 15;
      DTAE           at 0 range 16 .. 16;
      DTPE           at 0 range 17 .. 17;
      Reserved_18_31 at 0 range 18 .. 31;
   end record;

   subtype TISEL_TI1SEL_Field is STM32G4_SVD.UInt4;
   subtype TISEL_TI2SEL_Field is STM32G4_SVD.UInt4;

   --  TIM timer input selection register
   type TISEL_Register is record
      --  TI1[0] to TI1[15] input selection
      TI1SEL         : TISEL_TI1SEL_Field := 16#0#;
      --  unspecified
      Reserved_4_7   : STM32G4_SVD.UInt4 := 16#0#;
      --  TI2[0] to TI2[15] input selection
      TI2SEL         : TISEL_TI2SEL_Field := 16#0#;
      --  unspecified
      Reserved_12_31 : STM32G4_SVD.UInt20 := 16#0#;
   end record
     with Volatile_Full_Access, Object_Size => 32,
          Bit_Order => System.Low_Order_First;

   for TISEL_Register use record
      TI1SEL         at 0 range 0 .. 3;
      Reserved_4_7   at 0 range 4 .. 7;
      TI2SEL         at 0 range 8 .. 11;
      Reserved_12_31 at 0 range 12 .. 31;
   end record;

   --  TIM alternate function option register 1
   type AF1_Register is record
      --  BRK BKIN input enable
      BKINE          : Boolean := False;
      --  BRK COMP1 enable
      BKCMP1E        : Boolean := False;
      --  BRK COMP2 enable
      BKCMP2E        : Boolean := False;
      --  BRK COMP3 enable
      BKCMP3E        : Boolean := False;
      --  BRK COMP4 enable
      BKCMP4E        : Boolean := False;
      --  BRK COMP5 enable
      BKCMP5E        : Boolean := False;
      --  BRK COMP6 enable
      BKCMP6E        : Boolean := False;
      --  BRK COMP7 enable
      BKCMP7E        : Boolean := False;
      --  unspecified
      Reserved_8_8   : STM32G4_SVD.Bit := 16#0#;
      --  BRK BKIN input polarity
      BKINP          : Boolean := False;
      --  BRK COMP1 input polarity
      BKCMP1P        : Boolean := False;
      --  BRK COMP2 input polarity
      BKCMP2P        : Boolean := False;
      --  BRK COMP3 input polarity
      BKCMP3P        : Boolean := False;
      --  BRK COMP4 input polarity
      BKCMP4P        : Boolean := False;
      --  unspecified
      Reserved_14_31 : STM32G4_SVD.UInt18 := 16#0#;
   end record
     with Volatile_Full_Access, Object_Size => 32,
          Bit_Order => System.Low_Order_First;

   for AF1_Register use record
      BKINE          at 0 range 0 .. 0;
      BKCMP1E        at 0 range 1 .. 1;
      BKCMP2E        at 0 range 2 .. 2;
      BKCMP3E        at 0 range 3 .. 3;
      BKCMP4E        at 0 range 4 .. 4;
      BKCMP5E        at 0 range 5 .. 5;
      BKCMP6E        at 0 range 6 .. 6;
      BKCMP7E        at 0 range 7 .. 7;
      Reserved_8_8   at 0 range 8 .. 8;
      BKINP          at 0 range 9 .. 9;
      BKCMP1P        at 0 range 10 .. 10;
      BKCMP2P        at 0 range 11 .. 11;
      BKCMP3P        at 0 range 12 .. 12;
      BKCMP4P        at 0 range 13 .. 13;
      Reserved_14_31 at 0 range 14 .. 31;
   end record;

   subtype AF2_OCRSEL_Field is STM32G4_SVD.UInt3;

   --  TIM alternate function option register 2
   type AF2_Register is record
      --  unspecified
      Reserved_0_15  : STM32G4_SVD.UInt16 := 16#0#;
      --  OCREF_CLR source selection
      OCRSEL         : AF2_OCRSEL_Field := 16#0#;
      --  unspecified
      Reserved_19_31 : STM32G4_SVD.UInt13 := 16#0#;
   end record
     with Volatile_Full_Access, Object_Size => 32,
          Bit_Order => System.Low_Order_First;

   for AF2_Register use record
      Reserved_0_15  at 0 range 0 .. 15;
      OCRSEL         at 0 range 16 .. 18;
      Reserved_19_31 at 0 range 19 .. 31;
   end record;

   subtype DCR_DBA_Field is STM32G4_SVD.UInt5;
   subtype DCR_DBL_Field is STM32G4_SVD.UInt5;

   --  DMA control register
   type DCR_Register is record
      --  DMA base address
      DBA            : DCR_DBA_Field := 16#0#;
      --  unspecified
      Reserved_5_7   : STM32G4_SVD.UInt3 := 16#0#;
      --  DMA burst length
      DBL            : DCR_DBL_Field := 16#0#;
      --  unspecified
      Reserved_13_31 : STM32G4_SVD.UInt19 := 16#0#;
   end record
     with Volatile_Full_Access, Object_Size => 32,
          Bit_Order => System.Low_Order_First;

   for DCR_Register use record
      DBA            at 0 range 0 .. 4;
      Reserved_5_7   at 0 range 5 .. 7;
      DBL            at 0 range 8 .. 12;
      Reserved_13_31 at 0 range 13 .. 31;
   end record;

   --  Counter enable 	
   type TIM16_CR1_CEN_Field is
     (--  Counter disabled
      B_0x0,
      --  Counter enabled
      B_0x1)
     with Size => 1;
   for TIM16_CR1_CEN_Field use
     (B_0x0 => 0,
      B_0x1 => 1);

   --  Update disable 	
   type TIM16_CR1_UDIS_Field is
     (--  UEV enabled.
      B_0x0,
      --  UEV disabled.
      B_0x1)
     with Size => 1;
   for TIM16_CR1_UDIS_Field use
     (B_0x0 => 0,
      B_0x1 => 1);

   --  Update request source 	
   type TIM16_CR1_URS_Field is
     (--  Any of the following events generate an update interrupt or DMA request if
--  enabled.
      B_0x0,
      --  nly counter overflow/underflow generates an update interrupt or DMA request
--  if enabled.
      B_0x1)
     with Size => 1;
   for TIM16_CR1_URS_Field use
     (B_0x0 => 0,
      B_0x1 => 1);

   --  One pulse mode
   type TIM16_CR1_OPM_Field is
     (--  Counter is not stopped at update event
      B_0x0,
      --  Counter stops counting at the next update event (clearing the bit CEN)
      B_0x1)
     with Size => 1;
   for TIM16_CR1_OPM_Field use
     (B_0x0 => 0,
      B_0x1 => 1);

   --  Auto-reload preload enable
   type TIM16_CR1_ARPE_Field is
     (--  TIMx_ARR register is not buffered
      B_0x0,
      --  TIMx_ARR register is buffered
      B_0x1)
     with Size => 1;
   for TIM16_CR1_ARPE_Field use
     (B_0x0 => 0,
      B_0x1 => 1);

   --  Clock division 	
   type TIM16_CR1_CKD_Field is
     (--  tless thansub>DTSless than/sub>=tless thansub>tim_ker_ckless than/sub>
      B_0x0,
      --  tless thansub>DTSless than/sub>=2*tless thansub>tim_ker_ckless than/sub>
      B_0x1,
      --  tless thansub>DTSless than/sub>=4*tless thansub>tim_ker_ckless than/sub>
      B_0x2)
     with Size => 2;
   for TIM16_CR1_CKD_Field use
     (B_0x0 => 0,
      B_0x1 => 1,
      B_0x2 => 2);

   --  UIF status bit remapping
   type TIM16_CR1_UIFREMAP_Field is
     (--  No remapping.
      B_0x0,
      --  Remapping enabled.
      B_0x1)
     with Size => 1;
   for TIM16_CR1_UIFREMAP_Field use
     (B_0x0 => 0,
      B_0x1 => 1);

   --  Dithering enable 	
   type TIM16_CR1_DITHEN_Field is
     (--  Dithering disabled
      B_0x0,
      --  Dithering enabled
      B_0x1)
     with Size => 1;
   for TIM16_CR1_DITHEN_Field use
     (B_0x0 => 0,
      B_0x1 => 1);

   --  TIM16 control register 1
   type TIM16_CR1_Register is record
      --  Counter enable 	
      CEN            : TIM16_CR1_CEN_Field := STM32G4_SVD.TIM.B_0x0;
      --  Update disable 	
      UDIS           : TIM16_CR1_UDIS_Field := STM32G4_SVD.TIM.B_0x0;
      --  Update request source 	
      URS            : TIM16_CR1_URS_Field := STM32G4_SVD.TIM.B_0x0;
      --  One pulse mode
      OPM            : TIM16_CR1_OPM_Field := STM32G4_SVD.TIM.B_0x0;
      --  unspecified
      Reserved_4_6   : STM32G4_SVD.UInt3 := 16#0#;
      --  Auto-reload preload enable
      ARPE           : TIM16_CR1_ARPE_Field := STM32G4_SVD.TIM.B_0x0;
      --  Clock division 	
      CKD            : TIM16_CR1_CKD_Field := STM32G4_SVD.TIM.B_0x0;
      --  unspecified
      Reserved_10_10 : STM32G4_SVD.Bit := 16#0#;
      --  UIF status bit remapping
      UIFREMAP       : TIM16_CR1_UIFREMAP_Field := STM32G4_SVD.TIM.B_0x0;
      --  Dithering enable 	
      DITHEN         : TIM16_CR1_DITHEN_Field := STM32G4_SVD.TIM.B_0x0;
      --  unspecified
      Reserved_13_15 : STM32G4_SVD.UInt3 := 16#0#;
   end record
     with Volatile_Full_Access, Object_Size => 16,
          Bit_Order => System.Low_Order_First;

   for TIM16_CR1_Register use record
      CEN            at 0 range 0 .. 0;
      UDIS           at 0 range 1 .. 1;
      URS            at 0 range 2 .. 2;
      OPM            at 0 range 3 .. 3;
      Reserved_4_6   at 0 range 4 .. 6;
      ARPE           at 0 range 7 .. 7;
      CKD            at 0 range 8 .. 9;
      Reserved_10_10 at 0 range 10 .. 10;
      UIFREMAP       at 0 range 11 .. 11;
      DITHEN         at 0 range 12 .. 12;
      Reserved_13_15 at 0 range 13 .. 15;
   end record;

   --  Capture/compare preloaded control 	
   type TIM16_CR2_CCPC_Field is
     (--  CCxE, CCxNE and OCxM bits are not preloaded
      B_0x0,
      --  CCxE, CCxNE and OCxM bits are preloaded, after having been written, they
--  are updated only when COM bit is set.
      B_0x1)
     with Size => 1;
   for TIM16_CR2_CCPC_Field use
     (B_0x0 => 0,
      B_0x1 => 1);

   --  Capture/compare control update selection 	
   type TIM16_CR2_CCUS_Field is
     (--  When capture/compare control bits are preloaded (CCPC=1), they are updated
--  by setting the COMG bit only.
      B_0x0,
      --  When capture/compare control bits are preloaded (CCPC=1), they are updated
--  by setting the COMG bit or when a rising edge occurs on tim_trgi (if
--  available).
      B_0x1)
     with Size => 1;
   for TIM16_CR2_CCUS_Field use
     (B_0x0 => 0,
      B_0x1 => 1);

   --  Capture/compare DMA selection
   type TIM16_CR2_CCDS_Field is
     (--  CCx DMA request sent when CCx event occurs
      B_0x0,
      --  CCx DMA requests sent when update event occurs
      B_0x1)
     with Size => 1;
   for TIM16_CR2_CCDS_Field use
     (B_0x0 => 0,
      B_0x1 => 1);

   --  Output Idle state 1 (tim_oc1 output) 	
   type TIM16_CR2_OIS1_Field is
     (--  tim_oc1=0 after a dead-time when MOE=0
      B_0x0,
      --  tim_oc1=1 after a dead-time when MOE=0
      B_0x1)
     with Size => 1;
   for TIM16_CR2_OIS1_Field use
     (B_0x0 => 0,
      B_0x1 => 1);

   --  Output Idle state 1 (tim_oc1n output) 	
   type TIM16_CR2_OIS1N_Field is
     (--  tim_oc1n=0 after a dead-time when MOE=0
      B_0x0,
      --  tim_oc1n=1 after a dead-time when MOE=0
      B_0x1)
     with Size => 1;
   for TIM16_CR2_OIS1N_Field use
     (B_0x0 => 0,
      B_0x1 => 1);

   --  TIM16 control register 2
   type TIM16_CR2_Register is record
      --  Capture/compare preloaded control 	
      CCPC           : TIM16_CR2_CCPC_Field := STM32G4_SVD.TIM.B_0x0;
      --  unspecified
      Reserved_1_1   : STM32G4_SVD.Bit := 16#0#;
      --  Capture/compare control update selection 	
      CCUS           : TIM16_CR2_CCUS_Field := STM32G4_SVD.TIM.B_0x0;
      --  Capture/compare DMA selection
      CCDS           : TIM16_CR2_CCDS_Field := STM32G4_SVD.TIM.B_0x0;
      --  unspecified
      Reserved_4_7   : STM32G4_SVD.UInt4 := 16#0#;
      --  Output Idle state 1 (tim_oc1 output) 	
      OIS1           : TIM16_CR2_OIS1_Field := STM32G4_SVD.TIM.B_0x0;
      --  Output Idle state 1 (tim_oc1n output) 	
      OIS1N          : TIM16_CR2_OIS1N_Field := STM32G4_SVD.TIM.B_0x0;
      --  unspecified
      Reserved_10_15 : STM32G4_SVD.UInt6 := 16#0#;
   end record
     with Volatile_Full_Access, Object_Size => 16,
          Bit_Order => System.Low_Order_First;

   for TIM16_CR2_Register use record
      CCPC           at 0 range 0 .. 0;
      Reserved_1_1   at 0 range 1 .. 1;
      CCUS           at 0 range 2 .. 2;
      CCDS           at 0 range 3 .. 3;
      Reserved_4_7   at 0 range 4 .. 7;
      OIS1           at 0 range 8 .. 8;
      OIS1N          at 0 range 9 .. 9;
      Reserved_10_15 at 0 range 10 .. 15;
   end record;

   --  Update interrupt enable
   type TIM16_DIER_UIE_Field is
     (--  Update interrupt disabled
      B_0x0,
      --  Update interrupt enabled
      B_0x1)
     with Size => 1;
   for TIM16_DIER_UIE_Field use
     (B_0x0 => 0,
      B_0x1 => 1);

   --  Capture/Compare 1 interrupt enable
   type TIM16_DIER_CC1IE_Field is
     (--  CC1 interrupt disabled
      B_0x0,
      --  CC1 interrupt enabled
      B_0x1)
     with Size => 1;
   for TIM16_DIER_CC1IE_Field use
     (B_0x0 => 0,
      B_0x1 => 1);

   --  COM interrupt enable
   type TIM16_DIER_COMIE_Field is
     (--  COM interrupt disabled
      B_0x0,
      --  COM interrupt enabled
      B_0x1)
     with Size => 1;
   for TIM16_DIER_COMIE_Field use
     (B_0x0 => 0,
      B_0x1 => 1);

   --  Break interrupt enable
   type TIM16_DIER_BIE_Field is
     (--  Break interrupt disabled
      B_0x0,
      --  Break interrupt enabled
      B_0x1)
     with Size => 1;
   for TIM16_DIER_BIE_Field use
     (B_0x0 => 0,
      B_0x1 => 1);

   --  Update DMA request enable
   type TIM16_DIER_UDE_Field is
     (--  Update DMA request disabled
      B_0x0,
      --  Update DMA request enabled
      B_0x1)
     with Size => 1;
   for TIM16_DIER_UDE_Field use
     (B_0x0 => 0,
      B_0x1 => 1);

   --  Capture/Compare 1 DMA request enable
   type TIM16_DIER_CC1DE_Field is
     (--  CC1 DMA request disabled
      B_0x0,
      --  CC1 DMA request enabled
      B_0x1)
     with Size => 1;
   for TIM16_DIER_CC1DE_Field use
     (B_0x0 => 0,
      B_0x1 => 1);

   --  TIM16 DMA/interrupt enable register
   type TIM16_DIER_Register is record
      --  Update interrupt enable
      UIE            : TIM16_DIER_UIE_Field := STM32G4_SVD.TIM.B_0x0;
      --  Capture/Compare 1 interrupt enable
      CC1IE          : TIM16_DIER_CC1IE_Field := STM32G4_SVD.TIM.B_0x0;
      --  unspecified
      Reserved_2_4   : STM32G4_SVD.UInt3 := 16#0#;
      --  COM interrupt enable
      COMIE          : TIM16_DIER_COMIE_Field := STM32G4_SVD.TIM.B_0x0;
      --  unspecified
      Reserved_6_6   : STM32G4_SVD.Bit := 16#0#;
      --  Break interrupt enable
      BIE            : TIM16_DIER_BIE_Field := STM32G4_SVD.TIM.B_0x0;
      --  Update DMA request enable
      UDE            : TIM16_DIER_UDE_Field := STM32G4_SVD.TIM.B_0x0;
      --  Capture/Compare 1 DMA request enable
      CC1DE          : TIM16_DIER_CC1DE_Field := STM32G4_SVD.TIM.B_0x0;
      --  unspecified
      Reserved_10_15 : STM32G4_SVD.UInt6 := 16#0#;
   end record
     with Volatile_Full_Access, Object_Size => 16,
          Bit_Order => System.Low_Order_First;

   for TIM16_DIER_Register use record
      UIE            at 0 range 0 .. 0;
      CC1IE          at 0 range 1 .. 1;
      Reserved_2_4   at 0 range 2 .. 4;
      COMIE          at 0 range 5 .. 5;
      Reserved_6_6   at 0 range 6 .. 6;
      BIE            at 0 range 7 .. 7;
      UDE            at 0 range 8 .. 8;
      CC1DE          at 0 range 9 .. 9;
      Reserved_10_15 at 0 range 10 .. 15;
   end record;

   --  Update interrupt flag 	
   type TIM16_SR_UIF_Field is
     (--  No update occurred.
      B_0x0,
      --  Update interrupt pending.
      B_0x1)
     with Size => 1;
   for TIM16_SR_UIF_Field use
     (B_0x0 => 0,
      B_0x1 => 1);

   --  Capture/Compare 1 interrupt flag 	
   type TIM16_SR_CC1IF_Field is
     (--  No compare match / No input capture occurred
      B_0x0,
      --  A compare match or an input capture occurred
      B_0x1)
     with Size => 1;
   for TIM16_SR_CC1IF_Field use
     (B_0x0 => 0,
      B_0x1 => 1);

   --  COM interrupt flag 	
   type TIM16_SR_COMIF_Field is
     (--  No COM event occurred
      B_0x0,
      --  COM interrupt pending
      B_0x1)
     with Size => 1;
   for TIM16_SR_COMIF_Field use
     (B_0x0 => 0,
      B_0x1 => 1);

   --  Break interrupt flag 	
   type TIM16_SR_BIF_Field is
     (--  No break event occurred
      B_0x0,
      --  An active level has been detected on the break input
      B_0x1)
     with Size => 1;
   for TIM16_SR_BIF_Field use
     (B_0x0 => 0,
      B_0x1 => 1);

   --  Capture/Compare 1 overcapture flag 	
   type TIM16_SR_CC1OF_Field is
     (--  No overcapture has been detected
      B_0x0,
      --  The counter value has been captured in TIMx_CCR1 register while CC1IF flag
--  was already set
      B_0x1)
     with Size => 1;
   for TIM16_SR_CC1OF_Field use
     (B_0x0 => 0,
      B_0x1 => 1);

   --  TIM16 status register
   type TIM16_SR_Register is record
      --  Update interrupt flag 	
      UIF            : TIM16_SR_UIF_Field := STM32G4_SVD.TIM.B_0x0;
      --  Capture/Compare 1 interrupt flag 	
      CC1IF          : TIM16_SR_CC1IF_Field := STM32G4_SVD.TIM.B_0x0;
      --  unspecified
      Reserved_2_4   : STM32G4_SVD.UInt3 := 16#0#;
      --  COM interrupt flag 	
      COMIF          : TIM16_SR_COMIF_Field := STM32G4_SVD.TIM.B_0x0;
      --  unspecified
      Reserved_6_6   : STM32G4_SVD.Bit := 16#0#;
      --  Break interrupt flag 	
      BIF            : TIM16_SR_BIF_Field := STM32G4_SVD.TIM.B_0x0;
      --  unspecified
      Reserved_8_8   : STM32G4_SVD.Bit := 16#0#;
      --  Capture/Compare 1 overcapture flag 	
      CC1OF          : TIM16_SR_CC1OF_Field := STM32G4_SVD.TIM.B_0x0;
      --  unspecified
      Reserved_10_15 : STM32G4_SVD.UInt6 := 16#0#;
   end record
     with Volatile_Full_Access, Object_Size => 16,
          Bit_Order => System.Low_Order_First;

   for TIM16_SR_Register use record
      UIF            at 0 range 0 .. 0;
      CC1IF          at 0 range 1 .. 1;
      Reserved_2_4   at 0 range 2 .. 4;
      COMIF          at 0 range 5 .. 5;
      Reserved_6_6   at 0 range 6 .. 6;
      BIF            at 0 range 7 .. 7;
      Reserved_8_8   at 0 range 8 .. 8;
      CC1OF          at 0 range 9 .. 9;
      Reserved_10_15 at 0 range 10 .. 15;
   end record;

   --  Update generation 	
   type TIM16_EGR_UG_Field is
     (--  No action.
      B_0x0,
      --  Reinitialize the counter and generates an update of the registers.
      B_0x1)
     with Size => 1;
   for TIM16_EGR_UG_Field use
     (B_0x0 => 0,
      B_0x1 => 1);

   --  Capture/Compare 1 generation 	
   type TIM16_EGR_CC1G_Field is
     (--  No action.
      B_0x0,
      --  A capture/compare event is generated on channel 1:
      B_0x1)
     with Size => 1;
   for TIM16_EGR_CC1G_Field use
     (B_0x0 => 0,
      B_0x1 => 1);

   --  Capture/Compare control update generation 	
   type TIM16_EGR_COMG_Field is
     (--  No action
      B_0x0,
      --  When the CCPC bit is set, it is possible to update the CCxE, CCxNE and OCxM
--  bits
      B_0x1)
     with Size => 1;
   for TIM16_EGR_COMG_Field use
     (B_0x0 => 0,
      B_0x1 => 1);

   --  Break generation 	
   type TIM16_EGR_BG_Field is
     (--  No action.
      B_0x0,
      --  A break event is generated.
      B_0x1)
     with Size => 1;
   for TIM16_EGR_BG_Field use
     (B_0x0 => 0,
      B_0x1 => 1);

   --  TIM16 event generation register
   type TIM16_EGR_Register is record
      --  Write-only. Update generation 	
      UG            : TIM16_EGR_UG_Field := STM32G4_SVD.TIM.B_0x0;
      --  Write-only. Capture/Compare 1 generation 	
      CC1G          : TIM16_EGR_CC1G_Field := STM32G4_SVD.TIM.B_0x0;
      --  unspecified
      Reserved_2_4  : STM32G4_SVD.UInt3 := 16#0#;
      --  Write-only. Capture/Compare control update generation 	
      COMG          : TIM16_EGR_COMG_Field := STM32G4_SVD.TIM.B_0x0;
      --  unspecified
      Reserved_6_6  : STM32G4_SVD.Bit := 16#0#;
      --  Write-only. Break generation 	
      BG            : TIM16_EGR_BG_Field := STM32G4_SVD.TIM.B_0x0;
      --  unspecified
      Reserved_8_15 : STM32G4_SVD.Byte := 16#0#;
   end record
     with Volatile_Full_Access, Object_Size => 16,
          Bit_Order => System.Low_Order_First;

   for TIM16_EGR_Register use record
      UG            at 0 range 0 .. 0;
      CC1G          at 0 range 1 .. 1;
      Reserved_2_4  at 0 range 2 .. 4;
      COMG          at 0 range 5 .. 5;
      Reserved_6_6  at 0 range 6 .. 6;
      BG            at 0 range 7 .. 7;
      Reserved_8_15 at 0 range 8 .. 15;
   end record;

   --  Capture/Compare 1 selection 	
   type TIM16_CCMR1_CC1S_Field is
     (--  CC1 channel is configured as output
      B_0x0,
      --  CC1 channel is configured as input, tim_ic1 is mapped on tim_ti1
      B_0x1)
     with Size => 2;
   for TIM16_CCMR1_CC1S_Field use
     (B_0x0 => 0,
      B_0x1 => 1);

   --  Input capture 1 prescaler 	
   type TIM16_CCMR1_IC1PSC_Field is
     (--  no prescaler, capture is done each time an edge is detected on the capture
--  input.
      B_0x0,
      --  capture is done once every 2 events
      B_0x1,
      --  capture is done once every 4 events
      B_0x2,
      --  capture is done once every 8 events
      B_0x3)
     with Size => 2;
   for TIM16_CCMR1_IC1PSC_Field use
     (B_0x0 => 0,
      B_0x1 => 1,
      B_0x2 => 2,
      B_0x3 => 3);

   --  Input capture 1 filter 	
   type TIM16_CCMR1_IC1F_Field is
     (--  No filter, sampling is done at fless thansub>DTSless than/sub>
      B_0x0,
      --  fless thansub>SAMPLINGless than/sub>=fless thansub>tim_ker_ckless
--  than/sub>, N=2
      B_0x1,
      --  fless thansub>SAMPLINGless than/sub>=fless thansub>tim_ker_ckless
--  than/sub>, N=4
      B_0x2,
      --  fless thansub>SAMPLINGless than/sub>=fless thansub>tim_ker_ckless
--  than/sub>, N=8
      B_0x3,
      --  fless thansub>SAMPLINGless than/sub>=fless thansub>DTSless than/sub>/2, N=
      B_0x4,
      --  fless thansub>SAMPLINGless than/sub>=fless thansub>DTSless than/sub>/2, N=8
      B_0x5,
      --  fless thansub>SAMPLINGless than/sub>=fless thansub>DTSless than/sub>/4, N=6
      B_0x6,
      --  fless thansub>SAMPLINGless than/sub>=fless thansub>DTSless than/sub>/4, N=8
      B_0x7,
      --  fless thansub>SAMPLINGless than/sub>=fless thansub>DTSless than/sub>/8, N=6
      B_0x8,
      --  fless thansub>SAMPLINGless than/sub>=fless thansub>DTSless than/sub>/8, N=8
      B_0x9,
      --  fless thansub>SAMPLINGless than/sub>=fless thansub>DTSless than/sub>/16,
--  N=5
      B_0xA,
      --  fless thansub>SAMPLINGless than/sub>=fless thansub>DTSless than/sub>/16,
--  N=6
      B_0xB,
      --  fless thansub>SAMPLINGless than/sub>=fless thansub>DTSless than/sub>/16,
--  N=8
      B_0xC,
      --  fless thansub>SAMPLINGless than/sub>=fless thansub>DTSless than/sub>/32,
--  N=5
      B_0xD,
      --  fless thansub>SAMPLINGless than/sub>=fless thansub>DTSless than/sub>/32,
--  N=6
      B_0xE,
      --  fless thansub>SAMPLINGless than/sub>=fless thansub>DTSless than/sub>/32,
--  N=8
      B_0xF)
     with Size => 4;
   for TIM16_CCMR1_IC1F_Field use
     (B_0x0 => 0,
      B_0x1 => 1,
      B_0x2 => 2,
      B_0x3 => 3,
      B_0x4 => 4,
      B_0x5 => 5,
      B_0x6 => 6,
      B_0x7 => 7,
      B_0x8 => 8,
      B_0x9 => 9,
      B_0xA => 10,
      B_0xB => 11,
      B_0xC => 12,
      B_0xD => 13,
      B_0xE => 14,
      B_0xF => 15);

   --  TIM16 capture/compare mode register 1
   type TIM16_CCMR1_Register is record
      --  Capture/Compare 1 selection 	
      CC1S          : TIM16_CCMR1_CC1S_Field := STM32G4_SVD.TIM.B_0x0;
      --  Input capture 1 prescaler 	
      IC1PSC        : TIM16_CCMR1_IC1PSC_Field := STM32G4_SVD.TIM.B_0x0;
      --  Input capture 1 filter 	
      IC1F          : TIM16_CCMR1_IC1F_Field := STM32G4_SVD.TIM.B_0x0;
      --  unspecified
      Reserved_8_31 : STM32G4_SVD.UInt24 := 16#0#;
   end record
     with Volatile_Full_Access, Object_Size => 32,
          Bit_Order => System.Low_Order_First;

   for TIM16_CCMR1_Register use record
      CC1S          at 0 range 0 .. 1;
      IC1PSC        at 0 range 2 .. 3;
      IC1F          at 0 range 4 .. 7;
      Reserved_8_31 at 0 range 8 .. 31;
   end record;

   --  Capture/Compare 1 selection 	
   type TIM16_CCMR1_Alternate_CC1S_Field is
     (--  CC1 channel is configured as output
      B_0x0,
      --  CC1 channel is configured as input, tim_ic1 is mapped on tim_ti1
      B_0x1)
     with Size => 2;
   for TIM16_CCMR1_Alternate_CC1S_Field use
     (B_0x0 => 0,
      B_0x1 => 1);

   --  Output Compare 1 fast enable 	
   type TIM16_CCMR1_Alternate_OC1FE_Field is
     (--  CC1 behaves normally depending on counter and CCR1 values even when the
--  trigger is ON.
      B_0x0,
      --  An active edge on the trigger input acts like a compare match on CC1
--  output.
      B_0x1)
     with Size => 1;
   for TIM16_CCMR1_Alternate_OC1FE_Field use
     (B_0x0 => 0,
      B_0x1 => 1);

   --  Output Compare 1 preload enable 	
   type TIM16_CCMR1_Alternate_OC1PE_Field is
     (--  Preload register on TIMx_CCR1 disabled.
      B_0x0,
      --  Preload register on TIMx_CCR1 enabled.
      B_0x1)
     with Size => 1;
   for TIM16_CCMR1_Alternate_OC1PE_Field use
     (B_0x0 => 0,
      B_0x1 => 1);

   --  OC1M[2:0]: Output Compare 1 mode 	
   type TIM16_CCMR1_Alternate_OC1M_Field is
     (--  Frozen - The comparison between the output compare register TIMx_CCR1 and
--  the counter TIMx_CNT has no effect on the outputs.
      B_0x0,
      --  Set channel 1 to active level on match.
      B_0x1,
      --  Set channel 1 to inactive level on match.
      B_0x2,
      --  Toggle - tim_oc1ref toggles when TIMx_CNT=TIMx_CCR1.
      B_0x3,
      --  Force inactive level - tim_oc1ref is forced low.
      B_0x4,
      --  Force active level - tim_oc1ref is forced high.
      B_0x5,
      --  PWM mode 1 - Channel 1 is active as long as TIMx_CNTless thanTIMx_CCR1 else
--  inactive.
      B_0x6,
      --  PWM mode 2 - Channel 1 is inactive as long as TIMx_CNTless thanTIMx_CCR1
--  else active.
      B_0x7)
     with Size => 3;
   for TIM16_CCMR1_Alternate_OC1M_Field use
     (B_0x0 => 0,
      B_0x1 => 1,
      B_0x2 => 2,
      B_0x3 => 3,
      B_0x4 => 4,
      B_0x5 => 5,
      B_0x6 => 6,
      B_0x7 => 7);

   --  Output Compare 1 clear enable
   type TIM16_CCMR1_Alternate_OC1CE_Field is
     (--  tim_oc1ref is not affected by the tim_ocref_clr input.
      B_0x0,
      --  tim_oc1ref is cleared as soon as a High level is detected on tim_ocref_clr
--  input.
      B_0x1)
     with Size => 1;
   for TIM16_CCMR1_Alternate_OC1CE_Field use
     (B_0x0 => 0,
      B_0x1 => 1);

   --  TIM16 capture/compare mode register 1
   type TIM16_CCMR1_Alternate_Register is record
      --  Capture/Compare 1 selection 	
      CC1S           : TIM16_CCMR1_Alternate_CC1S_Field :=
                        STM32G4_SVD.TIM.B_0x0;
      --  Output Compare 1 fast enable 	
      OC1FE          : TIM16_CCMR1_Alternate_OC1FE_Field :=
                        STM32G4_SVD.TIM.B_0x0;
      --  Output Compare 1 preload enable 	
      OC1PE          : TIM16_CCMR1_Alternate_OC1PE_Field :=
                        STM32G4_SVD.TIM.B_0x0;
      --  OC1M[2:0]: Output Compare 1 mode 	
      OC1M           : TIM16_CCMR1_Alternate_OC1M_Field :=
                        STM32G4_SVD.TIM.B_0x0;
      --  Output Compare 1 clear enable
      OC1CE          : TIM16_CCMR1_Alternate_OC1CE_Field :=
                        STM32G4_SVD.TIM.B_0x0;
      --  unspecified
      Reserved_8_15  : STM32G4_SVD.Byte := 16#0#;
      --  OC1M[3]
      OC1M_1         : Boolean := False;
      --  unspecified
      Reserved_17_31 : STM32G4_SVD.UInt15 := 16#0#;
   end record
     with Volatile_Full_Access, Object_Size => 32,
          Bit_Order => System.Low_Order_First;

   for TIM16_CCMR1_Alternate_Register use record
      CC1S           at 0 range 0 .. 1;
      OC1FE          at 0 range 2 .. 2;
      OC1PE          at 0 range 3 .. 3;
      OC1M           at 0 range 4 .. 6;
      OC1CE          at 0 range 7 .. 7;
      Reserved_8_15  at 0 range 8 .. 15;
      OC1M_1         at 0 range 16 .. 16;
      Reserved_17_31 at 0 range 17 .. 31;
   end record;

   --  Capture/Compare 1 output enable 	
   type TIM16_CCER_CC1E_Field is
     (--  Capture mode disabled / OC1 is not active (see below)
      B_0x0,
      --  Capture mode enabled / OC1 signal is output on the corresponding output pin
      B_0x1)
     with Size => 1;
   for TIM16_CCER_CC1E_Field use
     (B_0x0 => 0,
      B_0x1 => 1);

   --  Capture/Compare 1 output polarity 	
   type TIM16_CCER_CC1P_Field is
     (--  OC1 active high (output mode) / Edge sensitivity selection (input mode, see
--  below)
      B_0x0,
      --  OC1 active low (output mode) / Edge sensitivity selection (input mode, see
--  below)
      B_0x1)
     with Size => 1;
   for TIM16_CCER_CC1P_Field use
     (B_0x0 => 0,
      B_0x1 => 1);

   --  Capture/Compare 1 complementary output enable
   type TIM16_CCER_CC1NE_Field is
     (--  Off - tim_oc1n is not active.
      B_0x0,
      --  On - tim_oc1n signal is output on the corresponding output pin depending on
--  MOE, OSSI, OSSR, OIS1, OIS1N and CC1E bits.
      B_0x1)
     with Size => 1;
   for TIM16_CCER_CC1NE_Field use
     (B_0x0 => 0,
      B_0x1 => 1);

   --  Capture/Compare 1 complementary output polarity 	
   type TIM16_CCER_CC1NP_Field is
     (--  tim_oc1n active high
      B_0x0,
      --  tim_oc1n active low
      B_0x1)
     with Size => 1;
   for TIM16_CCER_CC1NP_Field use
     (B_0x0 => 0,
      B_0x1 => 1);

   --  TIM16 capture/compare enable register
   type TIM16_CCER_Register is record
      --  Capture/Compare 1 output enable 	
      CC1E          : TIM16_CCER_CC1E_Field := STM32G4_SVD.TIM.B_0x0;
      --  Capture/Compare 1 output polarity 	
      CC1P          : TIM16_CCER_CC1P_Field := STM32G4_SVD.TIM.B_0x0;
      --  Capture/Compare 1 complementary output enable
      CC1NE         : TIM16_CCER_CC1NE_Field := STM32G4_SVD.TIM.B_0x0;
      --  Capture/Compare 1 complementary output polarity 	
      CC1NP         : TIM16_CCER_CC1NP_Field := STM32G4_SVD.TIM.B_0x0;
      --  unspecified
      Reserved_4_15 : STM32G4_SVD.UInt12 := 16#0#;
   end record
     with Volatile_Full_Access, Object_Size => 16,
          Bit_Order => System.Low_Order_First;

   for TIM16_CCER_Register use record
      CC1E          at 0 range 0 .. 0;
      CC1P          at 0 range 1 .. 1;
      CC1NE         at 0 range 2 .. 2;
      CC1NP         at 0 range 3 .. 3;
      Reserved_4_15 at 0 range 4 .. 15;
   end record;

   subtype TIM16_CNT_CNT_Field is STM32G4_SVD.UInt16;

   --  TIM16 counter
   type TIM16_CNT_Register is record
      --  Counter value 	
      CNT            : TIM16_CNT_CNT_Field := 16#0#;
      --  unspecified
      Reserved_16_30 : STM32G4_SVD.UInt15 := 16#0#;
      --  Read-only. UIF Copy 	
      UIFCPY         : Boolean := False;
   end record
     with Volatile_Full_Access, Object_Size => 32,
          Bit_Order => System.Low_Order_First;

   for TIM16_CNT_Register use record
      CNT            at 0 range 0 .. 15;
      Reserved_16_30 at 0 range 16 .. 30;
      UIFCPY         at 0 range 31 .. 31;
   end record;

   subtype TIM16_ARR_ARR_Field is STM32G4_SVD.UInt20;

   --  TIM16 auto-reload register
   type TIM16_ARR_Register is record
      --  Auto-reload value 	
      ARR            : TIM16_ARR_ARR_Field := 16#FFFF#;
      --  unspecified
      Reserved_20_31 : STM32G4_SVD.UInt12 := 16#0#;
   end record
     with Volatile_Full_Access, Object_Size => 32,
          Bit_Order => System.Low_Order_First;

   for TIM16_ARR_Register use record
      ARR            at 0 range 0 .. 19;
      Reserved_20_31 at 0 range 20 .. 31;
   end record;

   subtype TIM16_RCR_REP_Field is STM32G4_SVD.Byte;

   --  TIM16 repetition counter register
   type TIM16_RCR_Register is record
      --  Repetition counter reload value 	
      REP           : TIM16_RCR_REP_Field := 16#0#;
      --  unspecified
      Reserved_8_15 : STM32G4_SVD.Byte := 16#0#;
   end record
     with Volatile_Full_Access, Object_Size => 16,
          Bit_Order => System.Low_Order_First;

   for TIM16_RCR_Register use record
      REP           at 0 range 0 .. 7;
      Reserved_8_15 at 0 range 8 .. 15;
   end record;

   subtype TIM16_CCR1_CCR1_Field is STM32G4_SVD.UInt20;

   --  TIM16 capture/compare register 1
   type TIM16_CCR1_Register is record
      --  Capture/Compare 1 value 	
      CCR1           : TIM16_CCR1_CCR1_Field := 16#0#;
      --  unspecified
      Reserved_20_31 : STM32G4_SVD.UInt12 := 16#0#;
   end record
     with Volatile_Full_Access, Object_Size => 32,
          Bit_Order => System.Low_Order_First;

   for TIM16_CCR1_Register use record
      CCR1           at 0 range 0 .. 19;
      Reserved_20_31 at 0 range 20 .. 31;
   end record;

   subtype TIM16_BDTR_DTG_Field is STM32G4_SVD.Byte;

   --  Lock configuration 	
   type TIM16_BDTR_LOCK_Field is
     (--  LOCK OFF - No bit is write protected
      B_0x0,
      --  LOCK Level 1 = DTG bits in TIMx_BDTR register, OISx and OISxN bits in
--  TIMx_CR2 register and BKBID/BKE/BKP/AOE bits in TIMx_BDTR register can no
--  longer be written.
      B_0x1,
      --  LOCK Level 2 = LOCK Level 1 + CC Polarity bits (CCxP/CCxNP bits in
--  TIMx_CCER register, as long as the related channel is configured in output
--  through the CCxS bits) as well as OSSR and OSSI bits can no longer be
--  written.
      B_0x2,
      --  LOCK Level 3 = LOCK Level 2 + CC Control bits (OCxM and OCxPE bits in
--  TIMx_CCMRx registers, as long as the related channel is configured in
--  output through the CCxS bits) can no longer be written.
      B_0x3)
     with Size => 2;
   for TIM16_BDTR_LOCK_Field use
     (B_0x0 => 0,
      B_0x1 => 1,
      B_0x2 => 2,
      B_0x3 => 3);

   --  Off-state selection for Idle mode 	
   type TIM16_BDTR_OSSI_Field is
     (--  When inactive, tim_oc1/tim_oc1n outputs are disabled (tim_oc1/tim_oc1n
--  enable output signal=0)
      B_0x0,
      --  When inactive, tim_oc1/tim_oc1n outputs are forced first with their idle
--  level as soon as CC1E=1 or CC1NE=1.
      B_0x1)
     with Size => 1;
   for TIM16_BDTR_OSSI_Field use
     (B_0x0 => 0,
      B_0x1 => 1);

   --  Off-state selection for Run mode 	
   type TIM16_BDTR_OSSR_Field is
     (--  When inactive, tim_oc1/tim_oc1n outputs are disabled (the timer releases
--  the output control which is taken over by the GPIO, which forces a Hi-Z
--  state)
      B_0x0,
      --  When inactive, tim_oc1/tim_oc1n outputs are enabled with their inactive
--  level as soon as CC1E=1 or CC1NE=1 (the output is still controlled by the
--  timer).
      B_0x1)
     with Size => 1;
   for TIM16_BDTR_OSSR_Field use
     (B_0x0 => 0,
      B_0x1 => 1);

   --  Break enable 	
   type TIM16_BDTR_BKE_Field is
     (--  Break inputs (tim_brk and tim_sys_brk event) disabled
      B_0x0)
     with Size => 1;
   for TIM16_BDTR_BKE_Field use
     (B_0x0 => 0);

   --  Break polarity 	
   type TIM16_BDTR_BKP_Field is
     (--  Break input tim_brk is active low
      B_0x0,
      --  Break input tim_brk is active high
      B_0x1)
     with Size => 1;
   for TIM16_BDTR_BKP_Field use
     (B_0x0 => 0,
      B_0x1 => 1);

   --  Automatic output enable 	
   type TIM16_BDTR_AOE_Field is
     (--  MOE can be set only by software
      B_0x0,
      --  MOE can be set by software or automatically at the next update event (if
--  the tim_brk input is not active)
      B_0x1)
     with Size => 1;
   for TIM16_BDTR_AOE_Field use
     (B_0x0 => 0,
      B_0x1 => 1);

   --  Main output enable 	
   type TIM16_BDTR_MOE_Field is
     (--  tim_oc1 and tim_oc1n outputs are disabled or forced to idle state depending
--  on the OSSI bit.
      B_0x0,
      --  tim_oc1 and tim_oc1n outputs are enabled if their respective enable bits
--  are set (CC1E, CC1NE in TIMx_CCER register)
      B_0x1)
     with Size => 1;
   for TIM16_BDTR_MOE_Field use
     (B_0x0 => 0,
      B_0x1 => 1);

   --  Break filter 	
   type TIM16_BDTR_BKF_Field is
     (--  No filter, tim_brk acts asynchronously
      B_0x0,
      --  fless thansub>SAMPLINGless than/sub>=fless thansub>tim_ker_ckless
--  than/sub>, N=2
      B_0x1,
      --  fless thansub>SAMPLINGless than/sub>=fless thansub>tim_ker_ckless
--  than/sub>, N=4
      B_0x2,
      --  fless thansub>SAMPLINGless than/sub>=fless thansub>tim_ker_ckless
--  than/sub>, N=8
      B_0x3,
      --  fless thansub>SAMPLINGless than/sub>=fless thansub>DTSless than/sub>/2, N=6
      B_0x4,
      --  fless thansub>SAMPLINGless than/sub>=fless thansub>DTSless than/sub>/2, N=8
      B_0x5,
      --  fless thansub>SAMPLINGless than/sub>=fless thansub>DTSless than/sub>/4, N=6
      B_0x6,
      --  fless thansub>SAMPLINGless than/sub>=fless thansub>DTSless than/sub>/4, N=8
      B_0x7,
      --  fless thansub>SAMPLINGless than/sub>=fless thansub>DTSless than/sub>/8, N=6
      B_0x8,
      --  fless thansub>SAMPLINGless than/sub>=fless thansub>DTSless than/sub>/8, N=8
      B_0x9,
      --  fless thansub>SAMPLINGless than/sub>=fless thansub>DTSless than/sub>/16,
--  N=5
      B_0xA,
      --  fless thansub>SAMPLINGless than/sub>=fless thansub>DTSless than/sub>/16,
--  N=6
      B_0xB,
      --  fless thansub>SAMPLINGless than/sub>=fless thansub>DTSless than/sub>/16,
--  N=8
      B_0xC,
      --  fless thansub>SAMPLINGless than/sub>=fless thansub>DTSless than/sub>/32,
--  N=5
      B_0xD,
      --  fless thansub>SAMPLINGless than/sub>=fless thansub>DTSless than/sub>/32,
--  N=6
      B_0xE,
      --  fless thansub>SAMPLINGless than/sub>=fless thansub>DTSless than/sub>/32,
--  N=8
      B_0xF)
     with Size => 4;
   for TIM16_BDTR_BKF_Field use
     (B_0x0 => 0,
      B_0x1 => 1,
      B_0x2 => 2,
      B_0x3 => 3,
      B_0x4 => 4,
      B_0x5 => 5,
      B_0x6 => 6,
      B_0x7 => 7,
      B_0x8 => 8,
      B_0x9 => 9,
      B_0xA => 10,
      B_0xB => 11,
      B_0xC => 12,
      B_0xD => 13,
      B_0xE => 14,
      B_0xF => 15);

   --  Break Disarm 	
   type TIM16_BDTR_BKDSRM_Field is
     (--  Break input tim_brk is armed
      B_0x0,
      --  Break input tim_brk is disarmed
      B_0x1)
     with Size => 1;
   for TIM16_BDTR_BKDSRM_Field use
     (B_0x0 => 0,
      B_0x1 => 1);

   --  Break Bidirectional 	
   type TIM16_BDTR_BKBID_Field is
     (--  Break input tim_brk in input mode
      B_0x0,
      --  Break input tim_brk in bidirectional mode
      B_0x1)
     with Size => 1;
   for TIM16_BDTR_BKBID_Field use
     (B_0x0 => 0,
      B_0x1 => 1);

   --  TIM16 break and dead-time register
   type TIM16_BDTR_Register is record
      --  Dead-time generator setup 	
      DTG            : TIM16_BDTR_DTG_Field := 16#0#;
      --  Lock configuration 	
      LOCK           : TIM16_BDTR_LOCK_Field := STM32G4_SVD.TIM.B_0x0;
      --  Off-state selection for Idle mode 	
      OSSI           : TIM16_BDTR_OSSI_Field := STM32G4_SVD.TIM.B_0x0;
      --  Off-state selection for Run mode 	
      OSSR           : TIM16_BDTR_OSSR_Field := STM32G4_SVD.TIM.B_0x0;
      --  Break enable 	
      BKE            : TIM16_BDTR_BKE_Field := STM32G4_SVD.TIM.B_0x0;
      --  Break polarity 	
      BKP            : TIM16_BDTR_BKP_Field := STM32G4_SVD.TIM.B_0x0;
      --  Automatic output enable 	
      AOE            : TIM16_BDTR_AOE_Field := STM32G4_SVD.TIM.B_0x0;
      --  Main output enable 	
      MOE            : TIM16_BDTR_MOE_Field := STM32G4_SVD.TIM.B_0x0;
      --  Break filter 	
      BKF            : TIM16_BDTR_BKF_Field := STM32G4_SVD.TIM.B_0x0;
      --  unspecified
      Reserved_20_25 : STM32G4_SVD.UInt6 := 16#0#;
      --  Break Disarm 	
      BKDSRM         : TIM16_BDTR_BKDSRM_Field := STM32G4_SVD.TIM.B_0x0;
      --  unspecified
      Reserved_27_27 : STM32G4_SVD.Bit := 16#0#;
      --  Break Bidirectional 	
      BKBID          : TIM16_BDTR_BKBID_Field := STM32G4_SVD.TIM.B_0x0;
      --  unspecified
      Reserved_29_31 : STM32G4_SVD.UInt3 := 16#0#;
   end record
     with Volatile_Full_Access, Object_Size => 32,
          Bit_Order => System.Low_Order_First;

   for TIM16_BDTR_Register use record
      DTG            at 0 range 0 .. 7;
      LOCK           at 0 range 8 .. 9;
      OSSI           at 0 range 10 .. 10;
      OSSR           at 0 range 11 .. 11;
      BKE            at 0 range 12 .. 12;
      BKP            at 0 range 13 .. 13;
      AOE            at 0 range 14 .. 14;
      MOE            at 0 range 15 .. 15;
      BKF            at 0 range 16 .. 19;
      Reserved_20_25 at 0 range 20 .. 25;
      BKDSRM         at 0 range 26 .. 26;
      Reserved_27_27 at 0 range 27 .. 27;
      BKBID          at 0 range 28 .. 28;
      Reserved_29_31 at 0 range 29 .. 31;
   end record;

   subtype TIM16_DTR2_DTGF_Field is STM32G4_SVD.Byte;

   --  Deadtime asymmetric enable 	
   type TIM16_DTR2_DTAE_Field is
     (--  Deadtime on rising and falling edges are identical, and defined with
--  DTG[7:0] register
      B_0x0,
      --  Deadtime on rising edge is defined with DTG[7:0] register and deadtime on
--  falling edge is defined with DTGF[7:0] bits.
      B_0x1)
     with Size => 1;
   for TIM16_DTR2_DTAE_Field use
     (B_0x0 => 0,
      B_0x1 => 1);

   --  Deadtime preload enable 	
   type TIM16_DTR2_DTPE_Field is
     (--  Deadtime value is not preloaded
      B_0x0,
      --  Deadtime value preload is enabled
      B_0x1)
     with Size => 1;
   for TIM16_DTR2_DTPE_Field use
     (B_0x0 => 0,
      B_0x1 => 1);

   --  TIM16 timer deadtime register 2
   type TIM16_DTR2_Register is record
      --  Dead-time falling edge generator setup 	
      DTGF           : TIM16_DTR2_DTGF_Field := 16#0#;
      --  unspecified
      Reserved_8_15  : STM32G4_SVD.Byte := 16#0#;
      --  Deadtime asymmetric enable 	
      DTAE           : TIM16_DTR2_DTAE_Field := STM32G4_SVD.TIM.B_0x0;
      --  Deadtime preload enable 	
      DTPE           : TIM16_DTR2_DTPE_Field := STM32G4_SVD.TIM.B_0x0;
      --  unspecified
      Reserved_18_31 : STM32G4_SVD.UInt14 := 16#0#;
   end record
     with Volatile_Full_Access, Object_Size => 32,
          Bit_Order => System.Low_Order_First;

   for TIM16_DTR2_Register use record
      DTGF           at 0 range 0 .. 7;
      Reserved_8_15  at 0 range 8 .. 15;
      DTAE           at 0 range 16 .. 16;
      DTPE           at 0 range 17 .. 17;
      Reserved_18_31 at 0 range 18 .. 31;
   end record;

   --  selects tim_ti1_in[15:0] input 	
   type TIM16_TISEL_TI1SEL_Field is
     (--  TIMx_CH1 input (tim_ti1_in0)
      B_0x0,
      --  tim_ti1_in1
      B_0x1,
      --  tim_ti1_in15
      B_0xF)
     with Size => 4;
   for TIM16_TISEL_TI1SEL_Field use
     (B_0x0 => 0,
      B_0x1 => 1,
      B_0xF => 15);

   --  TIM16 input selection register
   type TIM16_TISEL_Register is record
      --  selects tim_ti1_in[15:0] input 	
      TI1SEL        : TIM16_TISEL_TI1SEL_Field := STM32G4_SVD.TIM.B_0x0;
      --  unspecified
      Reserved_4_31 : STM32G4_SVD.UInt28 := 16#0#;
   end record
     with Volatile_Full_Access, Object_Size => 32,
          Bit_Order => System.Low_Order_First;

   for TIM16_TISEL_Register use record
      TI1SEL        at 0 range 0 .. 3;
      Reserved_4_31 at 0 range 4 .. 31;
   end record;

   --  TIMx_BKIN input enable 	
   type TIM16_AF1_BKINE_Field is
     (--  TIMx_BKIN input disabled
      B_0x0,
      --  TIMx_BKIN input enabled
      B_0x1)
     with Size => 1;
   for TIM16_AF1_BKINE_Field use
     (B_0x0 => 0,
      B_0x1 => 1);

   --  tim_brk_cmp1 enable 	
   type TIM16_AF1_BKCMP1E_Field is
     (--  tim_brk_cmp1 input disabled
      B_0x0,
      --  tim_brk_cmp1 input enabled
      B_0x1)
     with Size => 1;
   for TIM16_AF1_BKCMP1E_Field use
     (B_0x0 => 0,
      B_0x1 => 1);

   --  tim_brk_cmp2 enable 	
   type TIM16_AF1_BKCMP2E_Field is
     (--  tim_brk_cmp2 input disabled
      B_0x0,
      --  tim_brk_cmp2 input enabled
      B_0x1)
     with Size => 1;
   for TIM16_AF1_BKCMP2E_Field use
     (B_0x0 => 0,
      B_0x1 => 1);

   --  tim_brk_cmp3 enable 	
   type TIM16_AF1_BKCMP3E_Field is
     (--  tim_brk_cmp3 input disabled
      B_0x0,
      --  tim_brk_cmp3 input enabled
      B_0x1)
     with Size => 1;
   for TIM16_AF1_BKCMP3E_Field use
     (B_0x0 => 0,
      B_0x1 => 1);

   --  tim_brk_cmp4 enable 	
   type TIM16_AF1_BKCMP4E_Field is
     (--  tim_brk_cmp4 input disabled
      B_0x0,
      --  tim_brk_cmp4 input enabled
      B_0x1)
     with Size => 1;
   for TIM16_AF1_BKCMP4E_Field use
     (B_0x0 => 0,
      B_0x1 => 1);

   --  tim_brk_cmp5 enable 	
   type TIM16_AF1_BKCMP5E_Field is
     (--  tim_brk_cmp5 input disabled
      B_0x0,
      --  tim_brk_cmp5 input enabled
      B_0x1)
     with Size => 1;
   for TIM16_AF1_BKCMP5E_Field use
     (B_0x0 => 0,
      B_0x1 => 1);

   --  tim_brk_cmp6 enable 	
   type TIM16_AF1_BKCMP6E_Field is
     (--  tim_brk_cmp6 input disabled
      B_0x0,
      --  tim_brk_cmp6 input enabled
      B_0x1)
     with Size => 1;
   for TIM16_AF1_BKCMP6E_Field use
     (B_0x0 => 0,
      B_0x1 => 1);

   --  tim_brk_cmp7 enable 	
   type TIM16_AF1_BKCMP7E_Field is
     (--  tim_brk_cmp7 input disabled
      B_0x0,
      --  tim_brk_cmp7 input enabled
      B_0x1)
     with Size => 1;
   for TIM16_AF1_BKCMP7E_Field use
     (B_0x0 => 0,
      B_0x1 => 1);

   --  tim_brk_cmp8 enable 	
   type TIM16_AF1_BKCMP8E_Field is
     (--  tim_brk_cmp8 input disabled
      B_0x0,
      --  tim_brk_cmp8 input enabled
      B_0x1)
     with Size => 1;
   for TIM16_AF1_BKCMP8E_Field use
     (B_0x0 => 0,
      B_0x1 => 1);

   --  TIMx_BKIN input polarity 	
   type TIM16_AF1_BKINP_Field is
     (--  TIMx_BKIN input is active high
      B_0x0,
      --  TIMx_BKIN input is active low
      B_0x1)
     with Size => 1;
   for TIM16_AF1_BKINP_Field use
     (B_0x0 => 0,
      B_0x1 => 1);

   --  tim_brk_cmp1 input polarity 	
   type TIM16_AF1_BKCMP1P_Field is
     (--  tim_brk_cmp1 input is active high
      B_0x0,
      --  tim_brk_cmp1 input is active low
      B_0x1)
     with Size => 1;
   for TIM16_AF1_BKCMP1P_Field use
     (B_0x0 => 0,
      B_0x1 => 1);

   --  tim_brk_cmp2 input polarity 	
   type TIM16_AF1_BKCMP2P_Field is
     (--  tim_brk_cmp2 input is active high
      B_0x0,
      --  tim_brk_cmp2 input is active low
      B_0x1)
     with Size => 1;
   for TIM16_AF1_BKCMP2P_Field use
     (B_0x0 => 0,
      B_0x1 => 1);

   --  tim_brk_cmp3 input polarity 	
   type TIM16_AF1_BKCMP3P_Field is
     (--  tim_brk_cmp3 input is active high
      B_0x0,
      --  tim_brk_cmp3 input is active low
      B_0x1)
     with Size => 1;
   for TIM16_AF1_BKCMP3P_Field use
     (B_0x0 => 0,
      B_0x1 => 1);

   --  tim_brk_cmp4 input polarity 	
   type TIM16_AF1_BKCMP4P_Field is
     (--  tim_brk_cmp4 input is active high
      B_0x0,
      --  tim_brk_cmp4 input is active low
      B_0x1)
     with Size => 1;
   for TIM16_AF1_BKCMP4P_Field use
     (B_0x0 => 0,
      B_0x1 => 1);

   --  TIM16 alternate function register 1
   type TIM16_AF1_Register is record
      --  TIMx_BKIN input enable 	
      BKINE          : TIM16_AF1_BKINE_Field := STM32G4_SVD.TIM.B_0x1;
      --  tim_brk_cmp1 enable 	
      BKCMP1E        : TIM16_AF1_BKCMP1E_Field := STM32G4_SVD.TIM.B_0x0;
      --  tim_brk_cmp2 enable 	
      BKCMP2E        : TIM16_AF1_BKCMP2E_Field := STM32G4_SVD.TIM.B_0x0;
      --  tim_brk_cmp3 enable 	
      BKCMP3E        : TIM16_AF1_BKCMP3E_Field := STM32G4_SVD.TIM.B_0x0;
      --  tim_brk_cmp4 enable 	
      BKCMP4E        : TIM16_AF1_BKCMP4E_Field := STM32G4_SVD.TIM.B_0x0;
      --  tim_brk_cmp5 enable 	
      BKCMP5E        : TIM16_AF1_BKCMP5E_Field := STM32G4_SVD.TIM.B_0x0;
      --  tim_brk_cmp6 enable 	
      BKCMP6E        : TIM16_AF1_BKCMP6E_Field := STM32G4_SVD.TIM.B_0x0;
      --  tim_brk_cmp7 enable 	
      BKCMP7E        : TIM16_AF1_BKCMP7E_Field := STM32G4_SVD.TIM.B_0x0;
      --  tim_brk_cmp8 enable 	
      BKCMP8E        : TIM16_AF1_BKCMP8E_Field := STM32G4_SVD.TIM.B_0x0;
      --  TIMx_BKIN input polarity 	
      BKINP          : TIM16_AF1_BKINP_Field := STM32G4_SVD.TIM.B_0x0;
      --  tim_brk_cmp1 input polarity 	
      BKCMP1P        : TIM16_AF1_BKCMP1P_Field := STM32G4_SVD.TIM.B_0x0;
      --  tim_brk_cmp2 input polarity 	
      BKCMP2P        : TIM16_AF1_BKCMP2P_Field := STM32G4_SVD.TIM.B_0x0;
      --  tim_brk_cmp3 input polarity 	
      BKCMP3P        : TIM16_AF1_BKCMP3P_Field := STM32G4_SVD.TIM.B_0x0;
      --  tim_brk_cmp4 input polarity 	
      BKCMP4P        : TIM16_AF1_BKCMP4P_Field := STM32G4_SVD.TIM.B_0x0;
      --  unspecified
      Reserved_14_31 : STM32G4_SVD.UInt18 := 16#0#;
   end record
     with Volatile_Full_Access, Object_Size => 32,
          Bit_Order => System.Low_Order_First;

   for TIM16_AF1_Register use record
      BKINE          at 0 range 0 .. 0;
      BKCMP1E        at 0 range 1 .. 1;
      BKCMP2E        at 0 range 2 .. 2;
      BKCMP3E        at 0 range 3 .. 3;
      BKCMP4E        at 0 range 4 .. 4;
      BKCMP5E        at 0 range 5 .. 5;
      BKCMP6E        at 0 range 6 .. 6;
      BKCMP7E        at 0 range 7 .. 7;
      BKCMP8E        at 0 range 8 .. 8;
      BKINP          at 0 range 9 .. 9;
      BKCMP1P        at 0 range 10 .. 10;
      BKCMP2P        at 0 range 11 .. 11;
      BKCMP3P        at 0 range 12 .. 12;
      BKCMP4P        at 0 range 13 .. 13;
      Reserved_14_31 at 0 range 14 .. 31;
   end record;

   --  tim_ocref_clr source selection 	
   type TIM16_AF2_OCRSEL_Field is
     (--  tim_ocref_clr0
      B_0x0,
      --  tim_ocref_clr1
      B_0x1,
      --  tim_ocref_clr2
      B_0x2,
      --  tim_ocref_clr3
      B_0x3,
      --  tim_ocref_clr4
      B_0x4,
      --  tim_ocref_clr5
      B_0x5,
      --  tim_ocref_clr6
      B_0x6,
      --  tim_ocref_clr7
      B_0x7)
     with Size => 3;
   for TIM16_AF2_OCRSEL_Field use
     (B_0x0 => 0,
      B_0x1 => 1,
      B_0x2 => 2,
      B_0x3 => 3,
      B_0x4 => 4,
      B_0x5 => 5,
      B_0x6 => 6,
      B_0x7 => 7);

   --  TIM16 alternate function register 2
   type TIM16_AF2_Register is record
      --  unspecified
      Reserved_0_15  : STM32G4_SVD.UInt16 := 16#0#;
      --  tim_ocref_clr source selection 	
      OCRSEL         : TIM16_AF2_OCRSEL_Field := STM32G4_SVD.TIM.B_0x0;
      --  unspecified
      Reserved_19_31 : STM32G4_SVD.UInt13 := 16#0#;
   end record
     with Volatile_Full_Access, Object_Size => 32,
          Bit_Order => System.Low_Order_First;

   for TIM16_AF2_Register use record
      Reserved_0_15  at 0 range 0 .. 15;
      OCRSEL         at 0 range 16 .. 18;
      Reserved_19_31 at 0 range 19 .. 31;
   end record;

   --  HSE Divided by 32 enable 	
   type TIM16_OR1_HSE32EN_Field is
     (--  HSE divided by 32 disabled
      B_0x0,
      --  HSE divided by 32 enabled
      B_0x1)
     with Size => 1;
   for TIM16_OR1_HSE32EN_Field use
     (B_0x0 => 0,
      B_0x1 => 1);

   --  TIM16 option register 1
   type TIM16_OR1_Register is record
      --  HSE Divided by 32 enable 	
      HSE32EN       : TIM16_OR1_HSE32EN_Field := STM32G4_SVD.TIM.B_0x0;
      --  unspecified
      Reserved_1_31 : STM32G4_SVD.UInt31 := 16#0#;
   end record
     with Volatile_Full_Access, Object_Size => 32,
          Bit_Order => System.Low_Order_First;

   for TIM16_OR1_Register use record
      HSE32EN       at 0 range 0 .. 0;
      Reserved_1_31 at 0 range 1 .. 31;
   end record;

   --  DMA base address 	
   type TIM16_DCR_DBA_Field is
     (--  TIMx_CR1,
      B_0x0,
      --  TIMx_CR2,
      B_0x1,
      --  TIMx_SMCR,
      B_0x2)
     with Size => 5;
   for TIM16_DCR_DBA_Field use
     (B_0x0 => 0,
      B_0x1 => 1,
      B_0x2 => 2);

   --  DMA burst length 	
   type TIM16_DCR_DBL_Field is
     (--  1 transfer,
      B_0x0,
      --  2 transfers,
      B_0x1,
      --  3 transfers,
      B_0x2,
      --  18 transfers.
      B_0x11)
     with Size => 5;
   for TIM16_DCR_DBL_Field use
     (B_0x0 => 0,
      B_0x1 => 1,
      B_0x2 => 2,
      B_0x11 => 17);

   --  TIM16 DMA control register
   type TIM16_DCR_Register is record
      --  DMA base address 	
      DBA            : TIM16_DCR_DBA_Field := STM32G4_SVD.TIM.B_0x0;
      --  unspecified
      Reserved_5_7   : STM32G4_SVD.UInt3 := 16#0#;
      --  DMA burst length 	
      DBL            : TIM16_DCR_DBL_Field := STM32G4_SVD.TIM.B_0x0;
      --  unspecified
      Reserved_13_31 : STM32G4_SVD.UInt19 := 16#0#;
   end record
     with Volatile_Full_Access, Object_Size => 32,
          Bit_Order => System.Low_Order_First;

   for TIM16_DCR_Register use record
      DBA            at 0 range 0 .. 4;
      Reserved_5_7   at 0 range 5 .. 7;
      DBL            at 0 range 8 .. 12;
      Reserved_13_31 at 0 range 13 .. 31;
   end record;

   -----------------
   -- Peripherals --
   -----------------

   type TIM1_Disc is
     (Default,
      Alternate);

   --  Advanced-timers
   type TIM1_Peripheral
     (Discriminent : TIM1_Disc := Default)
   is record
      --  TIM1 control register 1
      TIM1_CR1             : aliased TIM1_CR1_Register;
      --  TIM1 control register 2
      TIM1_CR2             : aliased TIM1_CR2_Register;
      --  TIM1 slave mode control register
      TIM1_SMCR            : aliased TIM1_SMCR_Register;
      --  TIM1 DMA/interrupt enable register
      TIM1_DIER            : aliased TIM1_DIER_Register;
      --  TIM1 status register
      TIM1_SR              : aliased TIM1_SR_Register;
      --  TIM1 event generation register
      TIM1_EGR             : aliased TIM1_EGR_Register;
      --  TIM1 capture/compare enable register
      TIM1_CCER            : aliased TIM1_CCER_Register;
      --  TIM1 counter
      TIM1_CNT             : aliased TIM1_CNT_Register;
      --  TIM1 prescaler
      TIM1_PSC             : aliased STM32G4_SVD.UInt16;
      --  TIM1 auto-reload register
      TIM1_ARR             : aliased TIM1_ARR_Register;
      --  TIM1 repetition counter register
      TIM1_RCR             : aliased STM32G4_SVD.UInt16;
      --  TIM1 capture/compare register 1
      TIM1_CCR1            : aliased TIM1_CCR1_Register;
      --  TIM1 capture/compare register 2
      TIM1_CCR2            : aliased TIM1_CCR2_Register;
      --  TIM1 capture/compare register 3
      TIM1_CCR3            : aliased TIM1_CCR3_Register;
      --  TIM1 capture/compare register 4
      TIM1_CCR4            : aliased TIM1_CCR4_Register;
      --  TIM1 break and dead-time register
      TIM1_BDTR            : aliased TIM1_BDTR_Register;
      --  TIM1 capture/compare register 5
      TIM1_CCR5            : aliased TIM1_CCR5_Register;
      --  TIM1 capture/compare register 6
      TIM1_CCR6            : aliased TIM1_CCR6_Register;
      --  TIM1 capture/compare mode register 3
      TIM1_CCMR3           : aliased TIM1_CCMR3_Register;
      --  TIM1 timer deadtime register 2
      TIM1_DTR2            : aliased TIM1_DTR2_Register;
      --  TIM1 timer encoder control register
      TIM1_ECR             : aliased TIM1_ECR_Register;
      --  TIM1 timer input selection register
      TIM1_TISEL           : aliased TIM1_TISEL_Register;
      --  TIM1 alternate function option register 1
      TIM1_AF1             : aliased TIM1_AF1_Register;
      --  TIM1 alternate function register 2
      TIM1_AF2             : aliased TIM1_AF2_Register;
      --  TIM1 DMA control register
      TIM1_DCR             : aliased TIM1_DCR_Register;
      --  TIM1 DMA address for full transfer
      TIM1_DMAR            : aliased STM32G4_SVD.UInt32;
      case Discriminent is
         when Default =>
            --  TIM1 capture/compare mode register 1 [alternate]
            TIM1_CCMR1 : aliased TIM1_CCMR1_Register;
            --  TIM1 capture/compare mode register 2 [alternate]
            TIM1_CCMR2 : aliased TIM1_CCMR2_Register;
         when Alternate =>
            --  TIM1 capture/compare mode register 1
            TIM1_CCMR1_Alternate : aliased TIM1_CCMR1_Alternate_Register;
            --  TIM1 capture/compare mode register 2
            TIM1_CCMR2_Alternate : aliased TIM1_CCMR2_Alternate_Register;
      end case;
   end record
     with Unchecked_Union, Volatile;

   for TIM1_Peripheral use record
      TIM1_CR1             at 16#0# range 0 .. 15;
      TIM1_CR2             at 16#4# range 0 .. 31;
      TIM1_SMCR            at 16#8# range 0 .. 31;
      TIM1_DIER            at 16#C# range 0 .. 31;
      TIM1_SR              at 16#10# range 0 .. 31;
      TIM1_EGR             at 16#14# range 0 .. 15;
      TIM1_CCER            at 16#20# range 0 .. 31;
      TIM1_CNT             at 16#24# range 0 .. 31;
      TIM1_PSC             at 16#28# range 0 .. 15;
      TIM1_ARR             at 16#2C# range 0 .. 31;
      TIM1_RCR             at 16#30# range 0 .. 15;
      TIM1_CCR1            at 16#34# range 0 .. 31;
      TIM1_CCR2            at 16#38# range 0 .. 31;
      TIM1_CCR3            at 16#3C# range 0 .. 31;
      TIM1_CCR4            at 16#40# range 0 .. 31;
      TIM1_BDTR            at 16#44# range 0 .. 31;
      TIM1_CCR5            at 16#48# range 0 .. 31;
      TIM1_CCR6            at 16#4C# range 0 .. 31;
      TIM1_CCMR3           at 16#50# range 0 .. 31;
      TIM1_DTR2            at 16#54# range 0 .. 31;
      TIM1_ECR             at 16#58# range 0 .. 31;
      TIM1_TISEL           at 16#5C# range 0 .. 31;
      TIM1_AF1             at 16#60# range 0 .. 31;
      TIM1_AF2             at 16#64# range 0 .. 31;
      TIM1_DCR             at 16#3DC# range 0 .. 31;
      TIM1_DMAR            at 16#3E0# range 0 .. 31;
      TIM1_CCMR1           at 16#18# range 0 .. 31;
      TIM1_CCMR2           at 16#1C# range 0 .. 31;
      TIM1_CCMR1_Alternate at 16#18# range 0 .. 31;
      TIM1_CCMR2_Alternate at 16#1C# range 0 .. 31;
   end record;

   --  Advanced-timers
   TIM1_Periph : aliased TIM1_Peripheral
     with Import, Address => TIM1_Base;

   --  Advanced-timers
   TIM8_Periph : aliased TIM1_Peripheral
     with Import, Address => TIM8_Base;

   --  Advanced-timers
   TIM20_Periph : aliased TIM1_Peripheral
     with Import, Address => TIM20_Base;

   type TIM2_Disc is
     (Default,
      Alternate);

   --  Advanced-timers
   type TIM2_Peripheral
     (Discriminent : TIM2_Disc := Default)
   is record
      --  TIM2 control register 1
      TIM2_CR1             : aliased TIM2_CR1_Register;
      --  TIM2 control register 2
      TIM2_CR2             : aliased TIM2_CR2_Register;
      --  TIM2 slave mode control register
      TIM2_SMCR            : aliased TIM2_SMCR_Register;
      --  TIM2 DMA/Interrupt enable register
      TIM2_DIER            : aliased TIM2_DIER_Register;
      --  TIM2 status register
      TIM2_SR              : aliased TIM2_SR_Register;
      --  TIM2 event generation register
      TIM2_EGR             : aliased TIM2_EGR_Register;
      --  TIM2 capture/compare enable register
      TIM2_CCER            : aliased TIM2_CCER_Register;
      --  TIM2 counter
      TIM2_CNT             : aliased TIM2_CNT_Register;
      --  TIM2 prescaler
      TIM2_PSC             : aliased STM32G4_SVD.UInt16;
      --  TIM2 auto-reload register
      TIM2_ARR             : aliased STM32G4_SVD.UInt32;
      --  TIM2 capture/compare register 1
      TIM2_CCR1            : aliased STM32G4_SVD.UInt32;
      --  TIM2 capture/compare register 2
      TIM2_CCR2            : aliased STM32G4_SVD.UInt32;
      --  TIM2 capture/compare register 3
      TIM2_CCR3            : aliased STM32G4_SVD.UInt32;
      --  TIM2 capture/compare register 4
      TIM2_CCR4            : aliased STM32G4_SVD.UInt32;
      --  TIM2 timer encoder control register
      TIM2_ECR             : aliased TIM2_ECR_Register;
      --  TIM2 timer input selection register
      TIM2_TISEL           : aliased TIM2_TISEL_Register;
      --  TIM2 alternate function register 1
      TIM2_AF1             : aliased TIM2_AF1_Register;
      --  TIM2 alternate function register 2
      TIM2_AF2             : aliased TIM2_AF2_Register;
      --  TIM2 DMA control register
      TIM2_DCR             : aliased TIM2_DCR_Register;
      --  TIM2 DMA address for full transfer
      TIM2_DMAR            : aliased STM32G4_SVD.UInt32;
      case Discriminent is
         when Default =>
            --  TIM2 capture/compare mode register 1 [alternate]
            TIM2_CCMR1 : aliased TIM2_CCMR1_Register;
            --  TIM2 capture/compare mode register 2 [alternate]
            TIM2_CCMR2 : aliased TIM2_CCMR2_Register;
         when Alternate =>
            --  TIM2 capture/compare mode register 1
            TIM2_CCMR1_Alternate : aliased TIM2_CCMR1_Alternate_Register;
            --  TIM2 capture/compare mode register 2
            TIM2_CCMR2_Alternate : aliased TIM2_CCMR2_Alternate_Register;
      end case;
   end record
     with Unchecked_Union, Volatile;

   for TIM2_Peripheral use record
      TIM2_CR1             at 16#0# range 0 .. 15;
      TIM2_CR2             at 16#4# range 0 .. 31;
      TIM2_SMCR            at 16#8# range 0 .. 31;
      TIM2_DIER            at 16#C# range 0 .. 31;
      TIM2_SR              at 16#10# range 0 .. 31;
      TIM2_EGR             at 16#14# range 0 .. 15;
      TIM2_CCER            at 16#20# range 0 .. 15;
      TIM2_CNT             at 16#24# range 0 .. 31;
      TIM2_PSC             at 16#28# range 0 .. 15;
      TIM2_ARR             at 16#2C# range 0 .. 31;
      TIM2_CCR1            at 16#34# range 0 .. 31;
      TIM2_CCR2            at 16#38# range 0 .. 31;
      TIM2_CCR3            at 16#3C# range 0 .. 31;
      TIM2_CCR4            at 16#40# range 0 .. 31;
      TIM2_ECR             at 16#58# range 0 .. 31;
      TIM2_TISEL           at 16#5C# range 0 .. 31;
      TIM2_AF1             at 16#60# range 0 .. 31;
      TIM2_AF2             at 16#64# range 0 .. 31;
      TIM2_DCR             at 16#3DC# range 0 .. 31;
      TIM2_DMAR            at 16#3E0# range 0 .. 31;
      TIM2_CCMR1           at 16#18# range 0 .. 31;
      TIM2_CCMR2           at 16#1C# range 0 .. 31;
      TIM2_CCMR1_Alternate at 16#18# range 0 .. 31;
      TIM2_CCMR2_Alternate at 16#1C# range 0 .. 31;
   end record;

   --  Advanced-timers
   TIM2_Periph : aliased TIM2_Peripheral
     with Import, Address => TIM2_Base;

   --  Advanced-timers
   TIM5_Periph : aliased TIM2_Peripheral
     with Import, Address => TIM5_Base;

   type TIM3_Disc is
     (Default,
      Alternate);

   --  Advanced-timers
   type TIM3_Peripheral
     (Discriminent : TIM3_Disc := Default)
   is record
      --  TIM3 control register 1
      TIM3_CR1             : aliased TIM3_CR1_Register;
      --  TIM3 control register 2
      TIM3_CR2             : aliased TIM3_CR2_Register;
      --  TIM3 slave mode control register
      TIM3_SMCR            : aliased TIM3_SMCR_Register;
      --  TIM3 DMA/Interrupt enable register
      TIM3_DIER            : aliased TIM3_DIER_Register;
      --  TIM3 status register
      TIM3_SR              : aliased TIM3_SR_Register;
      --  TIM3 event generation register
      TIM3_EGR             : aliased TIM3_EGR_Register;
      --  TIM3 capture/compare enable register
      TIM3_CCER            : aliased TIM3_CCER_Register;
      --  TIM3 counter
      TIM3_CNT             : aliased TIM3_CNT_Register;
      --  TIM3 prescaler
      TIM3_PSC             : aliased STM32G4_SVD.UInt16;
      --  TIM3 auto-reload register
      TIM3_ARR             : aliased TIM3_ARR_Register;
      --  TIM3 capture/compare register 1
      TIM3_CCR1            : aliased TIM3_CCR1_Register;
      --  TIM3 capture/compare register 2
      TIM3_CCR2            : aliased TIM3_CCR2_Register;
      --  TIM3 capture/compare register 3
      TIM3_CCR3            : aliased TIM3_CCR3_Register;
      --  TIM3 capture/compare register 4
      TIM3_CCR4            : aliased TIM3_CCR4_Register;
      --  TIM3 timer encoder control register
      TIM3_ECR             : aliased TIM3_ECR_Register;
      --  TIM3 timer input selection register
      TIM3_TISEL           : aliased TIM3_TISEL_Register;
      --  TIM3 alternate function register 1
      TIM3_AF1             : aliased TIM3_AF1_Register;
      --  TIM3 alternate function register 2
      TIM3_AF2             : aliased TIM3_AF2_Register;
      --  TIM3 DMA control register
      TIM3_DCR             : aliased TIM3_DCR_Register;
      --  TIM3 DMA address for full transfer
      TIM3_DMAR            : aliased STM32G4_SVD.UInt32;
      case Discriminent is
         when Default =>
            --  TIM3 capture/compare mode register 1 [alternate]
            TIM3_CCMR1 : aliased TIM3_CCMR1_Register;
            --  TIM3 capture/compare mode register 2 [alternate]
            TIM3_CCMR2 : aliased TIM3_CCMR2_Register;
         when Alternate =>
            --  TIM3 capture/compare mode register 1
            TIM3_CCMR1_Alternate : aliased TIM3_CCMR1_Alternate_Register;
            --  TIM3 capture/compare mode register 2
            TIM3_CCMR2_Alternate : aliased TIM3_CCMR2_Alternate_Register;
      end case;
   end record
     with Unchecked_Union, Volatile;

   for TIM3_Peripheral use record
      TIM3_CR1             at 16#0# range 0 .. 15;
      TIM3_CR2             at 16#4# range 0 .. 31;
      TIM3_SMCR            at 16#8# range 0 .. 31;
      TIM3_DIER            at 16#C# range 0 .. 31;
      TIM3_SR              at 16#10# range 0 .. 31;
      TIM3_EGR             at 16#14# range 0 .. 15;
      TIM3_CCER            at 16#20# range 0 .. 15;
      TIM3_CNT             at 16#24# range 0 .. 31;
      TIM3_PSC             at 16#28# range 0 .. 15;
      TIM3_ARR             at 16#2C# range 0 .. 31;
      TIM3_CCR1            at 16#34# range 0 .. 31;
      TIM3_CCR2            at 16#38# range 0 .. 31;
      TIM3_CCR3            at 16#3C# range 0 .. 31;
      TIM3_CCR4            at 16#40# range 0 .. 31;
      TIM3_ECR             at 16#58# range 0 .. 31;
      TIM3_TISEL           at 16#5C# range 0 .. 31;
      TIM3_AF1             at 16#60# range 0 .. 31;
      TIM3_AF2             at 16#64# range 0 .. 31;
      TIM3_DCR             at 16#3DC# range 0 .. 31;
      TIM3_DMAR            at 16#3E0# range 0 .. 31;
      TIM3_CCMR1           at 16#18# range 0 .. 31;
      TIM3_CCMR2           at 16#1C# range 0 .. 31;
      TIM3_CCMR1_Alternate at 16#18# range 0 .. 31;
      TIM3_CCMR2_Alternate at 16#1C# range 0 .. 31;
   end record;

   --  Advanced-timers
   TIM3_Periph : aliased TIM3_Peripheral
     with Import, Address => TIM3_Base;

   --  Advanced-timers
   TIM4_Periph : aliased TIM3_Peripheral
     with Import, Address => TIM4_Base;

   --  Basic-timers
   type TIM6_Peripheral is record
      --  TIM6 control register 1
      TIM6_CR1  : aliased TIM6_CR1_Register;
      --  TIM6 control register 2
      TIM6_CR2  : aliased TIM6_CR2_Register;
      --  TIM6 DMA/Interrupt enable register
      TIM6_DIER : aliased TIM6_DIER_Register;
      --  TIM6 status register
      TIM6_SR   : aliased TIM6_SR_Register;
      --  TIM6 event generation register
      TIM6_EGR  : aliased TIM6_EGR_Register;
      --  TIM6 counter
      TIM6_CNT  : aliased TIM6_CNT_Register;
      --  TIM6 prescaler
      TIM6_PSC  : aliased STM32G4_SVD.UInt16;
      --  TIM6 auto-reload register
      TIM6_ARR  : aliased TIM6_ARR_Register;
   end record
     with Volatile;

   for TIM6_Peripheral use record
      TIM6_CR1  at 16#0# range 0 .. 15;
      TIM6_CR2  at 16#4# range 0 .. 15;
      TIM6_DIER at 16#C# range 0 .. 15;
      TIM6_SR   at 16#10# range 0 .. 15;
      TIM6_EGR  at 16#14# range 0 .. 15;
      TIM6_CNT  at 16#24# range 0 .. 31;
      TIM6_PSC  at 16#28# range 0 .. 15;
      TIM6_ARR  at 16#2C# range 0 .. 31;
   end record;

   --  Basic-timers
   TIM6_Periph : aliased TIM6_Peripheral
     with Import, Address => TIM6_Base;

   --  Basic-timers
   TIM7_Periph : aliased TIM6_Peripheral
     with Import, Address => TIM7_Base;

   type TIM15_Disc is
     (Output,
      Input);

   --  General purpose timers
   type TIM15_Peripheral
     (Discriminent : TIM15_Disc := Output)
   is record
      --  control register 1
      CR1          : aliased CR1_Register;
      --  control register 2
      CR2          : aliased CR2_Register;
      --  slave mode control register
      SMCR         : aliased SMCR_Register;
      --  DMA/Interrupt enable register
      DIER         : aliased DIER_Register;
      --  status register
      SR           : aliased SR_Register;
      --  event generation register
      EGR          : aliased EGR_Register;
      --  capture/compare enable register
      CCER         : aliased CCER_Register;
      --  counter
      CNT          : aliased CNT_Register;
      --  prescaler
      PSC          : aliased PSC_Register;
      --  auto-reload register
      ARR          : aliased ARR_Register;
      --  repetition counter register
      RCR          : aliased RCR_Register;
      --  capture/compare register 1
      CCR1         : aliased CCR1_Register;
      --  capture/compare register 2
      CCR2         : aliased CCR2_Register;
      --  break and dead-time register
      BDTR         : aliased BDTR_Register;
      --  timer Deadtime Register 2
      DTR2         : aliased DTR2_Register;
      --  TIM timer input selection register
      TISEL        : aliased TISEL_Register;
      --  TIM alternate function option register 1
      AF1          : aliased AF1_Register;
      --  TIM alternate function option register 2
      AF2          : aliased AF2_Register;
      --  DMA control register
      DCR          : aliased DCR_Register;
      --  DMA address for full transfer
      DMAR         : aliased STM32G4_SVD.UInt32;
      case Discriminent is
         when Output =>
            --  capture/compare mode register (output mode)
            CCMR1_Output : aliased CCMR1_Output_Register;
         when Input =>
            --  capture/compare mode register 1 (input mode)
            CCMR1_Input : aliased CCMR1_Input_Register;
      end case;
   end record
     with Unchecked_Union, Volatile;

   for TIM15_Peripheral use record
      CR1          at 16#0# range 0 .. 31;
      CR2          at 16#4# range 0 .. 31;
      SMCR         at 16#8# range 0 .. 31;
      DIER         at 16#C# range 0 .. 31;
      SR           at 16#10# range 0 .. 31;
      EGR          at 16#14# range 0 .. 31;
      CCER         at 16#20# range 0 .. 31;
      CNT          at 16#24# range 0 .. 31;
      PSC          at 16#28# range 0 .. 31;
      ARR          at 16#2C# range 0 .. 31;
      RCR          at 16#30# range 0 .. 31;
      CCR1         at 16#34# range 0 .. 31;
      CCR2         at 16#38# range 0 .. 31;
      BDTR         at 16#44# range 0 .. 31;
      DTR2         at 16#54# range 0 .. 31;
      TISEL        at 16#5C# range 0 .. 31;
      AF1          at 16#60# range 0 .. 31;
      AF2          at 16#64# range 0 .. 31;
      DCR          at 16#3DC# range 0 .. 31;
      DMAR         at 16#3E0# range 0 .. 31;
      CCMR1_Output at 16#18# range 0 .. 31;
      CCMR1_Input  at 16#18# range 0 .. 31;
   end record;

   --  General purpose timers
   TIM15_Periph : aliased TIM15_Peripheral
     with Import, Address => TIM15_Base;

   type TIM16_Disc is
     (Default,
      Alternate);

   --  General purpose timers
   type TIM16_Peripheral
     (Discriminent : TIM16_Disc := Default)
   is record
      --  TIM16 control register 1
      TIM16_CR1             : aliased TIM16_CR1_Register;
      --  TIM16 control register 2
      TIM16_CR2             : aliased TIM16_CR2_Register;
      --  TIM16 DMA/interrupt enable register
      TIM16_DIER            : aliased TIM16_DIER_Register;
      --  TIM16 status register
      TIM16_SR              : aliased TIM16_SR_Register;
      --  TIM16 event generation register
      TIM16_EGR             : aliased TIM16_EGR_Register;
      --  TIM16 capture/compare enable register
      TIM16_CCER            : aliased TIM16_CCER_Register;
      --  TIM16 counter
      TIM16_CNT             : aliased TIM16_CNT_Register;
      --  TIM16 prescaler
      TIM16_PSC             : aliased STM32G4_SVD.UInt16;
      --  TIM16 auto-reload register
      TIM16_ARR             : aliased TIM16_ARR_Register;
      --  TIM16 repetition counter register
      TIM16_RCR             : aliased TIM16_RCR_Register;
      --  TIM16 capture/compare register 1
      TIM16_CCR1            : aliased TIM16_CCR1_Register;
      --  TIM16 break and dead-time register
      TIM16_BDTR            : aliased TIM16_BDTR_Register;
      --  TIM16 timer deadtime register 2
      TIM16_DTR2            : aliased TIM16_DTR2_Register;
      --  TIM16 input selection register
      TIM16_TISEL           : aliased TIM16_TISEL_Register;
      --  TIM16 alternate function register 1
      TIM16_AF1             : aliased TIM16_AF1_Register;
      --  TIM16 alternate function register 2
      TIM16_AF2             : aliased TIM16_AF2_Register;
      --  TIM16 option register 1
      TIM16_OR1             : aliased TIM16_OR1_Register;
      --  TIM16 DMA control register
      TIM16_DCR             : aliased TIM16_DCR_Register;
      --  TIM16/TIM17 DMA address for full transfer
      TIM16_DMAR            : aliased STM32G4_SVD.UInt32;
      case Discriminent is
         when Default =>
            --  TIM16 capture/compare mode register 1
            TIM16_CCMR1 : aliased TIM16_CCMR1_Register;
         when Alternate =>
            --  TIM16 capture/compare mode register 1
            TIM16_CCMR1_Alternate : aliased TIM16_CCMR1_Alternate_Register;
      end case;
   end record
     with Unchecked_Union, Volatile;

   for TIM16_Peripheral use record
      TIM16_CR1             at 16#0# range 0 .. 15;
      TIM16_CR2             at 16#4# range 0 .. 15;
      TIM16_DIER            at 16#C# range 0 .. 15;
      TIM16_SR              at 16#10# range 0 .. 15;
      TIM16_EGR             at 16#14# range 0 .. 15;
      TIM16_CCER            at 16#20# range 0 .. 15;
      TIM16_CNT             at 16#24# range 0 .. 31;
      TIM16_PSC             at 16#28# range 0 .. 15;
      TIM16_ARR             at 16#2C# range 0 .. 31;
      TIM16_RCR             at 16#30# range 0 .. 15;
      TIM16_CCR1            at 16#34# range 0 .. 31;
      TIM16_BDTR            at 16#44# range 0 .. 31;
      TIM16_DTR2            at 16#54# range 0 .. 31;
      TIM16_TISEL           at 16#5C# range 0 .. 31;
      TIM16_AF1             at 16#60# range 0 .. 31;
      TIM16_AF2             at 16#64# range 0 .. 31;
      TIM16_OR1             at 16#68# range 0 .. 31;
      TIM16_DCR             at 16#3DC# range 0 .. 31;
      TIM16_DMAR            at 16#3E0# range 0 .. 31;
      TIM16_CCMR1           at 16#18# range 0 .. 31;
      TIM16_CCMR1_Alternate at 16#18# range 0 .. 31;
   end record;

   --  General purpose timers
   TIM16_Periph : aliased TIM16_Peripheral
     with Import, Address => TIM16_Base;

   --  General purpose timers
   TIM17_Periph : aliased TIM16_Peripheral
     with Import, Address => TIM17_Base;

end STM32G4_SVD.TIM;
