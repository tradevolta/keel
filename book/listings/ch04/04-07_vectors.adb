--  The Armv8-M exception vectors 0 .. 15, as a record: GNAT builds
--  a constant record aggregate in flash at compile time, but an
--  array aggregate with "others" would need elaboration code. No
--  interrupt is enabled before Chapter 9, so the 52 interrupt
--  vectors that follow entry 15 come later.
type Exception_Vectors is record
   Initial_SP, Reset, NMI, HardFault, MemManage, BusFault,
   UsageFault, SecureFault, Reserved_8, Reserved_9, Reserved_10,
   SVCall, DebugMonitor, Reserved_13, PendSV, SysTick :
     System.Address;
end record;

Vectors : constant Exception_Vectors :=
  (Initial_SP => Stack_End'Address,
   Reset => Reset_Handler'Address,
   HardFault => HardFault_Handler'Address,
   others => Default_Handler'Address)
  with Export, External_Name => "keel_vectors",
       Linker_Section => ".keel.vectors";
