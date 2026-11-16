--  SPDX-License-Identifier: Apache-2.0
package body Model_I2C
  with SPARK_Mode
is
   procedure Read_Register
     (B : in out Bus; Address : Natural; Register : Natural;
      Value : out Natural; Stat : out Keel.Status) is
   begin
      if Address = 16#40# and then Register in Registers'Range then
         Value := B.Regs (Register);
         Stat := Keel.Ok;
      else
         Value := 0;
         Stat := Keel.Timeout;
      end if;
   end Read_Register;

   procedure Write_Register
     (B : in out Bus; Address : Natural; Register : Natural;
      Value : Natural; Stat : out Keel.Status) is
   begin
      if Address = 16#40# and then Register in Registers'Range
        and then Value < 2**16
      then
         B.Regs (Register) := Value;
         Stat := Keel.Ok;
      else
         Stat := Keel.Timeout;
      end if;
   end Write_Register;
end Model_I2C;
