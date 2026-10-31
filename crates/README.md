# crates/

| Crate | Layer | Arrives in |
|---|---|---|
| `keel_core` | L3 interfaces, units, status, seam specs; `Keel.Trace` (RTT console); `Keel.Units`; `Keel.Status` and `Keel.GPIO` (signatures, interfaces, `Debounce`) | `Keel.Trace` in Chapter 5; `Keel.Units` in Chapter 6; `Keel.GPIO` in Chapter 7 (0.1.0) |
| `keel_rp2350_svd`, `keel_stm32g4_svd` | L1 registers: `gen/` is svd2ada output (`tools/svd-gen`), `src/` the typed overlays | Chapter 6 |
| `keel_rp2350` | L0 startup (`Startup = "keel"`) and its linker script (`ld/`, memory map from `tools/memgen`); L2 chip HAL: `Keel.GPIO.RP2350` | Chapters 4-5; HAL from Chapter 7 (0.1.0) |
| `keel_stm32g4` | L2 chip HAL: `Keel.GPIO.STM32G4`; L0 startup later | HAL in Chapter 7 (0.1.0); until its startup lands, the NUCLEO ports use the runtime's |
| `keel_boards` | Board support (Pico 2 W, NUCLEO-G474RE) | planned; in Chapter 7 each book project keeps its own `Board` |
| `keel_host` | Fakes and simulators for host tests: `Keel.GPIO.Fake` | Chapter 7 (0.1.0), v1 in Chapter 25 |
| `keel_drivers` | One child package per device | Chapter 13 onward |
| `keel_seam_bare`, `keel_seam_jorvik` | Kernel seam backends | Chapters 9-10, 21 |
| `keel_cli`, `keel_log`, `keel_fs`, `keel_ui`, `keel_net`, `keel_boot` | Middleware | Chapters 15-28 |
| `keel_adl_compat` | Adapters to the `hal` crate interfaces | Chapter 17 |
