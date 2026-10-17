/* SPDX-License-Identifier: Apache-2.0 */
/* Keel L0 linker script for the RP2350 (Startup = "keel").
   The board's memory.ld names the regions flash and sram. */
INCLUDE memory.ld

/* Pull keel-startup.o out of the library, then start there. */
EXTERN(keel_reset_handler)
ENTRY(keel_reset_handler)

SECTIONS
{
  /* The boot ROM reads the vector table at the start of the image
     and looks for the IMAGE_DEF in the first 4 KB of flash. */
  .text :
  {
    KEEP(*(.keel.vectors))
    KEEP(*(.keel.image_def))
    *(.text .text.*)
    *(.rodata .rodata.*)
    . = ALIGN(4);
  } > flash

  .ARM.exidx :
  {
    *(.ARM.exidx*)
  } > flash

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
