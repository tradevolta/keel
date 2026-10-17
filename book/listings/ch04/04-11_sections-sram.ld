/* SRAM: the stack, then .data and .bss. */
SECTIONS
{
  /* The main stack comes first, so an overflow cannot run down
     into .data and .bss. It grows down from __keel_stack_end and
     stays 8-byte aligned (AAPCS). */
  .stack (NOLOAD) :
  {
    . = ALIGN(8);
    __keel_stack_start = .;
    . += __keel_stack_size;
    __keel_stack_end = .;
  } > sram
  /* Copied from flash to SRAM by Reset_Handler. */
  .data :
  {
    __keel_data_start = .;
    *(.data .data.*)
    . = ALIGN(4);
    __keel_data_end = .;
  } > sram AT > flash
  __keel_data_load = LOADADDR(.data);
  /* Zeroed by Reset_Handler. */
  .bss (NOLOAD) :
  {
    __keel_bss_start = .;
    *(.bss .bss.* COMMON)
    . = ALIGN(4);
    __keel_bss_end = .;
  } > sram
}
