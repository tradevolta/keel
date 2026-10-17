--  SPDX-License-Identifier: Apache-2.0
--  Where the linker put everything, from the symbols that
--  keel-sections.ld defines.
package Sections is
   --  One line per section over Keel.Trace: start, end, size.
   procedure Report;
end Sections;
