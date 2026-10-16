--  SPDX-License-Identifier: Apache-2.0
--  Three mistakes the compiler catches. Not part of the build.
with Units; use Units;

procedure Mix is
   V : constant Milli_Volts := 1_200;
   I : constant Milli_Amps  := 20;
   R : Natural;
   C : constant Channel := AIN2;
   P : constant Header_Pin := 25;  --  GP25 is not on the header
begin
   R := V / I;  --  volts / amps: no such "/"
   R := Natural (V) / Natural (I);  --  explicit conversion: fine
   case C is  --  Temp_Sensor not covered
      when AIN0 .. AIN3 => R := R + 1;
   end case;
end Mix;
