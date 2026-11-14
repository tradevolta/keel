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

The host tests are plain Ada mains with a small `Check` procedure,
not AUnit. Planned: `hil/` (hardware-in-the-loop scenarios) and
`proof/` (GNATprove projects, Chapter 24; `gpio_proof/`, `clock_proof/`,
`irq_proof/`, `timer_proof/` and `adc_proof/` move there).
`tools/ci-build` builds and runs every crate here, and proves the
ones that depend on `gnatprove`.
