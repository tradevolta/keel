--  SPDX-License-Identifier: Apache-2.0
package body Keel.Bus.UART
  with SPARK_Mode
is
   procedure Solve
     (L : Divider_Limits; Clock : Clock_Hz; Baud : Baud_Rate;
      D : out Divisor; Found : out Boolean)
   is
      S2 : constant Long_Long_Integer :=
        2 * Long_Long_Integer (L.Scale) * Long_Long_Integer (Clock);
      B  : constant Long_Long_Integer := Long_Long_Integer (Baud);
      N  : constant Long_Long_Integer := Nearest (L, Clock, Baud);
   begin
      --  N rounds S / B: 2 * B * N <= S2 + B < 2 * B * (N + 1)
      pragma Assert (S2 + B = N * (2 * B) + (S2 + B) mod (2 * B));
      pragma Assert (N * (2 * B) <= S2 + B
                     and then S2 + B < (N + 1) * (2 * B));
      if N in Long_Long_Integer (L.Min_Divisor)
              .. Long_Long_Integer (L.Max_Divisor)
      then
         D := Divisor (N);
         Found := True;
      else
         D := 0;
         Found := False;
      end if;
   end Solve;
end Keel.Bus.UART;
