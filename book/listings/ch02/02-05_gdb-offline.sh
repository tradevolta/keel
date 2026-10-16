cd book/ch02_single_step
alr exec -- arm-eabi-gdb -q -batch \
  -ex "set filename-display basename" \
  -ex "break single_step.adb:14" \
  -ex "list 13,16" \
  -ex "print blink_control.half_period_ms" \
  -ex "ptype blink_control.half_period_ms" \
  bin/single_step
