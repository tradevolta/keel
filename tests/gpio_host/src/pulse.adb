--  SPDX-License-Identifier: Apache-2.0
with Keel.GPIO; use Keel.GPIO;

procedure Pulse (P : in out Pins.Pin) is
begin
   Pins.Set (P, High);
   Pins.Set (P, Low);
end Pulse;
