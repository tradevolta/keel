# crates/

| Crate | Layer | Arrives in |
|---|---|---|
| `keel_core` | L3 interfaces, units, status, seam specs; `Keel.Trace` (RTT console); `Keel.Units`; `Keel.Status` and `Keel.GPIO` (signatures, interfaces, `Debounce`); `Keel.Clock` (PLL limits as data, a proved solver); `Keel.Quadrature`, `Keel.Faults` and the `Keel.Sync` seam; `Keel.Time` (the clock seam), `Keel.Timer` (alarm signature) and `Keel.PWM` (counter limits as data, a proved period solver); `Keel.ADC` (scaling, oversampling, a diode sensor, proved) and `Keel.DAC` (the output seam, the PWM-DAC adapter and its filter); `Keel.DMA` (transfer ends as regions, ring arithmetic, proved) and `Keel.DMA.Buffers` (buffers lent to the DMA and reclaimed with a receipt) | `Keel.Trace` in Chapter 5; `Keel.Units` in Chapter 6; `Keel.GPIO` in Chapter 7 (0.1.0); `Keel.Clock` in Chapter 8; `Keel.Sync` in Chapter 9; `Keel.Time`, `Keel.Timer`, `Keel.PWM` in Chapter 10 (0.2.0); `Keel.ADC`, `Keel.DAC` in Chapter 11 (0.3.0-dev); `Keel.DMA` in Chapter 12 |
| `keel_rp2350_svd`, `keel_stm32g4_svd` | L1 registers: `gen/` is svd2ada output (`tools/svd-gen`), `src/` the typed overlays | Chapter 6 |
| `keel_rp2350` | L0 startup (`Startup = "keel"`) and its linker script (`ld/`, memory map from `tools/memgen`); L2 chip HAL: `Keel.GPIO.RP2350`, `Keel.Clock.RP2350`, `Keel.Interrupts`, `Keel.Sync.Bare`, `Keel.Time.Bare` (TIMER0), `Keel.Timer.RP2350`, `Keel.PWM.RP2350`, `Keel.ADC.RP2350` (with DMA streaming), `Keel.DMA.RP2350` | Chapters 4-5; HAL from Chapter 7 (0.1.0); clocks in Chapter 8; interrupts in Chapter 9; time and PWM in Chapter 10 (0.2.0); the ADC and clk_adc in Chapter 11 (0.3.0-dev); DMA in Chapter 12 |
| `keel_stm32g4` | L0 startup (`Startup = "keel"`) and its linker script; L2 chip HAL: `Keel.GPIO.STM32G4`, `Keel.Clock.STM32G4`, `Keel.Interrupts`, `Keel.Sync.Bare`, `Keel.Time.Bare` (SysTick), `Keel.PWM.STM32G4`, `Keel.DAC.STM32G4`, `Keel.DMA.STM32G4` | HAL in Chapter 7 (0.1.0); startup and clocks in Chapter 8; interrupts in Chapter 9; time and PWM in Chapter 10 (0.2.0); the DAC in Chapter 11 (0.3.0-dev); DMA in Chapter 12 |
| `keel_boards` | Board support (Pico 2 W, NUCLEO-G474RE) | planned; in Chapter 7 each book project keeps its own `Board` |
| `keel_host` | Fakes and simulators for host tests: `Keel.GPIO.Fake` | Chapter 7 (0.1.0), v1 in Chapter 25 |
| `keel_drivers` | One child package per device | Chapter 13 onward |
| `keel_seam_bare`, `keel_seam_jorvik` | Kernel seam backends | Chapters 9-10, 21 |
| `keel_cli`, `keel_log`, `keel_fs`, `keel_ui`, `keel_net`, `keel_boot` | Middleware | Chapters 15-28 |
| `keel_adl_compat` | Adapters to the `hal` crate interfaces | Chapter 17 |
