--  SPDX-License-Identifier: Apache-2.0
--  Just enough of an INA219 to read the current through its shunt:
--  one register over I2C0, polled. Chapter 17 writes the real
--  driver, on Keel's I2C HAL; this one exists for Chapter 8's
--  measurement only.
with Keel;       use Keel;
with Keel.Clock; use Keel.Clock;

package Power_Monitor is
   --  I2C0 at 100 kHz, SDA on GP4 and SCL on GP5. The RP2350's I2C
   --  runs on clk_sys, which runs at Sys. In_Use: one of the pins
   --  has another owner.
   procedure Start (Sys : Frequency; Stat : out Status);

   --  Keep 100 kHz after clk_sys has changed to Sys
   procedure Retime (Sys : Frequency);

   --  The shunt current in tenths of a milliampere. Timeout: no
   --  INA219 answered at address 0x40.
   procedure Read (Tenths_mA : out Integer; Stat : out Status);
end Power_Monitor;
