--  SPDX-License-Identifier: Apache-2.0
package body Keel.GPIO.Output_Adapter is
   overriding procedure Set (L : in out Line; To : Level) is
   begin
      Pins.Set (L.Pin.all, To);
   end Set;
end Keel.GPIO.Output_Adapter;
