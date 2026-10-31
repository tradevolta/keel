Go_Lamp  : Output_Pin (Port => A, Pin => 0);
Lamp_A   : Output_Pin (Port => A, Pin => 1);
Lamp_B   : Output_Pin (Port => A, Pin => 4);
Button_A : Input_Pin (Port => B, Pin => 0);
Button_B : Input_Pin (Port => C, Pin => 1);

--  The same three lines as on the Pico 2 W
package Lamp_Pins is new Keel.GPIO.Output_Signature (Output_Pin);
package Button_Pins is new Keel.GPIO.Input_Signature (Input_Pin);
package The_Panel is new Panel
  (Lamp_Pins, Button_Pins,
   Go_Lamp, Lamp_A, Lamp_B, Button_A, Button_B);
