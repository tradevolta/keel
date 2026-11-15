--  SPDX-License-Identifier: Apache-2.0
--  What the thermo-strip needs from a board: a 1-Wire bus and a
--  WS2812 strip, each with what its driver's signature asks for,
--  time, and a console. The body has its pins in its comments.
with Keel;
with Keel.OneWire;        use Keel.OneWire;
with Keel.Drivers.WS2812; use Keel.Drivers.WS2812;
with Keel.Time;           use Keel.Time;

package Board is
   --  Handles: the bus and the strip themselves are in the body
   type Bus is limited null record;
   type Strip is limited null record;

   --  The bus to the probes, and the LEDs
   Probes : Bus;
   LEDs   : Strip;

   --  Start the clocks, the time base, the console, the PIO block
   --  and both state machines. Stops the program, after a message,
   --  if any of them fails.
   procedure Initialize;

   --  Keel.OneWire.Bus_Signature
   procedure Reset
     (B : in out Bus; Present : out Boolean; Stat : out Status);
   procedure Touch
     (B : in out Bus; Bit : Boolean; Got : out Boolean;
      Stat : out Status);

   --  Keel.Drivers.WS2812.Strip_Signature
   procedure Put
     (S : in out Strip; Pixel : Pixel_Bits; Stat : out Keel.Status);
   procedure Latch (S : in out Strip; Stat : out Keel.Status);

   function Now return Time;
   procedure Wait_Until (Deadline : Time);

   procedure Put_Line (Text : String);
end Board;
