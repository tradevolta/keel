--  The build's UART_Mode, as a Keel.Bus.UART.Mode
How : constant Keel.Bus.UART.Mode :=
  Keel.Bus.UART.Mode'Val (UART_Mode_Kind'Pos (UART_Mode));

procedure Initialize is
   Stat    : Status;
   PLL     : Keel.Clock.PLL_Config;
   Found   : Boolean;
   Dimming : Setting;
begin
   Start_Crystal (Stat);
   Check (Stat);
   Keel.Clock.Solve (PLL_SYS, Crystal, Target, False, PLL, Found);
   if Found and then Target / Flash_Divisor <= Flash_Max then
      Run_From_PLL (PLL, Stat);
      Check (Stat);
   end if;
   Keel.Time.Bare.Start (Crystal);
   Started := Keel.Time.Bare.Clock;
   Keel.GPIO.RP2350.Enable;
   Keel.PWM.RP2350.Enable;
   Keel.DMA.RP2350.Enable;

   --  The console first, so that it can report the rest
   Open (Port, TX => 0, RX => 1, Baud => Baud, Stat => Stat,
         How => How);
   Check (Stat);

   Claim (LED, (Initial => Low, others => <>), Stat);
   Check (Stat);
   Claim (Button, (Bias => Pull_Up), Stat);
   Check (Stat);
   Solve (PWM.Slice_Limits, Hertz (Sys_Frequency), "1 kHz",
          Trailing_Edge, Dimming, Stat);
   Check (Stat);
   PWM.Claim (Dimmer, Dimming, Stat);
   Check (Stat);
