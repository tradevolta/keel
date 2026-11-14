--  The mean of N codes that add up to Total, to the nearest code,
--  and never above Top (S)
function Mean (S : Scale; Total : Natural; N : Sample_Count)
  return Code
  with Post => Mean'Result <= Top (S);

--  The voltage at the input for Value, a code with K extra bits:
--  Value * Reference * Divider / 2**(Bits + K), to 1 mV
function To_Volts (S : Scale; Value : Code; K : Extra_Bits := 0)
  return Volts
  with Pre => Valid (S);

--  A diode sensor: At_Ref volts at T_Ref degrees, changing by
--  Slope microvolts per degree (negative: the voltage falls as
--  the temperature rises)
type Diode_Sensor is record
   At_Ref : Volts := 0.7;
   T_Ref  : Integer range -40 .. 125 := 25;
   Slope  : Integer range -5_000 .. -100 := -2_000;
end record;

function Valid (D : Diode_Sensor) return Boolean is
  (D.At_Ref in 0.1 .. 2.0);

--  The temperature for the sensor's voltage V, to 0.01 degrees,
--  held inside Celsius's range
function Temperature (D : Diode_Sensor; V : Volts) return Celsius
  with Pre => Valid (D) and then V in 0.0 .. 5.0;
