# tools/memgen

Writes the `MEMORY` part of a Keel linker script from a board's
`memory.toml` (book Chapter 5). Build it with `alr build` here, then
from the repository root:

    tools/memgen/bin/memgen crates/keel_rp2350/ld/pico2w/memory.toml \
      crates/keel_rp2350/ld/pico2w/memory.ld

It refuses a map whose regions overlap or are not word-aligned, or
whose stack does not fit its region. `memgen --check TOML LD` exits
with status 1 when `LD` is not what `TOML` would generate;
`tools/ci-build` runs it for every board.
