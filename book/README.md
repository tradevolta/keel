# book/

One Alire crate per chapter project. Build any of them from its own
directory with `alr build`, or all of them with `tools/ci-build`.

| Crate | Chapter | Runtime |
|---|---|---|
| `ch01_hello_photon` | 1, "Hello, Photon": GP15 LED at 2 Hz | `light_tasking_rp2350` 16.0.0 |
| `ch02_single_step` | 2, "Single-step the blink" (GDB) | `light_tasking_rp2350` 16.0.0 |
| `ch03_rp2350_regs` | 3, hand-written IO_BANK0, PADS_BANK0, SIO and RESETS overlays (library, no main) | any (host or `light_tasking_rp2350`) |
| `ch03_register_playground` | 3, "Register Playground": Ada basics and the overlays in host RAM | host (`gnat_native` 16.1.0) |
| `ch03_gp15_overlay` | 3, the same overlays at the real addresses, blinking GP15 | `light_tasking_rp2350` 16.0.0 |
| `ch04_zero_runtime_blinky` | 4, "Zero-runtime blinky": GP15 with Keel's own startup | `light_rp2350` 16.0.0, `keel_rp2350.Startup = "keel"` |
| `ch05_memory_cartographer` | 5, "Memory cartographer": section map, stack high-water mark and a hot loop in SRAM, over RTT | `light_rp2350` 16.0.0, `keel_rp2350.Startup = "keel"` |
| `ch06_traffic_light` | 6, "Register-level traffic light": three LEDs through svd2ada registers; `bad/` holds the mask mistakes the types reject | `light_rp2350` 16.0.0, `keel_rp2350.Startup = "runtime"` |
| `ch06_traffic_light_nucleo` | 6, Port it: the same state machine on the NUCLEO-G474RE | `light_stm32g4xx` 16.0.0 |
| `ch07_reaction_time` | 7, "Reaction-time game": two buttons and three lamps through `Keel.GPIO`; `bad/` holds the pin mistakes the compiler rejects | `light_rp2350` 16.0.0, `keel_rp2350.Startup = "runtime"` |
| `ch07_reaction_host` | 7, the same game on `Keel.GPIO.Fake` with a scripted bench and simulated time | host (`gnat_native` 16.1.0) |
| `ch07_reaction_time_nucleo` | 7, Port it: the same game and panel on the NUCLEO-G474RE through `Keel.GPIO.STM32G4` | `light_stm32g4xx` 16.0.0 |
| `ch08_frequency_explorer` | 8, "Frequency explorer": a button walks clk_sys through 12, 48, 150 and 200 MHz; GP21 carries clk_sys / 1000; an INA219 reads the current | `light_rp2350` 16.0.0, `keel_rp2350.Startup = "keel"` |
| `ch08_frequency_explorer_nucleo` | 8, Port it: SYSCLK through 16, 48, 150 and 170 MHz, SYSCLK / 16 on PA8 | `light_stm32g4xx` 16.0.0, `keel_stm32g4.Startup = "keel"` |
| `ch09_volume_knob` | 9, "Rotary encoder volume knob + crash detective": the encoder decoded in the IO_IRQ_BANK0 handler drives an 8-LED bar; a press of the knob calls a null access and the fault reporter explains it | `light_rp2350` 16.0.0, `keel_rp2350.Startup = "keel"` |
| `ch09_volume_knob_jorvik` | 9, the same decoding in an Ada protected handler (`Attach_Handler`), the main task blocked on an entry | `light_tasking_rp2350` 16.0.0 |
| `ch09_volume_knob_nucleo` | 9, Port it: the knob on PA0, PA1 and PA4 through EXTI0, 1 and 4, the bar on Arduino D2 to D9 | `light_stm32g4xx` 16.0.0, `keel_stm32g4.Startup = "keel"` |
| `ch10_mood_light` | 10, "Mood light & servo sweeper": a gamma-corrected RGB fade on PWM slices 0 and 1, an SG92R servo at 50 Hz, a frequency meter on GP7 gated by a TIMER0 alarm; `ANGLE=sweep` (default) or `pot` (Chapter 11) | `light_rp2350` 16.0.0, `keel_rp2350.Startup = "keel"` |
| `ch10_mood_light_nucleo` | 10, Port it: the LED on TIM3, the servo on TIM4, TIM2 counting MCO, `Keel.Time.Bare` on SysTick | `light_stm32g4xx` 16.0.0, `keel_stm32g4.Startup = "keel"` |
| `ch11_battery_monitor` | 11, "Battery & light monitor": VSYS / 3, an LDR, the temperature sensor and a PWM DAC read back, round robin through the FIFO and oversampled; the NUCLEO's sine captured at 10 kS/s; the level on Chapter 9's LED bar | `light_rp2350` 16.0.0, `keel_rp2350.Startup = "keel"` |
| `ch11_sine_nucleo` | 11, Port it: a 50 Hz sine on DAC1 (PA4) for the Pico 2 W to sample, and COMP1 comparing a potentiometer with it | `light_stm32g4xx` 16.0.0, `keel_stm32g4.Startup = "keel"` |

`listings/` holds every numbered listing of the book, byte for byte,
as exported by the manuscript build (`listings/INDEX.csv` maps each
listing number to its file).
