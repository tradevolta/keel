--  SPDX-License-Identifier: Apache-2.0
with Keel.GPIO.Debounce; use Keel.GPIO.Debounce;

package body Panel is

   Released : constant Level := Level_For (False, Buttons_Are);

   type Debouncers is array (Player) of Debouncer (Settle);
   Contacts : Debouncers;

   function Presses return Players is
      Raw     : constant array (Player) of Level :=
        [A => Button_Pins.Get (Button_A),
         B => Button_Pins.Get (Button_B)];
      Changed : Boolean;
      Result  : Players := Nobody;
   begin
      for P in Player loop
         Sample (Contacts (P), Raw (P), Changed);
         Result (P) :=
           Changed and then Is_Active (Stable (Contacts (P)),
                                       Buttons_Are);
      end loop;
      return Result;
   end Presses;

   procedure Show (L : Lamps) is
   begin
      Lamp_Pins.Set (Go_Lamp, Level_For (L.Go, Active_High));
      Lamp_Pins.Set (Lamp_A, Level_For (L.Winner (A), Active_High));
      Lamp_Pins.Set (Lamp_B, Level_For (L.Winner (B), Active_High));
   end Show;
begin
   for C of Contacts loop
      Reset (C, Released);
   end loop;
end Panel;
