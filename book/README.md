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

`listings/` holds every numbered listing of the book, byte for byte,
as exported by the manuscript build (`listings/INDEX.csv` maps each
listing number to its file).
