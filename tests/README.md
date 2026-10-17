# tests/

| Directory | What | Arrives in |
|---|---|---|
| `trace_host/` | `Keel.Trace` on the host, read back by an independent model of an RTT probe (`gnat_native`) | Chapter 5 |

Planned: `unit/` (AUnit on the host fakes, Chapter 7), `hil/`
(hardware-in-the-loop scenarios), `proof/` (GNATprove projects,
Chapter 24). `tools/ci-build` builds and runs every crate here.
