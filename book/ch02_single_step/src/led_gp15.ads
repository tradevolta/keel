--  SPDX-License-Identifier: Apache-2.0
--  The Chapter 1 register code, moved into a package.
package LED_GP15 is

   procedure Init;
   --  Release IO_BANK0 and PADS_BANK0 from reset and make GP15 a
   --  software-controlled (SIO) output.

   procedure Toggle;
   --  Flip GP15 with one write to SIO GPIO_OUT_XOR.

end LED_GP15;
