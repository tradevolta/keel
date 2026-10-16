# Licensing notes

* **Keel source and the book projects:** Apache-2.0. The full licence
  text is the `LICENSE` file already committed upstream at
  `github.com/tradevolta/keel`; this local skeleton does not carry its
  own copy so that the two histories merge without a conflict. Every
  source file starts with `SPDX-License-Identifier: Apache-2.0`.
* **Ada runtimes** (`light_rp2350`, `light_tasking_rp2350`,
  `embedded_rp2350`, ...): GPL-3.0-or-later WITH GCC-exception-3.1.
  The GCC Runtime Library Exception lets you distribute firmware that
  links them under terms of your choice. See Chapter 2 of the book.
* **CYW43439 Wi-Fi firmware** (Chapter 25): has its own redistribution
  terms and is fetched by a script at build time, never committed.
