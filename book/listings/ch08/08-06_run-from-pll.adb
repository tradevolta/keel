procedure Run_From_PLL (Setting : PLL_Config; Stat : out Status) is
   Locked : Boolean := False;
begin
   --  1. Off the PLL before touching it
   Run_From_Crystal;

   --  2. Reset pll_sys, as the SDK's pll_init does
   Reset_Bits.Set
     (RESETS_Periph.RESET,
      (Reset_Bits.No_Bits with delta PLL_SYS => True));
   Reset_Bits.Clear
     (RESETS_Periph.RESET,
      (Reset_Bits.No_Bits with delta PLL_SYS => True));
   loop
      exit when RESETS_Periph.RESET_DONE.PLL_SYS;
   end loop;

   --  3. Dividers, then power and VCO on, then wait for LOCK
   PLL_SYS_Periph.CS :=
     (REFDIV => CS_REFDIV_Field (Ref_Div (Setting)), others => <>);
   PLL_SYS_Periph.FBDIV_INT :=
     (FBDIV_INT => FBDIV_INT_FBDIV_INT_Field (Feedback (Setting)),
      others => <>);
   PLL_SYS_Periph.PWR :=
     (PD => False, VCOPD => False, others => <>);
   for Try in 1 .. Patience loop
      Locked := PLL_SYS_Periph.CS.LOCK;
      exit when Locked;
   end loop;
   if not Locked then
      Stat := Timeout;
      return;
   end if;

   --  4. Post dividers, then their power: no dirty clock comes out
   PLL_SYS_Periph.PRIM :=
     (POSTDIV1 => PRIM_POSTDIV1_Field (Post_1 (Setting)),
      POSTDIV2 => PRIM_POSTDIV2_Field (Post_2 (Setting)),
      others => <>);
   PLL_SYS_Periph.PWR :=
     (PD => False, VCOPD => False, POSTDIVPD => False,
      others => <>);

   --  5. The auxiliary mux is not glitchless: change it only while
   --  the glitchless mux selects clk_ref, then switch
   CLOCKS_Periph.CLK_SYS_CTRL.AUXSRC := clksrc_pll_sys;
   CLOCKS_Periph.CLK_SYS_DIV := (INT => 1, FRAC => 0);
   CLOCKS_Periph.CLK_SYS_CTRL.SRC := clksrc_clk_sys_aux;
   loop
      exit when CLOCKS_Periph.CLK_SYS_SELECTED.CLK_SYS_SELECTED
                  = Sys_Is_Aux;
   end loop;
   Sys := Output (Setting);
   Stat := Ok;
end Run_From_PLL;
