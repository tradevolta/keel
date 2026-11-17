--  SPDX-License-Identifier: Apache-2.0
--  The pocket dashboard: what it shows, and how the gauge moves.
--  Dashboard.Painter draws it; the boards decide where the pixels
--  go and how fast.
package Dashboard is
   subtype Per_Mille is Natural range 0 .. 1_000;

   --  What the gauge follows: the light sensor on the Pico, or a
   --  sweep from 0 to 1 000 and back, every four seconds
   type Gauge_Source is (Light, Sweep);

   History_Length : constant := 48;
   type History is array (1 .. History_Length) of Per_Mille;

   type Readings is record
      --  Time of day, in seconds since midnight
      Seconds    : Natural range 0 .. 86_399 := 0;
      --  The chip's temperature in hundredths of a degree, if known
      Has_Temp   : Boolean := False;
      Centi_C    : Integer := 0;
      Source     : Gauge_Source := Sweep;
      --  Where the needle is now, eased towards the reading
      Needle     : Per_Mille := 0;
      --  The last reading itself, and the last 48, oldest first
      Reading    : Per_Mille := 0;
      Past       : History := [others => 0];
      --  Frames a second, in tenths; 0: not counted yet
      FPS_Tenths : Natural := 0;
   end record;

   --  A quarter of the way from Now to Target, at least one step:
   --  the needle eases in and never overshoots
   function Ease (Now, Target : Per_Mille) return Per_Mille is
     (if Now < Target then Now + Natural'Max (1, (Target - Now) / 4)
      elsif Now > Target then Now - Natural'Max (1, (Now - Target) / 4)
      else Now);

   --  The sweep at Ms milliseconds: up for two seconds, down for two
   function Sweep_At (Ms : Natural) return Per_Mille is
     (if Ms mod 4_000 < 2_000 then Ms mod 4_000 / 2
      else 1_000 - (Ms mod 4_000 - 2_000) / 2);

   --  Shift Value into the history, dropping the oldest
   procedure Record_Reading (R : in out Readings; Value : Per_Mille);

   --  "12:34:56"
   function Clock_Image (Seconds : Natural) return String;
   --  "27.4 C", "-3.0 C"; "n/a" without a sensor
   function Temperature_Image (R : Readings) return String;
   --  "25.000 MHz", for the bus rate
   function MHz_Image (Hz : Natural) return String;
   --  "27.5 fps"; "-- fps" before the first second is counted
   function FPS_Image (Tenths : Natural) return String;
end Dashboard;
