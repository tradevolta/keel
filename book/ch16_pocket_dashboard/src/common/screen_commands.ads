--  SPDX-License-Identifier: Apache-2.0
--  The dashboard's own commands, beside Chapter 15's: "screen" shows
--  how the frames go and picks what the gauge follows, "time" sets
--  the clock. Update takes the readings for the next frame.
with Dashboard;

package Screen_Commands is
   procedure Register;

   --  The next frame's readings: the time of day, the gauge (eased
   --  towards the light sensor or the sweep), the temperature once a
   --  second, the history twice a second and the frame rate
   procedure Update (R : in out Dashboard.Readings);

   --  "screen pause" stops the frames until "screen run"
   function Running return Boolean;
end Screen_Commands;
