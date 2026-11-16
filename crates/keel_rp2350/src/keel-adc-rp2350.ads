--  SPDX-License-Identifier: Apache-2.0
--  Keel.ADC on the RP2350 (QFN-60): one 12-bit SAR converter with
--  five inputs, GPIO26 to GPIO29 and the temperature sensor. Read
--  converts one input once; Capture fills an array from one or more
--  inputs in turn, round robin, through the 8-sample FIFO. clk_adc
--  must run at 48 MHz first (Keel.Clock.RP2350.Start_ADC_Clock).
with Keel.ADC.Chip_Limits;
with Keel.DMA;
with Keel.GPIO.RP2350;
with Keel.Units; use Keel.Units;

package Keel.ADC.RP2350
  with Preelaborate
is
   --  12 bits, 3.3 V, and the sensor's typical line
   Converter : Scale renames Chip_Limits.RP2350_ADC;
   Sensor    : Diode_Sensor renames Chip_Limits.RP2350_Sensor;

   --  AINSEL: 0 to 3 are GPIO26 to GPIO29, 4 is the sensor
   --  (datasheet 12.4.2.1, Table 1171)
   type Channel is range 0 .. 4;
   Temperature_Sensor : constant Channel := 4;
   subtype Pin_Channel is Channel range 0 .. 3;

   function Pin_Of (Ch : Pin_Channel) return Keel.GPIO.RP2350.Pin_Id is
     (Keel.GPIO.RP2350.Pin_Id (26 + Natural (Ch)));

   --  Take the ADC out of reset and power it up. Timeout: it never
   --  reported READY (is clk_adc running?).
   procedure Enable (Stat : out Status)
     with Post => Is_Enabled = (Stat = Ok);
   function Is_Enabled return Boolean;

   --  Power the ADC and the sensor's bias down, between readings.
   --  Claims stay; Enable powers both up again.
   procedure Disable
     with Pre  => not Is_Streaming,
          Post => not Is_Enabled;

   --  Make Ch an input: a pin goes to the ADC, with its digital
   --  pad off, or the sensor's bias current turns on. In_Use: the
   --  pin has another owner.
   procedure Claim (Ch : Channel; Stat : out Status)
     with Pre  => Is_Enabled and then Keel.GPIO.RP2350.Is_Enabled
                  and then not Is_Claimed (Ch),
          Post => Is_Claimed (Ch) = (Stat = Ok);
   function Is_Claimed (Ch : Channel) return Boolean;

   --  Convert Ch once: 96 cycles of clk_adc, 2 us. A conversion
   --  that didn't converge (CS.ERR) is tried again, up to three
   --  times. Timeout: no good result.
   procedure Read (Ch : Channel; Value : out Code; Stat : out Status)
     with Pre  => Is_Enabled and then Is_Claimed (Ch),
          Post => Value <= Top (Converter);

   type Channel_Set is array (Channel) of Boolean;
   type Sample_Array is array (Positive range <>) of Code;

   --  The fastest and slowest Capture rates, in conversions a
   --  second: 48 MHz / 96 and 48 MHz / 65 536
   Fastest : constant Hertz := 500_000.0;
   Slowest : constant Hertz := 733.0;

   --  Fill Samples with conversions of the inputs in Inputs, in
   --  turn from the lowest, at Rate conversions a second in all:
   --  with inputs 0 and 3, Samples holds 0, 3, 0, 3 ... A sample
   --  that didn't converge is replaced by the one before it from
   --  the same input, and counted in Errors. Not_Supported: Rate
   --  is out of range. Timeout: the FIFO overflowed or stalled,
   --  and samples were lost.
   procedure Capture
     (Inputs : Channel_Set; Rate : Hertz; Samples : out Sample_Array;
      Errors : out Natural; Stat : out Status)
     with Pre  => Is_Enabled
                  and then (for some Ch in Channel => Inputs (Ch))
                  and then (for all Ch in Channel =>
                              (if Inputs (Ch) then Is_Claimed (Ch))),
          Post => (for all S of Samples => S <= Top (Converter));

   --  Streaming, for the DMA. Start_Stream converts Inputs at Rate
   --  as Capture does, but leaves the FIFO to a DMA channel paced by
   --  Keel.DMA.RP2350.ADC_Request: start that channel first. The
   --  DMA reads each sample as 16 bits, the code in bits 0 to 11 and
   --  the error flag in bit 15 (datasheet 12.4.3.5). Not_Supported:
   --  Rate is out of range. Timeout: the ADC isn't ready.
   procedure Start_Stream
     (Inputs : Channel_Set; Rate : Hertz; Stat : out Status)
     with Pre  => Is_Enabled
                  and then (for some Ch in Channel => Inputs (Ch))
                  and then (for all Ch in Channel =>
                              (if Inputs (Ch) then Is_Claimed (Ch))),
          Post => Is_Streaming = (Stat = Ok);
   function Is_Streaming return Boolean;

   --  Stop converting, let the last conversion finish, and empty the
   --  FIFO. Lost: it overflowed at some point, because the DMA
   --  didn't keep up, and samples are missing.
   procedure Stop_Stream (Lost : out Boolean)
     with Post => not Is_Streaming;

   --  The FIFO, as a transfer's From end
   function FIFO return Keel.DMA.Region;
end Keel.ADC.RP2350;
