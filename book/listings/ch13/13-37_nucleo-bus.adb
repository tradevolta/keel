--  PA8, Arduino D7: CN9 pin 8 (UM2505, Table 15)
Line : Output_Pin (Port => A, Pin => 8);

--  Spin N microseconds on the cycle counter, which wraps safely
procedure Wait_Us (N : Positive) is
   Start : constant Unsigned_32 := Keel.Cortex_M.DWT_CYCCNT;
   Ticks : constant Unsigned_32 :=
     Unsigned_32 (N) * Unsigned_32 (Sys_Frequency / 1_000_000);
begin
   loop
      exit when Keel.Cortex_M.DWT_CYCCNT - Start >= Ticks;
   end loop;
end Wait_Us;

package Wire_Bus is new Keel.OneWire.Bit_Bang
  (Line => Output_Pin, Set => Set, Sense => Sense,
   Wait_Us => Wait_Us,
   Hold => Keel.Cortex_M.Disable_Interrupts,
   Let_Go => Keel.Cortex_M.Enable_Interrupts);
package Wire is new Bus_Signature
  (Output_Pin, Wire_Bus.Reset, Wire_Bus.Touch);
package Protocol is new Keel.OneWire.Protocol (Wire);
package Sensor is new Keel.Drivers.DS18B20 (Wire);
