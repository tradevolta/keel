/* SPDX-License-Identifier: Apache-2.0 */
/* For comparison only: GPIO15_CTRL the way a C header often does it. */
#include <stdint.h>

#define IO_BANK0_BASE 0x40028000u
#define GPIO15_CTRL (*(volatile uint32_t *)(IO_BANK0_BASE + 0x07Cu))
/* FUNCSEL is bits [4:0] */
#define FUNCSEL_MASK 0x0000001Fu
#define FUNCSEL_SIO 5u

void gp15_to_sio(void)
{
    /* Read-modify-write; nothing stops you writing 0x55 here. */
    GPIO15_CTRL = (GPIO15_CTRL & ~FUNCSEL_MASK) | FUNCSEL_SIO;
}

/* Shorter, but C leaves bit-field order and access width to the
   compiler (ISO C 6.7.2.1, 6.7.3). */
struct gpio_ctrl {
    uint32_t funcsel : 5;
    uint32_t : 7;
    uint32_t outover : 2;
    uint32_t oeover : 2;
};
