--  SPDX-License-Identifier: Apache-2.0
--  A deliberate fault, for the fault reporter to explain
package Crash is
   --  Call through a null access-to-subprogram, with the check that
   --  would catch it suppressed: the processor branches to 0
   procedure Now;
end Crash;
