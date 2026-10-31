--  SPDX-License-Identifier: Apache-2.0
--  The game's buttons and lamps, written once against the Keel.GPIO
--  signatures. A board instantiates it with its own chip's pins:
--  this unit names no chip.
with Keel.GPIO;                 use Keel.GPIO;
with Keel.GPIO.Input_Signature;
with Keel.GPIO.Output_Signature;
with Game;                      use Game;

generic
   with package Lamp_Pins is new Keel.GPIO.Output_Signature (<>);
   with package Button_Pins is new Keel.GPIO.Input_Signature (<>);
   Go_Lamp    : in out Lamp_Pins.Pin;
   Lamp_A     : in out Lamp_Pins.Pin;
   Lamp_B     : in out Lamp_Pins.Pin;
   Button_A   : in out Button_Pins.Pin;
   Button_B   : in out Button_Pins.Pin;
   --  A button to ground with a pull-up reads Low when pressed
   Buttons_Are : Polarity := Active_Low;
   --  Samples in a row before a change counts (1 ms each)
   Settle : Positive := 5;
package Panel is

   --  Sample both buttons once: call it once per millisecond. The
   --  result holds the players whose button has just gone down.
   function Presses return Players;

   procedure Show (L : Lamps);
end Panel;
