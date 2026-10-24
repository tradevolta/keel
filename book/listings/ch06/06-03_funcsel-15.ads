type GPIO15_CTRL_FUNCSEL_Field is
  (hstx_3,
   spi1_tx,
   uart0_rts,
   i2c1_scl,
   pwm_b_7,
   sio_15,
   pio0_15,
   pio1_15,
   pio2_15,
   clocks_gpout_1,
   usb_muxing_overcurr_detect,
   uart0_rx,
   null_k)
  with Size => 5;
for GPIO15_CTRL_FUNCSEL_Field use
  (hstx_3 => 0,
   spi1_tx => 1,
   uart0_rts => 2,
   i2c1_scl => 3,
   pwm_b_7 => 4,
   sio_15 => 5,
   pio0_15 => 6,
   pio1_15 => 7,
   pio2_15 => 8,
   clocks_gpout_1 => 9,
   usb_muxing_overcurr_detect => 10,
   uart0_rx => 11,
   null_k => 31);
