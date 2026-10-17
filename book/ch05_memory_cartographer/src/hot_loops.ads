--  SPDX-License-Identifier: Apache-2.0
--  The same loop twice: one copy runs from flash through the XIP
--  cache, the other from SRAM.
with RP2350.SIO;

package Hot_Loops is
   LED : constant RP2350.SIO.Pin_Mask :=
     [15 => True, others => False];

   --  Make GP15 an SIO output, as in Chapter 3.
   procedure Setup_LED;

   --  Toggle GP15 Count times, as fast as the code runs.
   procedure Burst_In_Flash (Count : Natural);

   procedure Burst_In_SRAM (Count : Natural)
     with Linker_Section => ".time_critical";
end Hot_Loops;
