--  SPDX-License-Identifier: Apache-2.0
--  Two pin mistakes, both rejected when this unit compiles.
with Keel.GPIO.RP2350; use Keel.GPIO.RP2350;

procedure Wrong_Pins is
   subtype Header_Pin is Pin_Id
     with Static_Predicate => Header_Pin in 0 .. 22 | 26 .. 28;

   --  GP25 drives the wireless chip on the Pico 2 W, not a header pin
   Led_Pin : constant Header_Pin := 25;

   Led  : Output_Pin (15);
   --  A second handle on GP15, made by copying the first
   Copy : Output_Pin (15) := Led;
begin
   null;
end Wrong_Pins;
