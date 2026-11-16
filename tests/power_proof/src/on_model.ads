--  SPDX-License-Identifier: Apache-2.0
with Keel.Drivers.INA219;
with Model_I2C;

package On_Model
  with SPARK_Mode
is
   package Meter is new Keel.Drivers.INA219
     (Model_I2C.Bus, Model_I2C.Read_Register,
      Model_I2C.Write_Register);
end On_Model;
