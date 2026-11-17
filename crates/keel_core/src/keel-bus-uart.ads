--  SPDX-License-Identifier: Apache-2.0
--  Keel.Bus.UART: asynchronous serial, the portable part. A frame's
--  format, the baud-rate divider as data with a proved solver, the
--  counts a driver keeps, and the signature a console provides. The
--  chip packages, Keel.Bus.UART.RP2350 (the PL011) and
--  Keel.Bus.UART.STM32G4 (LPUART1), drive the hardware.
package Keel.Bus.UART
  with Pure, SPARK_Mode
is
   --  The frame: a start bit, the data bits least significant first,
   --  an optional parity bit, one or two stop bits
   type Data_Bits is range 7 .. 8;
   type Parity is (None, Even, Odd);
   type Stop_Bits is range 1 .. 2;

   type Format is record
      Bits  : Data_Bits := 8;
      Check : Parity    := None;
      Stops : Stop_Bits := 1;
   end record;

   --  8N1: what nearly everything speaks
   Eight_N_One : constant Format := (others => <>);

   function Frame_Bits (F : Format) return Positive is
     (1 + Natural (F.Bits) + (if F.Check = None then 0 else 1)
      + Natural (F.Stops));

   subtype Baud_Rate is Positive range 300 .. 10_000_000;

   --  Characters a second, at most, on a busy line
   function Characters_Per_Second
     (B : Baud_Rate; F : Format) return Positive
   is (B / Frame_Bits (F));

   --  The baud-rate divider as data. A chip makes
   --  Baud = Clock * Scale / Divisor, with Divisor a whole number
   --  from Min_Divisor to Max_Divisor.
   type Divider_Limits is record
      Scale       : Positive range 1 .. 256;
      Min_Divisor : Positive range 1 .. 2**24;
      Max_Divisor : Positive range 1 .. 2**24;
   end record
     with Predicate => Min_Divisor <= Max_Divisor;

   subtype Clock_Hz is Positive range 1_000_000 .. 500_000_000;
   subtype Divisor is Natural range 0 .. 2**24;

   --  The divisor nearest Clock * Scale / Baud, halves rounded up
   function Nearest
     (L : Divider_Limits; Clock : Clock_Hz; Baud : Baud_Rate)
     return Long_Long_Integer
   is ((2 * Long_Long_Integer (L.Scale) * Long_Long_Integer (Clock)
        + Long_Long_Integer (Baud)) / (2 * Long_Long_Integer (Baud)));

   --  D is within half a step of exact: the rate it makes is as
   --  close to Baud as the divider allows
   function Within_Half_Step
     (L : Divider_Limits; Clock : Clock_Hz; Baud : Baud_Rate;
      D : Divisor) return Boolean
   is (2 * abs (Long_Long_Integer (L.Scale) * Long_Long_Integer (Clock)
                - Long_Long_Integer (D) * Long_Long_Integer (Baud))
       <= Long_Long_Integer (Baud));

   --  The divisor for Baud from Clock. Found is False if the nearest
   --  divisor is outside the divider's range: Clock is too slow, or
   --  too fast, for Baud.
   procedure Solve
     (L : Divider_Limits; Clock : Clock_Hz; Baud : Baud_Rate;
      D : out Divisor; Found : out Boolean)
     with Post =>
       (if Found
        then D in L.Min_Divisor .. L.Max_Divisor
             and then Within_Half_Step (L, Clock, Baud, D)
        else Nearest (L, Clock, Baud) not in
               Long_Long_Integer (L.Min_Divisor)
               .. Long_Long_Integer (L.Max_Divisor));

   --  The rate D really makes, to the nearest whole baud
   function Actual
     (L : Divider_Limits; Clock : Clock_Hz; D : Divisor)
     return Long_Long_Integer
   is ((Long_Long_Integer (L.Scale) * Long_Long_Integer (Clock)
        + Long_Long_Integer (D) / 2) / Long_Long_Integer (D))
     with Pre => D > 0;

   --  Its error against Baud, in parts per million, toward zero, for
   --  a divisor Solve found
   function Error_PPM
     (L : Divider_Limits; Clock : Clock_Hz; Baud : Baud_Rate;
      D : Divisor) return Long_Long_Integer
   is ((Long_Long_Integer (L.Scale) * Long_Long_Integer (Clock)
        - Long_Long_Integer (D) * Long_Long_Integer (Baud))
       * 1_000_000
       / (Long_Long_Integer (D) * Long_Long_Integer (Baud)))
     with Pre => D > 0 and then Within_Half_Step (L, Clock, Baud, D);

   --  How a driver moves characters, and what it counts
   --  Polled: the program waits on the FIFOs' flags. Interrupt: an
   --  interrupt handler fills and empties rings. DMA: the DMA writes
   --  received characters into a ring; sending is by interrupt.
   type Mode is (Polled, Interrupt, DMA);

   --  Counts since Open, each stopping at Natural'Last
   type Counts is record
      Received : Natural := 0;
      Sent     : Natural := 0;
      --  The hardware FIFO was full when a character arrived
      Overruns : Natural := 0;
      --  A stop bit was low, the parity was wrong, or the line was
      --  held low for a whole frame
      Framing  : Natural := 0;
      Parity   : Natural := 0;
      Breaks   : Natural := 0;
      --  The software ring was full: characters thrown away
      Dropped  : Natural := 0;
   end record;

   --  What a console provides: Keel.CLI and Keel.Log use only this
   generic
      --  Send Text. It may wait while there is no room for it.
      with procedure Write (Text : String);
      --  The next character received, if there is one. Never waits.
      with procedure Read (C : out Character; Got : out Boolean);
      --  Characters Write would take now without waiting
      with function Space return Natural;
   package Text_Signature is
      pragma Warnings (Off, Write);
      pragma Warnings (Off, Read);
      pragma Warnings (Off, Space);
   end Text_Signature;
end Keel.Bus.UART;
