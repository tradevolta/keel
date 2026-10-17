procedure Reset_Handler is
   Data_Words : constant Storage_Count :=
     (Data_End'Address - Data_Start'Address) / 4;
   BSS_Words : constant Storage_Count :=
     (BSS_End'Address - BSS_Start'Address) / 4;

   Data : Word_Array (1 .. Data_Words)
     with Import, Address => Data_Start'Address;
   Load : constant Word_Array (1 .. Data_Words)
     with Import, Address => Data_Load'Address;
   BSS : Word_Array (1 .. BSS_Words)
     with Import, Address => BSS_Start'Address;
begin
   --  1. Let the FPU run: all Keel code is built for hard float.
   SCB.CPACR := (SCB.CPACR with delta CP10 => Full, CP11 => Full);
   DSB;
   ISB;

   --  2. Take exceptions and interrupts through this table.
   SCB.VTOR := Vectors'Address;

   --  3. Copy the initial values of .data from flash to SRAM.
   for I in Data'Range loop
      Data (I) := Load (I);
   end loop;

   --  4. Zero .bss.
   for I in BSS'Range loop
      BSS (I) := 0;
   end loop;

   --  5. Elaborate, then run the main subprogram.
   Ada_Main;

   --  6. A main that returns leaves the core asleep.
   loop
      WFI;
   end loop;
end Reset_Handler;
