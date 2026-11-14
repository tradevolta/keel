for Ch in reverse Channel loop
   if Inputs (Ch) then
      Mask := Mask or 2**Natural (Ch);
      First := Ch;
      Count := Count + 1;
   end if;
end loop;
Period := 48_000_000 * 256 / Long_Long_Integer (Rate) - 256;

Stat := Timeout;
if not Wait_Ready then
   return;
end if;
Drain;
ADC_Periph.FCS :=
  (EN => True, ERR => True, THRESH => 1, UNDER => True,
   OVER => True, others => <>);
ADC_Periph.DIV :=
  (INT => DIV_INT_Field (Period / 256),
   FRAC => DIV_FRAC_Field (Period mod 256), others => <>);
CS.AINSEL := CS_AINSEL_Field (First);
CS.RROBIN := Mask;
CS.START_MANY := True;
ADC_Periph.CS := CS;
