--  Symbols that ld/keel-sections.ld defines. Only their addresses
--  mean anything; Import keeps Ada from touching the "objects".
Stack_End : Word with Import, External_Name => "__keel_stack_end";
Data_Start : Word with Import, External_Name => "__keel_data_start";
Data_End : Word with Import, External_Name => "__keel_data_end";
Data_Load : constant Word
  with Import, External_Name => "__keel_data_load";
BSS_Start : Word with Import, External_Name => "__keel_bss_start";
BSS_End : Word with Import, External_Name => "__keel_bss_end";

--  The binder's main: elaborates every unit, then calls yours.
procedure Ada_Main
  with Import, Convention => C, External_Name => "main";

type Word_Array is array (Storage_Count range <>) of Word;
