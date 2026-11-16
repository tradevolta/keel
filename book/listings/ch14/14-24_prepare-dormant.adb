procedure Prepare_Dormant is
begin
   --  clk_sys moves to ROSC through the aux mux: pick the aux
   --  source while clk_sys runs from clk_ref, then switch
   ROSC.ROSC_Periph.CTRL.ENABLE := ROSC.ENABLE;
   Wait_ROSC_Stable;
   CLOCKS_Periph.CLK_SYS_CTRL.AUXSRC := rosc_clksrc;
   CLOCKS_Periph.CLK_SYS_CTRL.SRC := clksrc_clk_sys_aux;
   loop
      exit when CLOCKS_Periph.CLK_SYS_SELECTED.CLK_SYS_SELECTED
                  = Sys_Is_Aux;
   end loop;
   CLOCKS_Periph.CLK_REF_CTRL := (SRC => lposc_clksrc, others => <>);
   loop
      exit when CLOCKS_Periph.CLK_REF_SELECTED.CLK_REF_SELECTED
                  = Ref_Is_LPOSC;
   end loop;

   --  clk_peri from clk_sys; its mux glitches, so stop it first
   CLOCKS_Periph.CLK_PERI_CTRL := (others => <>);
   CLOCKS_Periph.CLK_PERI_CTRL := (AUXSRC => clk_sys, ENABLE => True,
                                   others => <>);
   CLOCKS_Periph.CLK_USB_CTRL := (others => <>);
   CLOCKS_Periph.CLK_HSTX_CTRL := (others => <>);
   Stop_ADC_Clock;
   PLL_SYS_Periph.PWR := (others => <>);

   XOSC_Periph.CTRL.ENABLE := DISABLE;
   for Try in 1 .. Patience loop
      exit when not XOSC_Periph.STATUS.STABLE;
   end loop;
   Running := False;
   Sys := 0;
end Prepare_Dormant;
