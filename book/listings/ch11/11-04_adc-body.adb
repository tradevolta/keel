function Oversample (S : Scale; Total : Natural; K : Extra_Bits)
  return Code is
  (Natural'Min (Total / Two_To (K), Top (S, K)));

function Mean (S : Scale; Total : Natural; N : Sample_Count)
  return Code
is
   T : constant Wide := Wide (Total);
   Nearest : constant Wide := (2 * T + Wide (N)) / (2 * Wide (N));
begin
   return Code (Wide'Min (Nearest, Wide (Top (S))));
end Mean;

function To_Volts (S : Scale; Value : Code; K : Extra_Bits := 0)
  return Volts
is
   Steps : constant Wide := Wide (Two_To (S.Bits + K));
   Ref   : constant Wide := Millivolts (S.Reference);
   Mv    : Wide;
begin
   pragma Assert (Ref in 500 .. 5_000);
   Mv := (2 * Wide (Value) * Ref * Wide (S.Divider) + Steps)
           / (2 * Steps);
   return Volts'(0.001) * Integer (Wide'Min (Mv, 100_000));
end To_Volts;
