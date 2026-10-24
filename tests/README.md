# tests/

| Directory | What | Arrives in |
|---|---|---|
| `trace_host/` | `Keel.Trace` on the host, read back by an independent model of an RTT probe (`gnat_native`) | Chapter 5 |
| `units_host/` | `Keel.Units` literals on the host: accepted and rejected forms (`gnat_native`) | Chapter 6 |

Planned: `unit/` (AUnit on the host fakes, Chapter 7), `hil/`
(hardware-in-the-loop scenarios), `proof/` (GNATprove projects,
Chapter 24). `tools/ci-build` builds and runs every crate here.
