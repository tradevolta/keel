--  SPDX-License-Identifier: Apache-2.0
--  Keel.Bus.SPI: the synchronous serial bus, the portable part. The
--  clock modes, a device's settings, the two chips' clock dividers
--  with proved solvers, the bus arbiter that hands the bus to one
--  device at a time, and the signature a device driver is written
--  against. The chip packages, Keel.Bus.SPI.RP2350 (the PL022s) and
--  Keel.Bus.SPI.STM32G4 (SPI1), drive the hardware.
with Interfaces;
with Keel.DMA;

package Keel.Bus.SPI
  with Pure, SPARK_Mode
is
   subtype Byte is Interfaces.Unsigned_8;
   type Byte_Array is array (Natural range <>) of Byte;

   --  The four clock modes. CPOL, the clock's level between frames,
   --  is high in modes 2 and 3; CPHA, which edge samples the data,
   --  is the second edge of each bit in modes 1 and 3.
   type Clock_Mode is range 0 .. 3;
   function Idles_High (M : Clock_Mode) return Boolean is (M >= 2);
   function Samples_Second_Edge (M : Clock_Mode) return Boolean is
     (M mod 2 = 1);

   subtype Bit_Rate is Positive range 1_000 .. 100_000_000;
   subtype Clock_Hz is Positive range 1_000_000 .. 500_000_000;

   --  What a device asks of the bus: its clock mode, and the fastest
   --  clock it takes. A driver runs the bus at that rate or slower,
   --  never faster.
   type Settings is record
      Mode     : Clock_Mode := 0;
      Max_Rate : Bit_Rate   := 1_000_000;
   end record;

   --  The smallest whole divisor of Clock that doesn't exceed Max
   function Needed (Clock : Clock_Hz; Max : Bit_Rate) return Positive
   is ((Clock + Max - 1) / Max)
     with Post => Needed'Result <= Clock;

   --  Divisor D is slow enough: Clock / D <= Max
   function Slow_Enough
     (Clock : Clock_Hz; Max : Bit_Rate; D : Positive) return Boolean
   is (Long_Long_Integer (D) * Long_Long_Integer (Max)
       >= Long_Long_Integer (Clock));

   --  The rate divisor D makes, in Hz, rounded down
   function Rate (Clock : Clock_Hz; D : Positive) return Natural is
     (Clock / D);

   --  RP2350 PL022: Rate = Clock / (Prescale * (1 + Serial_Rate)),
   --  Prescale (CPSDVSR) even from 2 to 254, Serial_Rate (SCR) from
   --  0 to 255 (datasheet 12.3.4.6.1)
   type Prescaled is record
      Prescale    : Positive range 2 .. 254 := 2;
      Serial_Rate : Natural range 0 .. 255  := 0;
   end record
     with Predicate => Prescale mod 2 = 0;

   function Divisor (D : Prescaled) return Positive is
     (D.Prescale * (D.Serial_Rate + 1));

   --  The PL022 divider for at most Max from Clock. Up to a needed
   --  divisor of 254, every even divisor is there, so the one found
   --  is the fastest; above, it is within one prescale step of it.
   --  Found is False if even 254 * 256 is too fast.
   procedure Solve_Prescaled
     (Clock : Clock_Hz; Max : Bit_Rate; D : out Prescaled;
      Found : out Boolean)
     with Post =>
       (if Found
        then Slow_Enough (Clock, Max, Divisor (D))
             and then (if Needed (Clock, Max) <= 254
                       then Divisor (D) <= Needed (Clock, Max) + 1)
        else Needed (Clock, Max) > 254 * 256);

   --  STM32G4 SPI: Rate = PCLK / 2**(BR + 1), BR from 0 to 7
   --  (RM0440 Rev 9, 42.9.1)
   subtype Baud_Shift is Natural range 0 .. 7;

   function Divisor (BR : Baud_Shift) return Positive is
     (2**(BR + 1));

   --  The fastest power-of-two divider for at most Max from Clock.
   --  Found is False if even 256 is too fast.
   procedure Solve_Power_Of_Two
     (Clock : Clock_Hz; Max : Bit_Rate; BR : out Baud_Shift;
      Found : out Boolean)
     with Post =>
       (if Found
        then Slow_Enough (Clock, Max, Divisor (BR))
             and then (BR = 0 or else 2**BR < Needed (Clock, Max))
        else Needed (Clock, Max) > 256);

   --  Sharing a bus. Each device on a bus has a number; the bus has
   --  at most one holder, and remembers the settings it was last set
   --  up for, so that a device that takes the bus after itself, or
   --  after a device with the same settings, costs no reconfiguring.
   type Device_Number is range 1 .. 8;
   type Holder is range 0 .. 8;
   Nobody : constant Holder := 0;

   type Bus_State is record
      Owner      : Holder   := Nobody;
      Configured : Boolean  := False;
      Current    : Settings := (others => <>);
   end record;

   --  Who takes a free bus for Want. Reconfigure says whether the
   --  hardware must be set up again first. In_Use: another device
   --  holds the bus, and nothing changes.
   procedure Acquire
     (B           : in out Bus_State;
      Who         : Device_Number;
      Want        : Settings;
      Reconfigure : out Boolean;
      Stat        : out Status)
     with Pre  => B.Owner /= Holder (Who),
          Post =>
            (if B.Owner'Old = Nobody
             then Stat = Ok and then B.Owner = Holder (Who)
                  and then B.Configured and then B.Current = Want
                  and then Reconfigure =
                    (not B.Configured'Old or else B.Current'Old /= Want)
             else Stat = In_Use and then B = B'Old
                  and then not Reconfigure);

   --  Who gives the bus back; its settings stay in the hardware
   procedure Release (B : in out Bus_State; Who : Device_Number)
     with Pre  => B.Owner = Holder (Who),
          Post => B.Owner = Nobody
                  and then B.Configured = B.Configured'Old
                  and then B.Current = B.Current'Old;

   --  What a device driver needs from a device on a bus. Acquire
   --  takes the bus for the device, sets it up for the device's
   --  settings if it must, and drives the device's chip select low;
   --  In_Use if another device holds it. Release drives the chip
   --  select high and frees the bus. Write sends bytes, 8-bit frames,
   --  and returns when the last has gone; Exchange sends Data and
   --  replaces it with what came back. Start_Stream starts the DMA
   --  sending Count 16-bit frames from From, most significant bit
   --  first, and returns at once; Finish_Stream waits for the last
   --  frame to leave and hands back the receipt for From.
   generic
      type Device (<>) is limited private;
      with procedure Acquire (D : in out Device; Stat : out Status);
      with procedure Release (D : in out Device);
      with procedure Write (D : in out Device; Data : Byte_Array);
      with procedure Exchange
        (D : in out Device; Data : in out Byte_Array);
      with procedure Start_Stream
        (D     : in out Device;
         From  : Keel.DMA.Region;
         Count : Positive;
         Stat  : out Status);
      with procedure Finish_Stream
        (D : in out Device; Done : out Keel.DMA.Receipt);
   package Device_Signature is
      pragma Warnings (Off, Acquire);
      pragma Warnings (Off, Release);
      pragma Warnings (Off, Write);
      pragma Warnings (Off, Exchange);
      pragma Warnings (Off, Start_Stream);
      pragma Warnings (Off, Finish_Stream);
   end Device_Signature;
end Keel.Bus.SPI;
