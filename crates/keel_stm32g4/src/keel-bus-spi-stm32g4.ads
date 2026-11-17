--  SPDX-License-Identifier: Apache-2.0
--  Keel.Bus.SPI on the STM32G474: SPI1 (RM0440 Rev 9, chapter 42) as
--  the bus controller on the NUCLEO's Arduino pins, D13 (PA5, SCK),
--  D12 (PA6, MISO) and D11 (PA7, MOSI), UM2505 8.3. The same model
--  as on the RP2350: a GPIO chip select per device, the arbiter in
--  Keel.Bus.SPI, 8-bit frames by the processor and 16-bit frames by
--  DMA. NSS is software-managed (SSM = SSI = 1), so the controller
--  never sees a mode fault from a pin it doesn't use. SPI1's clock is
--  PCLK2, which Keel leaves equal to SYSCLK, and its divider is a
--  power of two from 2 to 256.
with Keel.DMA;
with Keel.DMA.STM32G4;
with Keel.GPIO.STM32G4; use Keel.GPIO.STM32G4;

package Keel.Bus.SPI.STM32G4 is
   type Port_Id is (SPI1);

   --  Take PA5, PA6 and PA7 and start SPI1. Channel is the DMA1
   --  channel for streams; if Keel.DMA.STM32G4 is enabled, Open
   --  claims it. In_Use: a pin, or the channel, has another owner.
   procedure Open
     (P       : Port_Id;
      Stat    : out Status;
      Channel : Keel.DMA.STM32G4.Channel := 2)
     with Pre  => not Is_Open (P),
          Post => Is_Open (P) = (Stat = Ok);

   function Is_Open (P : Port_Id) return Boolean;
   function Reconfigurations (P : Port_Id) return Natural;

   --  A device on the port, with its chip select on pin CS_Pin of
   --  port CS_Port
   type Device
     (Port    : Port_Id;
      CS_Port : GPIO.STM32G4.Port_Id;
      CS_Pin  : Pin_Number)
   is limited private;

   procedure Attach
     (D : in out Device; Want : Settings; Stat : out Status)
     with Pre  => Is_Open (D.Port) and then not Is_Attached (D),
          Post => Is_Attached (D) = (Stat = Ok);

   function Is_Attached (D : Device) return Boolean;
   function Holds (D : Device) return Boolean;
   function Is_Streaming (D : Device) return Boolean;

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

   --  Not_Supported: From doesn't hold Count half-words, Count is
   --  over the channel's 65 535, or the DMA isn't enabled
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
   type Device
     (Port    : Port_Id;
      CS_Port : GPIO.STM32G4.Port_Id;
      CS_Pin  : Pin_Number)
   is limited record
      Select_Pin : Output_Pin (CS_Port, CS_Pin);
      Number     : Device_Number := 1;
      Want       : Settings;
      Shift      : Baud_Shift := 7;
      Attached   : Boolean := False;
      Streaming  : Boolean := False;
   end record;

   function Is_Attached (D : Device) return Boolean is (D.Attached);
   function Is_Streaming (D : Device) return Boolean is (D.Streaming);
end Keel.Bus.SPI.STM32G4;
