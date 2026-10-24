Pin_Of : constant array (Lamp) of Pin :=
  [Red => 15, Amber => 14, Green => 13];

function Pins (Lamps : Lamp_Set) return Pin_Set is
  [for P in Pin =>
     (for some L in Lamp => Lamps (L) and then Pin_Of (L) = P)];

All_Lamps : constant Pin_Set := Pins ([others => True]);

--  clk_ref runs from the 12 MHz crystal (runtime startup); the
--  tick generator divides it down to one tick per microsecond.
Ref_Clock : constant Hertz := "12 MHz";
Tick_Rate : constant Hertz := "1 MHz";
