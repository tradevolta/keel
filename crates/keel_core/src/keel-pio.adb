--  SPDX-License-Identifier: Apache-2.0
package body Keel.PIO
  with SPARK_Mode
is
   function Divider_For (Clock, Rate : Positive) return Divider is
      --  In 256ths: Clock * 256 is more than Integer holds
      Steps : constant Long_Long_Integer :=
        Long_Long_Integer (Clock) * 256 / Long_Long_Integer (Rate);
   begin
      return (Int  => Positive (Steps / 256),
              Frac => Natural (Steps mod 256));
   end Divider_For;
end Keel.PIO;
