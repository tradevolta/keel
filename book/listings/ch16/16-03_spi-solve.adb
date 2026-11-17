procedure Solve_Prescaled
  (Clock : Clock_Hz; Max : Bit_Rate; D : out Prescaled;
   Found : out Boolean)
is
   N : constant Positive := Needed (Clock, Max);
   P : Positive;
   R : Positive;
begin
   --  N rounds Clock / Max up: N * Max >= Clock
   pragma Assert
     (Clock + Max - 1 = N * Max + (Clock + Max - 1) mod Max);
   pragma Assert (Long_Long_Integer (N) * Long_Long_Integer (Max)
                  >= Long_Long_Integer (Clock));
   if N <= 254 then
      --  Every even divisor from 2 to 254 is a prescale alone
      P := (if N mod 2 = 0 then N else N + 1);
      D := (Prescale => P, Serial_Rate => 0);
      Found := True;
   elsif N <= 254 * 256 then
      --  The smallest even prescale with Prescale * 256 >= N, and
      --  then the rate that makes the product reach N
      P := 2 * ((N + 511) / 512);
      R := (N + P - 1) / P;
      pragma Assert (N + P - 1 = R * P + (N + P - 1) mod P);
      pragma Assert (R * P >= N);
      pragma Assert (R <= 256);
      D := (Prescale => P, Serial_Rate => R - 1);
      Found := True;
   else
      D := (others => <>);
      Found := False;
      return;
   end if;
   pragma Assert (Divisor (D) >= N);
end Solve_Prescaled;
