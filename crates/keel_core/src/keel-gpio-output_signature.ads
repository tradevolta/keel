--  SPDX-License-Identifier: Apache-2.0
--  What a driver needs from an output pin, as a signature: a generic
--  with no body. Instantiating it names a pin type and its Set; a
--  driver generic takes the instance as a formal package. Nothing is
--  dispatched: every call is a direct call to the chip's Set.
generic
   type Pin (<>) is limited private;
   with procedure Set (P : in out Pin; To : Level) is <>;
package Keel.GPIO.Output_Signature
  with Pure
is
   --  A signature only names things: nothing in it uses them.
   pragma Warnings (Off, Set);
end Keel.GPIO.Output_Signature;
