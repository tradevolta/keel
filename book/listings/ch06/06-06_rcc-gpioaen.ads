--  IO port A clock enable Set and cleared by software.
type RCC_AHB2ENR_GPIOAEN_Field is
  (--  IO port A clock disabled
   B_0x0,
   --  IO port A clock enabled
   B_0x1)
  with Size => 1;
for RCC_AHB2ENR_GPIOAEN_Field use
  (B_0x0 => 0,
   B_0x1 => 1);
