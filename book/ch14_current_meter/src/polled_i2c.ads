--  SPDX-License-Identifier: Apache-2.0
--  I2C0 as a controller at 100 kHz, polled, with SDA on GP4 and SCL
--  on GP5: 16-bit registers, most significant byte first, which is
--  what Keel.Drivers.INA219 asks of a bus. Chapter 17 replaces it
--  with Keel's interrupt-driven I2C.
with Keel;       use Keel;
with Keel.Clock; use Keel.Clock;

package Polled_I2C is
   type Bus is limited null record;

   --  clk_sys runs at Sys. In_Use: GP4 or GP5 has another owner.
   procedure Start (B : in out Bus; Sys : Frequency; Stat : out Status);

   --  Timeout: nothing at Address acknowledged, or it held the bus
   procedure Read_Register
     (B : in out Bus; Address : Natural; Register : Natural;
      Value : out Natural; Stat : out Status);
   procedure Write_Register
     (B : in out Bus; Address : Natural; Register : Natural;
      Value : Natural; Stat : out Status);
end Polled_I2C;
