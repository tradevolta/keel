--  clk_adc: 48 MHz from pll_usb, solved like pll_sys
Keel.Clock.Solve (PLL_SYS, Crystal, 48_000_000, False, PLL,
                  Found);
Check ((if Found then Keel.Ok else Keel.Not_Supported),
       "pll_usb setting");
Start_ADC_Clock (PLL, Stat);
Check (Stat, "clk_adc");
Enable (Stat);
Check (Stat, "ADC");
Claim (VSYS_Enable, On, Stat);
Check (Stat, "GPIO25");
for Ch in Channel loop
   Claim (Ch, Stat);
   Check (Stat, "ADC input" & Ch'Image);
end loop;

Solve (Slice_Limits, Hertz (Sys_Frequency), "150 kHz",
       Trailing_Edge, DAC_Setting, Stat);
Check (Stat, "DAC setting");
Claim (DAC_Pin, DAC_Setting, Stat);
Check (Stat, "GP16");
