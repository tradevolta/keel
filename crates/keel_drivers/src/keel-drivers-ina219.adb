--  SPDX-License-Identifier: Apache-2.0
package body Keel.Drivers.INA219
  with SPARK_Mode
is
   procedure Configure
     (B : in out Bus; C : Config; Stat : out Keel.Status;
      Address : Natural := Default_Address) is
   begin
      Write_Register (B, Address, Configuration, Encode (C), Stat);
   end Configure;

   procedure Read_Shunt
     (B : in out Bus; Microvolts : out Integer; Stat : out Keel.Status;
      Address : Natural := Default_Address)
   is
      Raw : Natural;
   begin
      Read_Register (B, Address, Shunt_Voltage, Raw, Stat);
      Microvolts := (if Raw in Word then Shunt_uV (Raw) else 0);
   end Read_Shunt;

   procedure Read_Bus
     (B : in out Bus; Millivolts : out Natural; Fresh : out Boolean;
      Stat : out Keel.Status; Address : Natural := Default_Address)
   is
      Raw : Natural;
   begin
      Read_Register (B, Address, Bus_Voltage, Raw, Stat);
      if Raw in Word then
         Millivolts := Bus_mV (Raw);
         Fresh := Ready (Raw);
      else
         Millivolts := 0;
         Fresh := False;
      end if;
   end Read_Bus;
end Keel.Drivers.INA219;
