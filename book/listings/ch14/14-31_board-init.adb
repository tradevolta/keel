procedure Initialize is
   Stat  : Keel.Status;
   Found : Boolean;
begin
   Keel.Trace.Initialize;
   Start_Crystal (Stat);
   Check (Stat, "crystal");
   Keel.Time.Bare.Start (Crystal);

   --  The calendar runs on through everything but a power-on
   if not AON.Running then
      AON.Start (Join (First_Time));
   end if;
   AON.Use_Crystal;
   Power.Initialize;

   Keel.GPIO.RP2350.Enable;
   Claim (Button, (Bias => Pull_Up), Stat);
   Check (Stat, "button on GP16");
   Watch (Button, (Falling => True, Rising => False));
   Power.Set_Wake_Pin (Button.Id);
   Power.Ignore_Debugger;

   Keel.Clock.Solve (PLL_SYS, Crystal, 48_000_000, False, ADC_PLL,
                     Found);
   Check ((if Found then Keel.Ok else Keel.Not_Supported),
          "pll_usb setting");
   Power.Set_Policy
     ((Deepest => Mode'Val (Deepest_Kind'Pos (Deepest)),
       Wake    => Power.Default_Costs));
end Initialize;
