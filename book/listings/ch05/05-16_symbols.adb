--  Only the addresses of these symbols mean anything.
type Symbol is null record;

Text_Start : Symbol with Import, External_Name => "keel_vectors";
Text_End : Symbol with Import, External_Name => "__keel_text_end";
Data_Load : Symbol with Import, External_Name => "__keel_data_load";
Data_Start : Symbol
  with Import, External_Name => "__keel_data_start";
Data_End : Symbol with Import, External_Name => "__keel_data_end";
Fast_End : Symbol
  with Import, External_Name => "__keel_time_critical_end";
BSS_Start : Symbol with Import, External_Name => "__keel_bss_start";
BSS_End : Symbol with Import, External_Name => "__keel_bss_end";
Stack_Start : Symbol
  with Import, External_Name => "__keel_stack_start";
Stack_End : Symbol with Import, External_Name => "__keel_stack_end";
