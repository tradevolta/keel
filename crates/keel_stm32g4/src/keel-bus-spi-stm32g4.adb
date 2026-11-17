--  SPDX-License-Identifier: Apache-2.0
with Interfaces;          use Interfaces;
with Keel.Clock;
with Keel.Clock.STM32G4;
with Keel.DMA.STM32G4;    use Keel.DMA.STM32G4;
with Keel.GPIO;
with STM32G4_SVD;         use STM32G4_SVD;
with STM32G4_SVD.RCC;     use STM32G4_SVD.RCC;
with STM32G4_SVD.SPI;     use STM32G4_SVD.SPI;

package body Keel.Bus.SPI.STM32G4 is
   --  One port: the P parameters name it, and are otherwise unused
   pragma Warnings (Off, "formal parameter ""P"" is not referenced");
   --  Write and Exchange send for whichever device holds the bus
   pragma Warnings (Off, "formal parameter ""D"" is not referenced");

   --  PA5, PA6 and PA7 as SPI1's SCK, MISO and MOSI: alternate
   --  function 5 (STM32CubeG4, stm32g4xx_hal_gpio_ex.h)
   SPI_AF : constant Alternate_Function := 5;

   R : SPI_Peripheral renames SPI1_Periph;

   --  DR, one byte wide. The generated DR_Register is a full 32-bit
   --  access, and an access to DR wider than a frame of up to 8 bits
   --  moves two frames (RM0440 Rev 9, 42.5.9, "Data packing"), so
   --  8-bit frames go through this view.
   DR8 : Unsigned_8
     with Volatile, Import, Address => SPI1_Periph.DR'Address;

   --  CR2.DS: frame size minus one (42.9.2)
   Eight_Bits   : constant CR2_DS_Field := 2#0111#;
   Sixteen_Bits : constant CR2_DS_Field := 2#1111#;

   Opened   : Boolean := False;
   Clock    : Clock_Hz := 16_000_000;
   Chan     : Keel.DMA.STM32G4.Channel := 2;
   Has_DMA  : Boolean := False;
   Devices  : Natural range 0 .. 8 := 0;
   Bus      : Bus_State;
   Reconfig : Natural := 0;

   function Is_Open (P : Port_Id) return Boolean is (Opened);
   function Reconfigurations (P : Port_Id) return Natural is (Reconfig);

   function Holds (D : Device) return Boolean is
     (D.Attached and then Bus.Owner = Holder (D.Number));

   function Rate_Of (D : Device) return Natural is
     (Rate (Clock, Divisor (D.Shift)));

   --  The procedure for disabling the SPI (42.5.9): the transmit
   --  FIFO empty, the last frame out, SPE off, then the receive FIFO
   --  read empty. Reading DR and then SR clears an overrun (42.5.11).
   procedure Disable is
      Junk : Unsigned_8;
      Flags : SR_Register;
   begin
      loop
         exit when R.SR.FTLVL = 0;
      end loop;
      loop
         exit when not R.SR.BSY;
      end loop;
      R.CR1.SPE := False;
      loop
         exit when R.SR.FRLVL = 0;
         Junk := DR8;
      end loop;
      Flags := R.SR;
      pragma Unreferenced (Junk, Flags);
   end Disable;

   procedure Open
     (P       : Port_Id;
      Stat    : out Status;
      Channel : Keel.DMA.STM32G4.Channel := 2)
   is
      PCLK2 : constant Keel.Clock.Frequency :=
        Keel.Clock.STM32G4.Sys_Frequency;
   begin
      if PCLK2 not in 1_000_000 .. 500_000_000 then
         Stat := Not_Supported;
         return;
      end if;
      Reserve (A, 5, SPI_AF, Stat);
      if Stat = Ok then
         Reserve (A, 6, SPI_AF, Stat);
      end if;
      if Stat = Ok then
         Reserve (A, 7, SPI_AF, Stat);
      end if;
      if Stat /= Ok then
         return;
      end if;
      Has_DMA := Keel.DMA.STM32G4.Is_Enabled;
      if Has_DMA then
         Claim (Channel, Stat);
         if Stat /= Ok then
            return;
         end if;
      end if;

      --  SPI1's clock on (RCC_APB2ENR bit 12, 7.4.19), read back
      --  before the first access (7.2.17); then through reset
      RCC_Periph.RCC_APB2ENR.SPI1EN := B_0x1;
      declare
         Back : constant RCC_APB2ENR_Register :=
           RCC_Periph.RCC_APB2ENR
           with Unreferenced;
      begin
         null;
      end;
      RCC_Periph.RCC_APB2RSTR.SPI1RST := B_0x1;
      RCC_Periph.RCC_APB2RSTR.SPI1RST := B_0x0;

      --  Controller, NSS by software and held high, the slowest
      --  divider, mode 0; 8-bit frames, RXNE at one byte (FRXTH)
      R.CR1 := (MSTR => True, SSM => True, SSI => True,
                BR => 7, others => <>);
      R.CR2 := (DS => Eight_Bits, FRXTH => True, others => <>);
      R.CR1.SPE := True;

      Opened := True;
      Clock := Clock_Hz (PCLK2);
      Chan := Channel;
      Devices := 0;
      Bus := (others => <>);
      Reconfig := 0;
      Stat := Ok;
   end Open;

   procedure Attach
     (D : in out Device; Want : Settings; Stat : out Status)
   is
      Found : Boolean;
   begin
      if Devices = 8 then
         Stat := Not_Supported;
         return;
      end if;
      Solve_Power_Of_Two (Clock, Want.Max_Rate, D.Shift, Found);
      if not Found then
         Stat := Not_Supported;
         return;
      end if;
      Claim (D.Select_Pin,
             (Initial => Keel.GPIO.High, Slew => Keel.GPIO.Fast),
             Stat);
      if Stat /= Ok then
         return;
      end if;
      Devices := Devices + 1;
      D.Number := Device_Number (Devices);
      D.Want := Want;
      D.Attached := True;
   end Attach;

   --  CPOL, CPHA and BR change only while SPE is off (42.9.1)
   procedure Configure (D : Device) is
   begin
      Disable;
      R.CR1 :=
        (CPHA   => Samples_Second_Edge (D.Want.Mode),
         CPOL   => Idles_High (D.Want.Mode),
         MSTR   => True,
         BR     => CR1_BR_Field (D.Shift),
         SSM    => True,
         SSI    => True,
         others => <>);
      R.CR1.SPE := True;
      Reconfig := Reconfig + 1;
   end Configure;

   procedure Acquire (D : in out Device; Stat : out Status) is
      Again : Boolean;
   begin
      Acquire (Bus, D.Number, D.Want, Again, Stat);
      if Stat /= Ok then
         return;
      end if;
      if Again then
         Configure (D);
      end if;
      Set (D.Select_Pin, Keel.GPIO.Low);
   end Acquire;

   procedure Release (D : in out Device) is
   begin
      Set (D.Select_Pin, Keel.GPIO.High);
      Release (Bus, D.Number);
   end Release;

   --  Wait for the last frame to leave and read what came back
   procedure Settle is
      Junk  : Unsigned_8;
      Flags : SR_Register;
   begin
      loop
         exit when R.SR.FTLVL = 0;
      end loop;
      loop
         exit when not R.SR.BSY;
      end loop;
      loop
         exit when R.SR.FRLVL = 0;
         Junk := DR8;
      end loop;
      Flags := R.SR;
      pragma Unreferenced (Junk, Flags);
   end Settle;

   procedure Write (D : in out Device; Data : Byte_Array) is
      Junk : Unsigned_8;
   begin
      for B of Data loop
         loop
            exit when R.SR.TXE;
         end loop;
         DR8 := B;
         if R.SR.RXNE then
            Junk := DR8;
         end if;
      end loop;
      pragma Unreferenced (Junk);
      Settle;
   end Write;

   procedure Exchange (D : in out Device; Data : in out Byte_Array) is
   begin
      Settle;
      for B of Data loop
         loop
            exit when R.SR.TXE;
         end loop;
         DR8 := B;
         loop
            exit when R.SR.RXNE;
         end loop;
         B := DR8;
      end loop;
   end Exchange;

   procedure Start_Stream
     (D     : in out Device;
      From  : Keel.DMA.Region;
      Count : Positive;
      Stat  : out Status)
   is
   begin
      if not Has_DMA or else Count > Count_16'Last then
         Stat := Not_Supported;
         return;
      end if;
      declare
         T : constant Transfer :=
           (From     => From,
            To       => Keel.DMA.Register (R.DR'Address),
            Size     => Keel.DMA.Half_Word,
            Count    => Count,
            Paced_By => SPI1_TX_Request,
            Notify   => True,
            others   => <>);
      begin
         if not Valid (T) then
            Stat := Not_Supported;
            return;
         end if;
         --  In the order 42.5.9 gives ("Communication using DMA"):
         --  the channel, then TXDMAEN, then SPE. The first request
         --  comes at once, since TXE is set.
         Disable;
         R.CR2 := (DS => Sixteen_Bits, FRXTH => False, others => <>);
         Start (Chan, T, Stat);
         if Stat /= Ok then
            R.CR2 := (DS => Eight_Bits, FRXTH => True, others => <>);
            R.CR1.SPE := True;
            return;
         end if;
         R.CR2.TXDMAEN := True;
         R.CR1.SPE := True;
         D.Streaming := True;
      end;
   end Start_Stream;

   procedure Finish_Stream
     (D : in out Device; Done : out Keel.DMA.Receipt) is
   begin
      Wait (Chan, Done);
      --  The DMA has written the last frame; the SPI disable
      --  procedure waits for it to leave, and only then does
      --  TXDMAEN go off (42.5.9, "Communication using DMA"), with
      --  8-bit frames back
      Disable;
      R.CR2 := (DS => Eight_Bits, FRXTH => True, others => <>);
      R.CR1.SPE := True;
      D.Streaming := False;
   end Finish_Stream;
end Keel.Bus.SPI.STM32G4;
