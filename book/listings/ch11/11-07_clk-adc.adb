--  clk_adc has no glitchless mux: pick the source while it is
--  stopped, then enable it
CLOCKS_Periph.CLK_ADC_CTRL := (AUXSRC => clksrc_pll_usb,
                               others => <>);
CLOCKS_Periph.CLK_ADC_CTRL := (AUXSRC => clksrc_pll_usb,
                               ENABLE => True, others => <>);
