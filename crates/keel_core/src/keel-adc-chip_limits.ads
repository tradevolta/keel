--  SPDX-License-Identifier: Apache-2.0
--  The converters and sensors Keel knows, as data
package Keel.ADC.Chip_Limits
  with Pure, SPARK_Mode
is
   --  RP2350: 12 bits; the reference is the ADC's own supply,
   --  ADC_AVDD, 3.3 V on the Pico 2 W (datasheet 12.4)
   RP2350_ADC : constant Scale := (Bits => 12, Reference => 3.3,
                                   Divider => 1);

   --  RP2350 temperature sensor: typically 0.706 V at 27 degrees,
   --  -1.721 mV per degree (datasheet 12.4.6)
   RP2350_Sensor : constant Diode_Sensor :=
     (At_Ref => 0.706, T_Ref => 27, Slope => -1_721);
end Keel.ADC.Chip_Limits;
