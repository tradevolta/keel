--  SPDX-License-Identifier: Apache-2.0
--  Keel.Bus.SPI on the host: one simulated bus with devices on it,
--  the API of Keel.Bus.SPI.RP2350 over Keel.GPIO.Fake chip selects.
--  The arbiter is the real one. A test plays the devices: every
--  frame the controller sends goes to the Listener, with the number
--  of the device whose chip select is low, and Exchange reads each
--  reply from the Responder. The bus keeps time as the hardware
--  would spend it, from the bits sent and each device's rate: a
--  computed figure, not a measurement.
with Keel.DMA;
with Keel.GPIO.Fake; use Keel.GPIO.Fake;

package Keel.Bus.SPI.Fake is
   --  The controller's clock, as clk_peri on the RP2350: the PL022
   --  divider is solved against it
   Bus_Clock : constant Clock_Hz := 150_000_000;

   type Listener is access procedure
     (Who : Device_Number; Frame : Natural; Bits : Positive);
   type Responder is access function
     (Who : Device_Number; Sent : Byte) return Byte;

   --  Where frames go; null: nowhere
   procedure Listen (To : Listener);
   --  Where replies come from; null: 0xFF, an undriven line
   procedure Respond (From : Responder);

   type Device (CS : Pin_Id) is limited private;

   procedure Attach
     (D : in out Device; Want : Settings; Stat : out Status)
     with Pre  => not Is_Attached (D),
          Post => Is_Attached (D) = (Stat = Ok);

   function Is_Attached (D : Device) return Boolean;
   function Holds (D : Device) return Boolean;
   function Is_Streaming (D : Device) return Boolean;
   function Number_Of (D : Device) return Device_Number
     with Pre => Is_Attached (D);
   function Rate_Of (D : Device) return Natural
     with Pre => Is_Attached (D);

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
   --  The whole stream goes to the Listener here, at once, through
   --  Keel.DMA.Fake; Finish_Stream hands back its receipt
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

   --  What the bus has done since Reset_Bus
   type Counts is record
      Frames           : Natural := 0;
      Bits             : Long_Long_Integer := 0;
      Acquisitions     : Natural := 0;
      Reconfigurations : Natural := 0;
      Refusals         : Natural := 0;
      --  The bus's busy time at each device's rate, in nanoseconds
      Busy_ns          : Long_Long_Integer := 0;
   end record;
   function Statistics return Counts;

   --  No devices, no holder, counts at zero; the GPIO fake too
   procedure Reset_Bus;
private
   type Device (CS : Pin_Id) is limited record
      Select_Pin : Output_Pin (CS);
      Number     : Device_Number := 1;
      Want       : Settings;
      Divider    : Prescaled;
      Attached   : Boolean := False;
      Streaming  : Boolean := False;
      Pending    : Keel.DMA.Receipt;
   end record;

   function Is_Attached (D : Device) return Boolean is (D.Attached);
   function Is_Streaming (D : Device) return Boolean is (D.Streaming);
   function Number_Of (D : Device) return Device_Number is (D.Number);
end Keel.Bus.SPI.Fake;
