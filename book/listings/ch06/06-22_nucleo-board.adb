procedure Initialize is
begin
   RCC_Periph.RCC_AHB2ENR.GPIOAEN := B_0x1;
   RCC_Periph.RCC_APB1ENR1.TIM2EN := B_0x1;

   for L in Lamp loop
      Set_Mode (GPIOA_Periph, Pin_Of (L), Output);
   end loop;

   --  The prescaler divides by PSC + 1. It is buffered: the update
   --  event (UG) loads it.
   TIM2_Periph.TIM2_PSC := UInt16 (Timer_Clock / Tick_Rate) - 1;
   TIM2_Periph.TIM2_EGR := (UG => B_0x1, others => <>);
   TIM2_Periph.TIM2_CR1.CEN := B_0x1;
end Initialize;

procedure Show (Lamps : Lamp_Set) is
   On, Off : BSRR_BS_Field_Array := [others => False];
begin
   for L in Lamp loop
      On (Integer (Pin_Of (L))) := Lamps (L);
      Off (Integer (Pin_Of (L))) := not Lamps (L);
   end loop;
   --  BSRR sets and clears pins in one write, like the RP2350's
   --  SIO SET and CLR registers.
   GPIOA_Periph.BSRR :=
     (BS => (As_Array => True, Arr => On),
      BR => (As_Array => True, Arr => BSRR_BR_Field_Array (Off)));
end Show;
