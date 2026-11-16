--  SPDX-License-Identifier: Apache-2.0
--  A model I2C bus with one INA219's registers on it, so GNATprove
--  sees the driver instantiated
with Keel;

package Model_I2C
  with SPARK_Mode
is
   type Registers is array (0 .. 5) of Natural range 0 .. 2**16 - 1;
   type Bus is record
      Regs : Registers := [16#399F#, 0, 0, 0, 0, 0];
   end record;

   --  The driver's formal reads through an in out bus, as a real
   --  transport's must; the model's reads change nothing
   pragma Warnings (GNATprove, Off, "is not modified, could be IN");
   procedure Read_Register
     (B : in out Bus; Address : Natural; Register : Natural;
      Value : out Natural; Stat : out Keel.Status);
   pragma Warnings (GNATprove, On, "is not modified, could be IN");
   procedure Write_Register
     (B : in out Bus; Address : Natural; Register : Natural;
      Value : Natural; Stat : out Keel.Status);
end Model_I2C;
