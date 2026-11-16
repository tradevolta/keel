# tests/

| Directory | What | Arrives in |
|---|---|---|
| `trace_host/` | `Keel.Trace` on the host, read back by an independent model of an RTT probe (`gnat_native`) | Chapter 5 |
| `units_host/` | `Keel.Units` literals on the host: accepted and rejected forms (`gnat_native`) | Chapter 6 |
| `gpio_host/` | `Keel.GPIO` on `Keel.GPIO.Fake`: claiming, contracts, pulls, `Debounce`, the signatures and interfaces (`gnat_native`, `-gnata`) | Chapter 7 |
| `gpio_proof/` | GNATprove proves `Keel.GPIO.Debounce` (`gnatprove` 16.1.0) | Chapter 7 |
| `clock_host/` | `Keel.Clock.Solve` on the host: a table of PLL settings for both chips, checked against the datasheets' own (`gnat_native`) | Chapter 8 |
| `clock_proof/` | GNATprove proves `Keel.Clock`: every setting `Solve` returns is inside the PLL's limits and makes the target exactly (`gnatprove` 16.1.0) | Chapter 8 |
| `irq_host/` | `Keel.Quadrature` stepped through turns, bounce and missed phases, and `Keel.Faults.Report` printing Chapter 4's fault (`gnat_native`) | Chapter 9 |
| `irq_proof/` | GNATprove proves `Keel.Quadrature` and `Keel.Faults`: the position stays in its range, every step is the table's (`gnatprove` 16.1.0) | Chapter 9 |
| `timer_host/` | `Keel.PWM.Solve` on the host: settings for both chips against values worked by hand, duty and width levels, `Keel.Time` arithmetic (`gnat_native`) | Chapter 10 |
| `timer_proof/` | GNATprove proves `Keel.PWM` and `Keel.Time`: every setting `Solve` returns is inside the counter's limits and within half a count of the period, every level fits (`gnatprove` 16.1.0) | Chapter 10 |
| `adc_host/` | `Keel.ADC` and `Keel.DAC` on the host: codes to volts, oversampling a noisy input, the RP2350's temperature sensor, PWM-DAC levels and the RC filter, against values worked by hand (`gnat_native`) | Chapter 11 |
| `adc_proof/` | GNATprove proves `Keel.ADC` and `Keel.DAC` free of run-time errors, with every oversampled code and DAC level inside its range (`gnatprove` 16.1.0) | Chapter 11 |
| `dma_host/` | `Keel.DMA` on `Keel.DMA.Fake`: ring arithmetic, where transfers fit, buffers lent and reclaimed, the misuses the contracts catch at run time, and the logic sampler's ring, trigger and capture on a simulated RC input; writes `capture-sim.txt` (`gnat_native`) | Chapter 12 |
| `dma_proof/` | GNATprove proves `Keel.DMA`, `Keel.DMA.Buffers` in use, `Keel.DMA.Fake`'s contract and the sampler's trigger; `bad/` is a program that reads a lent buffer and forges a receipt, which GNATprove rejects (`gnatprove` 16.1.0) | Chapter 12 |
| `pio_host/` | The PIO assembler's words against pioasm's (`pioasm/*.pio`, Adafruit `adafruit_pioasm` 1.3.8), the 1-Wire and WS2812 programs' timing simulated cycle by cycle from those words (`Sim_PIO`), relocation and dividers, CRC-8, the ROM search and DS18B20 reads on `Keel.OneWire.Fake`, the datasheet's temperature table, WS2812 bits and the thermo-strip's colours | Chapter 13 |
| `pio_proof/` | GNATprove proves `Keel.PIO`, its assembler and both programs (every side-set and delay), `Keel.OneWire`'s CRC-8 against its definition, the protocol, the DS18B20 and WS2812 drivers on a model bus, and the thermo-strip's colours; `bad/` has a delay too long for its side-set and a missing side-set value, which GNATprove rejects (`gnatprove` 16.1.0) | Chapter 13 |
| `power_host/` | `Keel.Watchdog.Solve` for both chips against values worked by hand, `Keel.RTC` against `Ada.Calendar` on every day from 1970 to 2369, `Keel.Power.Choose` and `Idle` on a fake clock, the INA219 stub against SBOS448G's register examples on a model bus, and the sentinel's log through a full ring and its eight words | Chapter 14 |
| `power_proof/` | GNATprove proves `Keel.Watchdog` (every setting fits the counter and reaches the timeout within one prescaler step), `Keel.RTC` (`Split` gives a valid date that `Join` turns back into the same millisecond), `Keel.Power` (the deepest affordable mode), the INA219 stub on a model bus and the sentinel's log packing (`Decode (Encode (L)) = L`) (`gnatprove` 16.1.0) | Chapter 14 |
| `uart_host/` | `Keel.Bus.UART.Solve` for both chips against the datasheet's example and values worked by hand, a table of divisors and errors, the ring in order and between two tasks, the line discipline and the words, NMEA sentences, AT replies, log lines and the sink; `keelsh_host` is the real keelsh on a fake board that reads standard input (`gnat_native`) | Chapter 15 |
| `uart_proof/` | GNATprove proves `Keel.Ring_Buffers` at Gold (Push appends, Pop takes the oldest, each side writes only its own counter), the baud-rate solver, `Keel.NMEA`'s checksum against its definition, `Keel.AT_Replies`, the shell's line discipline and words, and log-line formatting; `bad/` has a Pop that takes the newest element and a caller that pops without asking, which GNATprove rejects (`gnatprove` 16.1.0) | Chapter 15 |

The host tests are plain Ada mains with a small `Check` procedure,
not AUnit. Planned: `hil/` (hardware-in-the-loop scenarios) and
`proof/` (GNATprove projects, Chapter 24; `gpio_proof/`, `clock_proof/`,
`irq_proof/`, `timer_proof/`, `adc_proof/`, `dma_proof/`, `pio_proof/`, `power_proof/` and `uart_proof/` move
there).
`tools/ci-build` builds and runs every crate here, and proves the
ones that depend on `gnatprove`.
