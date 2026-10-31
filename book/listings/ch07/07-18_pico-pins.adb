--  The pins on the Pico 2 W's header. GP23, GP24, GP25 and GP29
--  are wired to the wireless chip, not to the header.
subtype Header_Pin is Pin_Id
  with Static_Predicate => Header_Pin in 0 .. 22 | 26 .. 28;

Go_Pin       : constant Header_Pin := 15;
Lamp_A_Pin   : constant Header_Pin := 14;
Lamp_B_Pin   : constant Header_Pin := 13;
Button_A_Pin : constant Header_Pin := 16;
Button_B_Pin : constant Header_Pin := 17;

Go_Lamp  : Output_Pin (Go_Pin);
Lamp_A   : Output_Pin (Lamp_A_Pin);
Lamp_B   : Output_Pin (Lamp_B_Pin);
Button_A : Input_Pin (Button_A_Pin);
Button_B : Input_Pin (Button_B_Pin);

package Lamp_Pins is new Keel.GPIO.Output_Signature (Output_Pin);
package Button_Pins is new Keel.GPIO.Input_Signature (Input_Pin);
package The_Panel is new Panel
  (Lamp_Pins, Button_Pins,
   Go_Lamp, Lamp_A, Lamp_B, Button_A, Button_B);
