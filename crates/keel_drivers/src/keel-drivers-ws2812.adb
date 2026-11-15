--  SPDX-License-Identifier: Apache-2.0
package body Keel.Drivers.WS2812
  with SPARK_Mode
is
   function Blend
     (A, B : Colour; Step : Natural; Steps : Positive) return Colour
   is
      --  X moved Step / Steps of the way towards Y
      function Mix (X, Y : Intensity) return Intensity is
        (if X <= Y
         then X + Intensity (Natural (Y - X) * Step / Steps)
         else X - Intensity (Natural (X - Y) * Step / Steps))
        with Pre => Step <= Steps and then Steps <= 2**16;
   begin
      return (Red   => Mix (A.Red, B.Red),
              Green => Mix (A.Green, B.Green),
              Blue  => Mix (A.Blue, B.Blue));
   end Blend;

   procedure Show
     (S       : in out Transport.Strip;
      Colours : Colour_Array;
      Level   : Intensity;
      Stat    : out Status)
   is
   begin
      Stat := Ok;
      for C of Colours loop
         Transport.Put (S, GRB (Dimmed (C, Level)), Stat);
         exit when Stat /= Ok;
      end loop;
      if Stat = Ok then
         Transport.Latch (S, Stat);
      end if;
   end Show;
end Keel.Drivers.WS2812;
