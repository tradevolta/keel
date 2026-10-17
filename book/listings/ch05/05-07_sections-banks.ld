/* The two 4 KB banks: scratch data, and the region memory.toml
   chose for the main stack. */
SECTIONS
{
  /* Not initialized: Linker_Section => ".scratch_x" */
  .scratch_x (NOLOAD) :
  {
    *(.scratch_x .scratch_x.*)
  } > scratch_x
  /* Grows down from __keel_stack_end, 8-byte aligned (AAPCS). */
  .stack (NOLOAD) :
  {
    . = ALIGN(8);
    __keel_stack_start = .;
    . += __keel_stack_size;
    __keel_stack_end = .;
  } > stack
}
