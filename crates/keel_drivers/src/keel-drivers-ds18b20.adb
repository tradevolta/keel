--  SPDX-License-Identifier: Apache-2.0
with Keel.OneWire.Protocol;

package body Keel.Drivers.DS18B20
  with SPARK_Mode
is
   package Protocol is new Keel.OneWire.Protocol (Wire);

   procedure Start_Conversion (B : in out Wire.Bus; Stat : out Status)
   is
   begin
      Protocol.Select_All (B, Stat);
      if Stat = Ok then
         Protocol.Write_Byte (B, Convert_T, Stat);
      end if;
   end Start_Conversion;

   procedure Read
     (B    : in out Wire.Bus;
      ROM  : ROM_Code;
      Raw  : out Raw_Temperature;
      Stat : out Status)
   is
      --  Temperature LSB and MSB, alarm limits, configuration, three
      --  reserved bytes, CRC
      Pad  : Byte_Array (1 .. 9);
      Bits : Natural;
   begin
      Raw := 0;
      Protocol.Select_Device (B, ROM, Stat);
      if Stat = Ok then
         Protocol.Write_Byte (B, Read_Scratchpad, Stat);
      end if;
      if Stat = Ok then
         Protocol.Read (B, Pad, Stat);
      else
         Pad := [others => 0];
      end if;
      if Stat = Ok and then All_Zero (Pad) then
         Stat := Bus_Low;
      elsif Stat = Ok and then CRC8 (Pad (1 .. 8)) /= Pad (9) then
         Stat := CRC_Error;
      end if;
      if Stat = Ok then
         Bits := Natural (Pad (2)) * 256 + Natural (Pad (1));
         Raw := Raw_Temperature
           (if Bits >= 2**15 then Bits - 2**16 else Bits);
      end if;
   end Read;
end Keel.Drivers.DS18B20;
