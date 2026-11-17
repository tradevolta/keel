--  SPDX-License-Identifier: Apache-2.0
--  The display, as the dashboard sees it: start it, show a frame,
--  and say how the last frame went. Each board's body has the wiring,
--  the canvases and the way pixels reach the panel.
with Keel;      use Keel;
with Dashboard;

package Display is
   --  The bus, the panel's pins, its reset and its set-up commands.
   --  Not_Supported or In_Use from the SPI driver if they fail.
   procedure Initialize (Stat : out Status);
   function Is_Ready return Boolean;

   --  "ST7789 240x240 on SPI1, 25.000 MHz, two frames by DMA"
   function Name return String;

   --  Draw R and start sending it. Returns once the drawing is done
   --  and the panel has taken the previous frame: drawing one frame
   --  and sending the one before overlap.
   procedure Show (R : Dashboard.Readings)
     with Pre => Is_Ready;

   type Timing is record
      Frames    : Natural := 0;
      --  The last frame: drawing it, waiting for the frame before it
      --  to finish sending, and the time since the frame before
      Draw_Us   : Natural := 0;
      Wait_Us   : Natural := 0;
      Period_Us : Natural := 0;
   end record;
   function Last return Timing;

   --  Times the bus has been set up again for a device's settings
   function Reconfigurations return Natural;
end Display;
