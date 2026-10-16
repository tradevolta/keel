# crates/

| Crate | Layer | Arrives in |
|---|---|---|
| `keel_core` | L3 interfaces, units, status, seam specs | skeleton now; `Keel.GPIO` in Chapter 6 |
| `keel_rp2350_svd`, `keel_stm32g4_svd` | L1 registers (svd2ada) | Chapter 5 |
| `keel_rp2350`, `keel_stm32g4` | L0 startup, L2 chip HAL | Chapters 3-6 |
| `keel_boards` | Board support (Pico 2 W, NUCLEO-G474RE) | Chapter 6 |
| `keel_host` | Fakes and simulators for host tests | Chapter 6, v1 in Chapter 24 |
| `keel_drivers` | One child package per device | Chapter 12 onward |
| `keel_seam_bare`, `keel_seam_jorvik` | Kernel seam backends | Chapters 8-9, 20 |
| `keel_cli`, `keel_log`, `keel_fs`, `keel_ui`, `keel_net`, `keel_boot` | Middleware | Chapters 14-27 |
| `keel_adl_compat` | Adapters to the `hal` crate interfaces | Chapter 16 |
