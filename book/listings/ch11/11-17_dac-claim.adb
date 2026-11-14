--  MCR.HFSEL: 1 for an AHB clock above 80 MHz
Above_80_MHz : constant DAC_MCR_HFSEL_Field := 1;

--  MCR.MODE1 = 2#001#: normal mode, buffer on, to the pin and to
--  the chip's comparators and op-amps as well (ST's LL driver,
--  stm32g4xx_ll_dac.h, LL_DAC_SetOutputConnection)
Pin_And_Inside : constant DAC_MCR_MODE1_Field := 2#001#;

procedure Claim (O : in out Output; Stat : out Status) is
begin
   Keel.GPIO.STM32G4.Reserve_Analog (Keel.GPIO.STM32G4.A, 4, Stat);
   if Stat /= Ok then
      return;
   end if;
   RCC_Periph.RCC_AHB2ENR.DAC1EN := B_0x1;
   --  MCR is written only while the channel is off
   DAC1_Periph.DAC_MCR :=
     (MODE1 => Pin_And_Inside, HFSEL => Above_80_MHz,
      others => <>);
   DAC1_Periph.DAC_DHR12R1 := (DACC1DHR => 0, others => <>);
   DAC1_Periph.DAC_CR := (EN1 => True, others => <>);
   O.Claimed := True;
end Claim;
