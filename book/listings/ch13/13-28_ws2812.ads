type Intensity is mod 2**8;

type Colour is record
   Red, Green, Blue : Intensity := 0;
end record;

Black : constant Colour := (0, 0, 0);

type Colour_Array is array (Positive range <>) of Colour;

--  What an LED takes, as a number: green in bits 23 to 16, red,
--  then blue in bits 7 to 0
type Pixel_Bits is mod 2**24;

function GRB (C : Colour) return Pixel_Bits is
  (Pixel_Bits (C.Green) * 2**16 + Pixel_Bits (C.Red) * 2**8
   + Pixel_Bits (C.Blue));

--  C at Level / 255 of its brightness, rounded down
function Dimmed (C : Colour; Level : Intensity) return Colour is
  (Red   => Intensity (Natural (C.Red) * Natural (Level) / 255),
   Green => Intensity (Natural (C.Green) * Natural (Level) / 255),
   Blue  => Intensity (Natural (C.Blue) * Natural (Level) / 255));

--  Step / Steps of the way from A to B, each channel rounded
--  towards A's: A at 0, B at Steps
function Blend
  (A, B : Colour; Step : Natural; Steps : Positive) return Colour
  with Pre => Step <= Steps and then Steps <= 2**16;

--  The low time that latches the chain, in microseconds. The
--  first WS2812 asked for 50 us, later WS2812B parts for 280 us.
Reset_Time : constant Keel.Time.Time_Span := 300;

--  What a transport provides: Put sends one pixel's bits, and
--  Latch waits for the last to go, then holds the line low for
--  the reset time
generic
   type Strip (<>) is limited private;
   with procedure Put
     (S : in out Strip; Pixel : Pixel_Bits; Stat : out Status);
   with procedure Latch (S : in out Strip; Stat : out Status);
package Strip_Signature is
   pragma Warnings (Off, Put);
   pragma Warnings (Off, Latch);
end Strip_Signature;

--  Show Colours on a strip, at Level of full brightness
generic
   with package Transport is new Strip_Signature (<>);
procedure Show
  (S       : in out Transport.Strip;
   Colours : Colour_Array;
   Level   : Intensity;
   Stat    : out Status);
