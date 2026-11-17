--  SPDX-License-Identifier: Apache-2.0
--  Keel.Bus.SPI on the RP2350: its two PL022 controllers (datasheet
--  12.3) as bus controllers, Motorola format, 8-bit frames, and
--  16-bit frames sent by DMA. A device's chip select is a GPIO pin of
--  its own, not the controller's SSPFSSOUT: with SPH = 0 the PL022
--  raises SSPFSSOUT between any two frames (12.3.4.10), and a
--  display wants it low for a whole transfer. Devices share a port
--  through Keel.Bus.SPI's arbiter: one holds it at a time, and the
--  port is set up again only for a device with other settings.
with Keel.DMA;
with Keel.DMA.RP2350;
with Keel.GPIO.RP2350; use Keel.GPIO.RP2350;

package Keel.Bus.SPI.RP2350 is
   type Port_Id is (SPI0, SPI1);

   --  The pins with the SPI as function 1 (datasheet 9.4, Table 677).
   --  GP23 to GP25 and GP29 drive the Pico 2 W's radio, not a pin.
   function Valid_Pins (P : Port_Id; SCK, TX, RX : Pin_Id)
     return Boolean is
     (case P is
         when SPI0 =>
            SCK in 2 | 6 | 18 | 22 and then TX in 3 | 7 | 19 | 23
            and then RX in 0 | 4 | 16 | 20,
         when SPI1 =>
            SCK in 10 | 14 | 26 and then TX in 11 | 15 | 27
            and then RX in 8 | 12 | 24 | 28);

   --  Take P's pins and start it, from clk_peri (started here if it
   --  isn't running). Channel is the DMA channel for streams; if
   --  Keel.DMA.RP2350 is enabled, Open claims it. In_Use: a pin, or
   --  the channel, has another owner.
   procedure Open
     (P           : Port_Id;
      SCK, TX, RX : Pin_Id;
      Stat        : out Status;
      Channel     : Keel.DMA.RP2350.Channel := 9)
     with Pre  => Keel.GPIO.RP2350.Is_Enabled
                  and then not Is_Open (P)
                  and then Valid_Pins (P, SCK, TX, RX),
          Post => Is_Open (P) = (Stat = Ok);

   function Is_Open (P : Port_Id) return Boolean;

   --  Times P has been set up again for a device's settings
   function Reconfigurations (P : Port_Id) return Natural;

   --  A device on a port, with its chip select on pin CS
   type Device (Port : Port_Id; CS : Pin_Id) is limited private;

   --  Put D on its port with Want: claim CS, high, and find the
   --  divider for at most Want.Max_Rate. Not_Supported: clk_peri is
   --  too fast for even the largest divider, or the port has eight
   --  devices. In_Use: CS has another owner.
   procedure Attach
     (D : in out Device; Want : Settings; Stat : out Status)
     with Pre  => Is_Open (D.Port) and then not Is_Attached (D),
          Post => Is_Attached (D) = (Stat = Ok);

   function Is_Attached (D : Device) return Boolean;
   --  D holds its port
   function Holds (D : Device) return Boolean;
   --  A stream from D is on its way
   function Is_Streaming (D : Device) return Boolean;

   --  The rate D's divider gives, in Hz, rounded down
   function Rate_Of (D : Device) return Natural
     with Pre => Is_Attached (D);

   --  The operations of Keel.Bus.SPI.Device_Signature, for a board
   --  to instantiate it with. Acquire says In_Use if another device
   --  holds the port.
   procedure Acquire (D : in out Device; Stat : out Status)
     with Pre  => Is_Attached (D) and then not Holds (D),
          Post => Holds (D) = (Stat = Ok);

   procedure Release (D : in out Device)
     with Pre  => Holds (D) and then not Is_Streaming (D),
          Post => not Holds (D);

   procedure Write (D : in out Device; Data : Byte_Array)
     with Pre => Holds (D) and then not Is_Streaming (D);

   procedure Exchange (D : in out Device; Data : in out Byte_Array)
     with Pre => Holds (D) and then not Is_Streaming (D);

   --  Count 16-bit frames from From, by the port's DMA channel, paced
   --  by the port's DREQ. Not_Supported: From doesn't hold Count
   --  half-words, or the DMA isn't enabled.
   procedure Start_Stream
     (D     : in out Device;
      From  : Keel.DMA.Region;
      Count : Positive;
      Stat  : out Status)
     with Pre  => Holds (D) and then not Is_Streaming (D),
          Post => Holds (D) and then Is_Streaming (D) = (Stat = Ok);

   procedure Finish_Stream
     (D : in out Device; Done : out Keel.DMA.Receipt)
     with Pre  => Holds (D) and then Is_Streaming (D),
          Post => Holds (D) and then not Is_Streaming (D);
private
   type Device (Port : Port_Id; CS : Pin_Id) is limited record
      Select_Pin : Output_Pin (CS);
      Number     : Device_Number := 1;
      Want       : Settings;
      Divider    : Prescaled;
      Attached   : Boolean := False;
      Streaming  : Boolean := False;
   end record;

   function Is_Attached (D : Device) return Boolean is (D.Attached);
   function Is_Streaming (D : Device) return Boolean is (D.Streaming);
end Keel.Bus.SPI.RP2350;
