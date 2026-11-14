--  RP2350 datasheet, 8.6.3: PFD at least 5 MHz and at most
--  VCO / 16, VCO 750 to 1600 MHz, REFDIV 1 to 63, FBDIV 16 to
--  320, POSTDIV1 and POSTDIV2 1 to 7; pll_sys rated to 150 MHz.
RP2350_PLL_SYS : constant PLL_Limits :=
  (PFD_Min => 5_000_000,
   PFD_Max => 100_000_000,
   VCO_Min => 750_000_000,
   VCO_Max => 1_600_000_000,
   Rated_Max => 150_000_000,
   Ref_Div_Max => 63,
   Feedback_Min => 16,
   Feedback_Max => 320,
   Post_1_Max => 7,
   Post_2_Max => 7,
   Post_Scale => 1);

--  STM32G474 datasheet DS12288, 5.3.9: PLL input 2.66 to 16 MHz
--  and VCO 96 to 344 MHz in voltage range 1; RM0440, 7.4.4: PLLM
--  1 to 16, PLLN 8 to 127, PLLR 2, 4, 6 or 8. R is 2 * Post_1.
--  PLLR output rated to 170 MHz in range 1 boost mode.
STM32G474_PLL : constant PLL_Limits :=
  (PFD_Min => 2_660_000,
   PFD_Max => 16_000_000,
   VCO_Min => 96_000_000,
   VCO_Max => 344_000_000,
   Rated_Max => 170_000_000,
   Ref_Div_Max => 16,
   Feedback_Min => 8,
   Feedback_Max => 127,
   Post_1_Max => 4,
   Post_2_Max => 1,
   Post_Scale => 2);
