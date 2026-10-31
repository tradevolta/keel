--  SPDX-License-Identifier: Apache-2.0
--  An Output_Line made from any output signature instance. The line
--  refers to the pin, so the pin keeps its single owner.
with Keel.GPIO.Lines;
with Keel.GPIO.Output_Signature;

generic
   with package Pins is new Keel.GPIO.Output_Signature (<>);
package Keel.GPIO.Output_Adapter
  with Preelaborate
is
   type Line (Pin : not null access Pins.Pin) is
     limited new Lines.Output_Line with null record;

   overriding procedure Set (L : in out Line; To : Level);
end Keel.GPIO.Output_Adapter;
