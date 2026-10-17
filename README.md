# Keel

Keel is an Apache-2.0 Ada 2022 / SPARK hardware abstraction layer and
driver set for microcontrollers, built chapter by chapter in the book
*Bare Metal to Cloud with Ada: Building a Verified HAL, Drivers and IoT
Devices on the Raspberry Pi Pico 2 W* (Vincent Donkor).

Primary board: Raspberry Pi Pico 2 W (RP2350). Secondary board:
ST NUCLEO-G474RE (STM32G474).

**Status: 0.0.3, skeleton, L0 startup, linker generator and RTT
console (book Chapters 1-5).** Nothing here is a usable HAL yet:
`keel_rp2350` brings a chip from reset to your main subprogram
(Chapter 4), `tools/memgen` writes its memory map from
`memory.toml` and `Keel.Trace` prints over RTT (Chapter 5), and
`Keel.GPIO` arrives with Chapter 7 (Keel 0.1.0).

## Layout

| Path | What lives there |
|---|---|
| `crates/` | The Keel Alire crates (`keel_core` today; `keel_rp2350`, `keel_stm32g4`, drivers and middleware later) |
| `book/` | One Alire crate per chapter project (`chNN_<slug>`), plus `book/listings/` exported from the manuscript |
| `tools/` | Host tools: `flash` (UF2/BOOTSEL/SWD), `ci-build`, `memgen` (`memory.toml` to linker script) |
| `tests/` | Host tests (`trace_host` from Chapter 5), HIL scenarios and proof projects (from Chapter 24) |
| `docs/` | Documentation and architecture decision records (`docs/adr/`) |
| `alire/` | Index fragments and release scripts (from Keel 0.1.0) |
| `.github/workflows/` | CI: builds every crate on each push and weekly |

Each crate has its own `alire.toml` and pins exact versions, so a
chapter tag always rebuilds the way the printed book shows it.

## Toolchain (pinned)

| Tool | Version |
|---|---|
| Alire (`alr`) | 2.1.1 |
| `gnat_arm_elf` | 16.1.0 |
| `gnat_native` | 16.1.0 (host builds) |
| `gprbuild` | 26.0.1 |
| `light_tasking_rp2350`, `light_rp2350` | 16.0.0 (community bb-runtimes) |
| picotool | 2.1.1 |
| OpenOCD | Raspberry Pi fork (`sdk-2.0.0`), needs `target/rp2350.cfg` |

## Quick start

```
git clone https://github.com/tradevolta/keel
cd keel/book/ch01_hello_photon
alr build
cd ../..
tools/flash uf2 book/ch01_hello_photon
```

Then hold BOOTSEL, plug in the Pico 2 W and copy
`book/ch01_hello_photon/bin/hello_photon.uf2` to the `RP2350` drive.

## Licence

Keel is licensed under the Apache License, Version 2.0; see `LICENSE`
in the upstream repository and `LICENSING.md` for the third-party
components (runtimes, firmware) you combine it with.
