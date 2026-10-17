/* SPDX-License-Identifier: Apache-2.0 */
/* Raspberry Pi Pico 2 W: 4 MB of QSPI flash and 520 KB of SRAM
   (RP2350 datasheet, section 2.2). Written by hand in Chapter 4;
   Chapter 5 generates it from memory.toml. */
MEMORY
{
  flash (rx) : ORIGIN = 0x10000000, LENGTH = 4M
  sram (rwx) : ORIGIN = 0x20000000, LENGTH = 520K
}

__keel_stack_size = 4K;
