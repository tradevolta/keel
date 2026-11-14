procedure HardFault_Entry is
begin
   --  EXC_RETURN, in LR, bit 2: 0 if the frame is on the main
   --  stack, 1 if on the process stack. R0 carries its address.
   Asm ("tst lr, #4"          & ASCII.LF & ASCII.HT &
        "ite eq"              & ASCII.LF & ASCII.HT &
        "mrseq r0, msp"       & ASCII.LF & ASCII.HT &
        "mrsne r0, psp"       & ASCII.LF & ASCII.HT &
        "b keel_fault_report",
        Volatile => True);
end HardFault_Entry;

procedure Print is new Keel.Faults.Report (Keel.Trace.Put_Line);

procedure Report (Frame : System.Address) is
   Stacked : constant Stacked_Frame
     with Import, Address => Frame;
begin
   Keel.Startup.Last_Fault :=
     (CFSR => SCB.CFSR, HFSR => SCB.HFSR,
      MMFAR => SCB.MMFAR, BFAR => SCB.BFAR);
   if Keel.Trace.Ready then
      Print (SCB.CFSR, SCB.HFSR, SCB.MMFAR, SCB.BFAR, Stacked);
   end if;
   loop
      WFI;
   end loop;
end Report;
