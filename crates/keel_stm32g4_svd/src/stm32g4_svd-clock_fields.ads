--  SPDX-License-Identifier: Apache-2.0
--  Hand-written (not generated): RCC_CFGR and RCC_PLLCFGR with
--  number fields. The STM32G474 SVD gives PLLM and PLLN enumerated
--  values for a few settings only (PLLN: 0, 1, 7, 8, 9, 127 ...), so
--  svd2ada's types cannot hold most of the dividers. RM0440 Rev 9,
--  7.4.3 and 7.4.4, gives the layouts used here.
with System;

package STM32G4_SVD.Clock_Fields
  with Preelaborate
is
   --  SW and SWS: the SYSCLK source
   type Sys_Source is (Reserved, HSI16, HSE, PLL) with Size => 2;
   for Sys_Source use (Reserved => 0, HSI16 => 1, HSE => 2, PLL => 3);

   --  HPRE: SYSCLK to HCLK. 0xxx is /1; 1000 is /2.
   type AHB_Divider is (Div_1, Div_2) with Size => 4;
   for AHB_Divider use (Div_1 => 2#0000#, Div_2 => 2#1000#);

   --  MCOSEL and MCOPRE: what the MCO pin shows, and its divider
   type MCO_Source is (Off, SYSCLK, Reserved, HSI16, HSE, PLL, LSI,
                       LSE, HSI48)
     with Size => 4;
   for MCO_Source use
     (Off => 0, SYSCLK => 1, Reserved => 2, HSI16 => 3, HSE => 4,
      PLL => 5, LSI => 6, LSE => 7, HSI48 => 8);
   type MCO_Divider is (Div_1, Div_2, Div_4, Div_8, Div_16)
     with Size => 3;
   for MCO_Divider use
     (Div_1 => 0, Div_2 => 1, Div_4 => 2, Div_8 => 3, Div_16 => 4);

   type CFGR_Register is record
      SW     : Sys_Source  := HSI16;
      SWS    : Sys_Source  := HSI16;
      HPRE   : AHB_Divider := Div_1;
      PPRE   : UInt6       := 0;
      MCOSEL : MCO_Source  := Off;
      MCOPRE : MCO_Divider := Div_1;
   end record
     with Volatile_Full_Access, Object_Size => 32,
          Bit_Order => System.Low_Order_First;

   for CFGR_Register use record
      SW     at 0 range 0 .. 1;
      SWS    at 0 range 2 .. 3;
      HPRE   at 0 range 4 .. 7;
      PPRE   at 0 range 8 .. 13;
      MCOSEL at 0 range 24 .. 27;
      MCOPRE at 0 range 28 .. 30;
   end record;

   --  PLLSRC: the PLL's input
   type PLL_Source is (None, Reserved, HSI16, HSE) with Size => 2;
   for PLL_Source use (None => 0, Reserved => 1, HSI16 => 2, HSE => 3);

   --  PLLM holds M - 1; PLLN holds N; PLLR holds R / 2 - 1
   type M_Code is range 0 .. 15 with Size => 4;
   type N_Code is range 0 .. 127 with Size => 7;
   type R_Code is range 0 .. 3 with Size => 2;

   type PLLCFGR_Register is record
      PLLSRC : PLL_Source := None;
      PLLM   : M_Code     := 0;
      PLLN   : N_Code     := 8;
      PLLREN : Boolean    := False;
      PLLR   : R_Code     := 0;
   end record
     with Volatile_Full_Access, Object_Size => 32,
          Bit_Order => System.Low_Order_First;

   for PLLCFGR_Register use record
      PLLSRC at 0 range 0 .. 1;
      PLLM   at 0 range 4 .. 7;
      PLLN   at 0 range 8 .. 14;
      PLLREN at 0 range 24 .. 24;
      PLLR   at 0 range 25 .. 26;
   end record;

   --  The two registers, at their offsets in RCC
   RCC_CFGR : CFGR_Register
     with Import,
          Address => System'To_Address (16#4002_1008#);
   RCC_PLLCFGR : PLLCFGR_Register
     with Import,
          Address => System'To_Address (16#4002_100C#);
end STM32G4_SVD.Clock_Fields;
