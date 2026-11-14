--  The comparators are clocked with SYSCFG
RCC_Periph.RCC_APB2ENR.SYSCFGEN := B_0x1;
Reserve_Analog (A, 1, Stat);
Check ("PA1");
Reserve (A, 6, Comp_AF, Stat);
Check ("PA6");
COMP_Periph.COMP_C1CSR :=
  (EN => True, INMSEL => DAC1_Channel_1, INPSEL => False,
   others => <>);

Keel.Trace.Put_Line ("sine_dac: 50 Hz on A2, 40 steps of 500 us");
Next := Keel.Time.Bare.Clock;
loop
   Next := Next + Step_Time;
   Keel.Time.Bare.Wait_Until (Next);
   Set_Code (Out_1, Sine (Step mod 40));
   if COMP_Periph.COMP_C1CSR.VALUE then
      High := High + 1;
   end if;
   Step := Step + 1;
   if Step = 2_000 then
      Keel.Trace.Put_Line
        ("sine_dac: comparator high" & Natural'Image (High / 20)
         & " % of the time");
      Step := 0;
      High := 0;
   end if;
end loop;
