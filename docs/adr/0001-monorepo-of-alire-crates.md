# ADR 0001: One repository, many Alire crates

* Status: accepted (Keel 0.0.1, book Chapter 2)

## Context

Keel has a layered design (registers, chip HAL, interfaces, drivers,
middleware) and the book adds a project per chapter. Alire 2.1 builds
one crate at a time; it has no multi-crate workspace manifest.

## Decision

Keep everything in one Git repository. Every library and every book
project is its own Alire crate with its own `alire.toml`, under
`crates/` and `book/`. Crates refer to each other with `[[pins]]` path
pins inside the repository and to published crates with exact
versions. `tools/ci-build` builds them all; CI calls it.

## Consequences

A chapter tag captures the framework and the book projects together,
so the printed book can always be rebuilt. Publishing to the Alire
index happens per crate from Keel 0.1.0.
