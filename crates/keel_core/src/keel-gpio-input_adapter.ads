--  SPDX-License-Identifier: Apache-2.0
--  An Input_Line made from any input signature instance.
with Keel.GPIO.Lines;
with Keel.GPIO.Input_Signature;

generic
   with package Pins is new Keel.GPIO.Input_Signature (<>);
package Keel.GPIO.Input_Adapter
  with Preelaborate
is
   type Line (Pin : not null access Pins.Pin) is
     limited new Lines.Input_Line with null record;

   overriding function Get (L : Line) return Level is
     (Pins.Get (L.Pin.all));
end Keel.GPIO.Input_Adapter;
