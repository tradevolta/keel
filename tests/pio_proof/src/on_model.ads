--  SPDX-License-Identifier: Apache-2.0
--  The generics, instantiated on the model bus, so GNATprove proves
--  their bodies
with Keel.OneWire;          use Keel.OneWire;
with Keel.OneWire.Protocol;
with Keel.Drivers.DS18B20;
with Keel.Drivers.WS2812;
with Model_Bus;

package On_Model
  with SPARK_Mode
is
   package Wire is new Bus_Signature
     (Model_Bus.Bus, Model_Bus.Reset, Model_Bus.Touch);
   package Protocol is new Keel.OneWire.Protocol (Wire);
   package Sensor is new Keel.Drivers.DS18B20 (Wire);

   package Strip is new Keel.Drivers.WS2812.Strip_Signature
     (Model_Bus.Bus, Model_Bus.Put, Model_Bus.Latch);
   procedure Show is new Keel.Drivers.WS2812.Show (Strip);
end On_Model;
