--  SPDX-License-Identifier: Apache-2.0
--  Keel.GPIO: the types every chip's GPIO shares. A chip package
--  (Keel.GPIO.RP2350, Keel.GPIO.STM32G4, the host's Keel.GPIO.Fake)
--  provides the pins; drivers see them through the signatures in
--  Keel.GPIO.Output_Signature and Keel.GPIO.Input_Signature.
package Keel.GPIO
  with Pure, SPARK_Mode
is
   type Level is (Low, High);

   --  What holds an input when nothing drives it
   type Pull is (Floating, Pull_Up, Pull_Down);

   --  How fast an output's edges are. Slow edges ring less.
   type Slew_Rate is (Slow, Fast);

   type Output_Config is record
      --  Initial is driven from the first moment
      Initial : Level := Low;
      Slew : Slew_Rate := Slow;
   end record;

   type Input_Config is record
      Bias : Pull := Floating;
   end record;

   --  Pressed or lit: what Level means for a part wired to the pin.
   --  A button to GND with a pull-up reads Low when pressed.
   type Polarity is (Active_High, Active_Low);

   function Is_Active (L : Level; P : Polarity) return Boolean is
     (L = (if P = Active_High then High else Low));

   function Level_For (Active : Boolean; P : Polarity) return Level is
     (if Active = (P = Active_High) then High else Low);
end Keel.GPIO;
