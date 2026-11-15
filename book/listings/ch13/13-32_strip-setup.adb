package Wire is new Bus_Signature (Board.Bus, Reset, Touch);
package Protocol is new Keel.OneWire.Protocol (Wire);
package Sensor is new Keel.Drivers.DS18B20 (Wire);
package Transport is new Strip_Signature (Board.Strip, Put, Latch);
procedure Show is new Keel.Drivers.WS2812.Show (Transport);

--  An eighth of full brightness: enough indoors, and about an
--  eighth of the current the stick draws at full white
Level : constant Intensity := 32;

type Probe is (A, B);
ROMs  : array (Probe) of ROM_Code := [others => [others => 0]];
Temps : array (Probe) of Celsius := [others => 20.0];
Count : Natural := 0;
