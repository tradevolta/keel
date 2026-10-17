/* SPDX-License-Identifier: Apache-2.0 */
/* Keel L0 linker script for the RP2350 (Startup = "keel").
   The board's memory.ld names the regions flash and sram. */
INCLUDE memory.ld

/* Pull keel-startup.o out of the library, then start there. */
EXTERN(keel_reset_handler)
ENTRY(keel_reset_handler)

/* Flash: the boot structures, then code and constants. */
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
}
