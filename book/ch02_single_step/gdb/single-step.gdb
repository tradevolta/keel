# SPDX-License-Identifier: Apache-2.0
# Connect to OpenOCD, flash the ELF, stop on every toggle.
target extended-remote localhost:3333
monitor reset halt
load
break single_step.adb:14
display/d blink_control.toggles
display/d blink_control.half_period_ms
continue
