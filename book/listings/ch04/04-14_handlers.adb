procedure HardFault_Handler is
begin
   Last_Fault :=
     (CFSR => SCB.CFSR,
      HFSR => SCB.HFSR,
      MMFAR => SCB.MMFAR,
      BFAR => SCB.BFAR);
   loop
      WFI;
   end loop;
end HardFault_Handler;

procedure Default_Handler is
begin
   loop
      WFI;
   end loop;
end Default_Handler;

procedure Last_Chance_Handler (File : System.Address; Line : Integer)
is
begin
   Last_Exception := (File => File, Line => Line);
   loop
      WFI;
   end loop;
end Last_Chance_Handler;
