--  Set the port up for D: the controller off while CR0 and CPSR
--  change, as the PL022 asks, then on again
procedure Configure (D : Device) is
   R : SPI0_Peripheral renames Regs (D.Port).all;
begin
   R.SSPCR1 := (SSE => False, others => <>);
   R.SSPCR0 :=
     (DSS => Eight_Bits,
      FRF => 0,
      SPO => Idles_High (D.Want.Mode),
      SPH => Samples_Second_Edge (D.Want.Mode),
      SCR => SSPCR0_SCR_Field (D.Divider.Serial_Rate),
      others => <>);
   R.SSPCPSR :=
     (CPSDVSR => SSPCPSR_CPSDVSR_Field (D.Divider.Prescale),
      others => <>);
   R.SSPCR1 := (SSE => True, others => <>);
   State (D.Port).Reconfig := State (D.Port).Reconfig + 1;
end Configure;

procedure Acquire (D : in out Device; Stat : out Status) is
   Again : Boolean;
begin
   Acquire (State (D.Port).Bus, D.Number, D.Want, Again, Stat);
   if Stat /= Ok then
      return;
   end if;
   if Again then
      Configure (D);
   end if;
   Set (D.Select_Pin, Keel.GPIO.Low);
end Acquire;

procedure Release (D : in out Device) is
begin
   Set (D.Select_Pin, Keel.GPIO.High);
   Release (State (D.Port).Bus, D.Number);
end Release;
