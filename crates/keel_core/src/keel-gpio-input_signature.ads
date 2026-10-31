--  SPDX-License-Identifier: Apache-2.0
--  What a driver needs from an input pin: a pin type and its Get.
generic
   type Pin (<>) is limited private;
   with function Get (P : Pin) return Level is <>;
package Keel.GPIO.Input_Signature
  with Pure
is
   --  A signature only names things: nothing in it uses them.
   pragma Warnings (Off, Get);
end Keel.GPIO.Input_Signature;
