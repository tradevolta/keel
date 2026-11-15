--  SPDX-License-Identifier: Apache-2.0
--  A bus for the prover: what a 1-Wire bus and a WS2812 transport
--  promise, and no more. The bodies are never proved, and never run.
with Keel;
with Keel.OneWire;        use Keel.OneWire;
with Keel.Drivers.WS2812; use Keel.Drivers.WS2812;

package Model_Bus
  with SPARK_Mode
is
   type Bus is limited private;

   procedure Reset
     (B : in out Bus; Present : out Boolean; Stat : out Status)
     with Global => null;
   procedure Touch
     (B : in out Bus; Bit : Boolean; Got : out Boolean;
      Stat : out Status)
     with Global => null;
   procedure Put
     (B : in out Bus; Pixel : Pixel_Bits; Stat : out Keel.Status)
     with Global => null;
   procedure Latch (B : in out Bus; Stat : out Keel.Status)
     with Global => null;
private
   pragma SPARK_Mode (Off);
   type Bus is limited null record;
end Model_Bus;
