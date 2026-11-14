procedure Run_From_PLL (Setting : PLL_Config; Stat : out Status) is
   Target : constant Frequency := Output (Setting);
   Locked : Boolean := False;
begin
   --  1. Off the PLL, then stop it
   Run_From_HSI16;
   RCC_Periph.RCC_CR.PLLON := B_0x0;
   loop
      exit when RCC_Periph.RCC_CR.PLLRDY = B_0x0;
   end loop;

   --  2. Up: wait states first (RM0440, 3.3.3)
   Set_Wait_States (Wait_States_For (Target));

   --  3. M, N and R; R counts in twos (Post_Scale = 2)
   RCC_PLLCFGR :=
     (PLLSRC => Fields.HSI16,
      PLLM   => M_Code (Ref_Div (Setting) - 1),
      PLLN   => N_Code (Feedback (Setting)),
      PLLREN => True,
      PLLR   => R_Code (Post_1 (Setting) - 1));
   RCC_Periph.RCC_CR.PLLON := B_0x1;
   for Try in 1 .. Patience loop
      Locked := RCC_Periph.RCC_CR.PLLRDY = B_0x1;
      exit when Locked;
   end loop;
   if not Locked then
      Stat := Timeout;
      return;
   end if;

   --  4. AN5093's sequence: HCLK = SYSCLK / 2, the voltage mode,
   --  the switch, at least 1 us, then HCLK = SYSCLK
   RCC_CFGR := (RCC_CFGR with delta HPRE => Div_2);
   PWR_Periph.PWR_CR5.R1MODE :=
     (if Needs_Boost (Target) then B_0x0 else B_0x1);
   Switch_To (Fields.PLL);
   --  200 cycles of HCLK, at most 85 MHz here: over 2 us
   for I in 1 .. 200 loop
      Keel.Cortex_M.NOP;
   end loop;
   RCC_CFGR := (RCC_CFGR with delta HPRE => Div_1);
   Sys := Target;
   Stat := Ok;
end Run_From_PLL;
