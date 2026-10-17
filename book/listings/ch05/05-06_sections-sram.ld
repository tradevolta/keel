/* SRAM: code that runs from RAM, .data, then .bss. */
SECTIONS
{
  /* Reset_Handler copies .time_critical and .data together from
     flash: one copy, from __keel_data_load. Put code here with
     Linker_Section => ".time_critical". */
  .time_critical :
  {
    __keel_data_start = .;
    *(.time_critical .time_critical.*)
    . = ALIGN(4);
    __keel_time_critical_end = .;
  } > sram AT > flash
  __keel_data_load = LOADADDR(.time_critical);
  .data :
  {
    *(.data .data.*)
    . = ALIGN(4);
    __keel_data_end = .;
  } > sram AT > flash
  ASSERT(LOADADDR(.data) - __keel_data_load
         == ADDR(.data) - __keel_data_start,
         "keel: .time_critical and .data must be one block")
  /* Zeroed by Reset_Handler. */
  .bss (NOLOAD) :
  {
    __keel_bss_start = .;
    *(.bss .bss.* COMMON)
    . = ALIGN(4);
    __keel_bss_end = .;
  } > sram
}
