--  SPDX-License-Identifier: Apache-2.0
package body Keel.Bus.SPI
  with SPARK_Mode
is
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

   procedure Solve_Power_Of_Two
     (Clock : Clock_Hz; Max : Bit_Rate; BR : out Baud_Shift;
      Found : out Boolean)
   is
      N : constant Positive := Needed (Clock, Max);
   begin
      pragma Assert
        (Clock + Max - 1 = N * Max + (Clock + Max - 1) mod Max);
      pragma Assert (Long_Long_Integer (N) * Long_Long_Integer (Max)
                     >= Long_Long_Integer (Clock));
      BR := 0;
      Found := False;
      for Shift in Baud_Shift loop
         pragma Loop_Invariant
           (not Found and then (Shift = 0 or else 2**Shift < N));
         if 2**(Shift + 1) >= N then
            pragma Assert
              (Long_Long_Integer (Divisor (Shift))
               * Long_Long_Integer (Max)
               >= Long_Long_Integer (N) * Long_Long_Integer (Max));
            BR := Shift;
            Found := True;
            exit;
         end if;
      end loop;
   end Solve_Power_Of_Two;

   procedure Acquire
     (B           : in out Bus_State;
      Who         : Device_Number;
      Want        : Settings;
      Reconfigure : out Boolean;
      Stat        : out Status)
   is
   begin
      if B.Owner /= Nobody then
         Reconfigure := False;
         Stat := In_Use;
         return;
      end if;
      Reconfigure := not B.Configured or else B.Current /= Want;
      B := (Owner => Holder (Who), Configured => True, Current => Want);
      Stat := Ok;
   end Acquire;

   procedure Release (B : in out Bus_State; Who : Device_Number) is
      pragma Unreferenced (Who);
   begin
      B.Owner := Nobody;
   end Release;
end Keel.Bus.SPI;
