--  SPDX-License-Identifier: Apache-2.0
with Keel.Clock.RP2350;
with Keel.DMA.RP2350;           use Keel.DMA.RP2350;
with Keel.GPIO;
with RP2350_SVD;                use RP2350_SVD;
with RP2350_SVD.Atomic;
with RP2350_SVD.RESETS;         use RP2350_SVD.RESETS;
with RP2350_SVD.SPI0;           use RP2350_SVD.SPI0;
with RP2350_SVD.SPI_Blocks;

package body Keel.Bus.SPI.RP2350 is

   package Reset_Bits is new RP2350_SVD.Atomic (RESET_Register);

   SPI_Function : constant Function_Number := 1;

   --  DREQ_SPI0_TX and DREQ_SPI1_TX (datasheet 12.6.4.1, Table 1254)
   function TX_Request (P : Port_Id) return Keel.DMA.RP2350.Request is
     (if P = SPI0 then 24 else 26);

   function Regs (P : Port_Id) return SPI_Blocks.Block_Access is
     (SPI_Blocks.Blocks (Port_Id'Pos (P)));

   --  SSPCR0.DSS: frame size minus one (Table 1153)
   Eight_Bits   : constant SSPCR0_DSS_Field := 2#0111#;
   Sixteen_Bits : constant SSPCR0_DSS_Field := 2#1111#;

   type Port_State is record
      Open     : Boolean := False;
      Clock    : Clock_Hz := 150_000_000;
      Channel  : Keel.DMA.RP2350.Channel := 9;
      Has_DMA  : Boolean := False;
      Devices  : Natural range 0 .. 8 := 0;
      Bus      : Bus_State;
      Reconfig : Natural := 0;
   end record;

   State : array (Port_Id) of Port_State;

   function Is_Open (P : Port_Id) return Boolean is (State (P).Open);
   function Reconfigurations (P : Port_Id) return Natural is
     (State (P).Reconfig);

   function Holds (D : Device) return Boolean is
     (D.Attached and then State (D.Port).Bus.Owner = Holder (D.Number));

   function Rate_Of (D : Device) return Natural is
     (Rate (State (D.Port).Clock, Divisor (D.Divider)));

   procedure Open
     (P           : Port_Id;
      SCK, TX, RX : Pin_Id;
      Stat        : out Status;
      Channel     : Keel.DMA.RP2350.Channel := 9)
   is
      use type Keel.Clock.Frequency;
      package Clk renames Keel.Clock.RP2350;
      R   : SPI0_Peripheral renames Regs (P).all;
      Bit : constant UInt2 := (if P = SPI0 then 1 else 2);
   begin
      if Clk.Peri_Frequency = 0 then
         Clk.Start_Peri_Clock;
      end if;
      if Clk.Peri_Frequency not in 1_000_000 .. 500_000_000 then
         Stat := Not_Supported;
         return;
      end if;

      --  RX pulled up: with no device driving it, it reads 0xFF
      Reserve (SCK, Stat);
      if Stat = Ok then
         Reserve (TX, Stat);
      end if;
      if Stat = Ok then
         Reserve (RX, Stat, Bias => Keel.GPIO.Pull_Up);
      end if;
      if Stat /= Ok then
         return;
      end if;
      State (P).Has_DMA := Keel.DMA.RP2350.Is_Enabled;
      if State (P).Has_DMA then
         Keel.DMA.RP2350.Claim (Channel, Stat);
         if Stat /= Ok then
            return;
         end if;
      end if;

      --  Through reset; then 8-bit Motorola frames, mode 0, the
      --  slowest divider, until a device asks for its own
      Reset_Bits.Set
        (RESETS_Periph.RESET,
         (Reset_Bits.No_Bits with delta SPI => (False, Bit)));
      Reset_Bits.Clear
        (RESETS_Periph.RESET,
         (Reset_Bits.No_Bits with delta SPI => (False, Bit)));
      loop
         exit when RESETS_Periph.RESET_DONE.SPI.Arr (Port_Id'Pos (P));
      end loop;
      R.SSPCR0 := (DSS => Eight_Bits, SCR => 255, others => <>);
      R.SSPCPSR := (CPSDVSR => 254, others => <>);
      R.SSPCR1 := (SSE => True, others => <>);

      Select_Function (SCK, SPI_Function);
      Select_Function (TX, SPI_Function);
      Select_Function (RX, SPI_Function);

      State (P) :=
        (Open     => True,
         Clock    => Clock_Hz (Clk.Peri_Frequency),
         Channel  => Channel,
         Has_DMA  => State (P).Has_DMA,
         Devices  => 0,
         Bus      => (others => <>),
         Reconfig => 0);
      Stat := Ok;
   end Open;

   procedure Attach
     (D : in out Device; Want : Settings; Stat : out Status)
   is
      S     : Port_State renames State (D.Port);
      Found : Boolean;
   begin
      if S.Devices = 8 then
         Stat := Not_Supported;
         return;
      end if;
      Solve_Prescaled (S.Clock, Want.Max_Rate, D.Divider, Found);
      if not Found then
         Stat := Not_Supported;
         return;
      end if;
      --  Chip selects are active low: high until Acquire
      Claim (D.Select_Pin, (Initial => Keel.GPIO.High, others => <>),
             Stat);
      if Stat /= Ok then
         return;
      end if;
      S.Devices := S.Devices + 1;
      D.Number := Device_Number (S.Devices);
      D.Want := Want;
      D.Attached := True;
   end Attach;

   --  Set the port up for D: the controller off while CR0 and CPSR
   --  change, as the PL022 asks, then on again
   procedure Configure (D : Device) is
      R : SPI0_Peripheral renames Regs (D.Port).all;
   begin
      R.SSPCR1 := (SSE => False, others => <>);
      R.SSPCR0 :=
        (DSS => Eight_Bits,
         FRF => 0,
         SPO => Idles_High (D.Want.Mode),
         SPH => Samples_Second_Edge (D.Want.Mode),
         SCR => SSPCR0_SCR_Field (D.Divider.Serial_Rate),
         others => <>);
      R.SSPCPSR :=
        (CPSDVSR => SSPCPSR_CPSDVSR_Field (D.Divider.Prescale),
         others => <>);
      R.SSPCR1 := (SSE => True, others => <>);
      State (D.Port).Reconfig := State (D.Port).Reconfig + 1;
   end Configure;

   procedure Acquire (D : in out Device; Stat : out Status) is
      Again : Boolean;
   begin
      Acquire (State (D.Port).Bus, D.Number, D.Want, Again, Stat);
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
      Release (State (D.Port).Bus, D.Number);
   end Release;

   --  Empty the receive FIFO, wait for the last frame to leave, empty
   --  it again and clear the overrun a send-only transfer leaves
   procedure Drain (R : in out SPI0_Peripheral) is
      Junk : SSPDR_Register;
   begin
      loop
         exit when not R.SSPSR.RNE;
         Junk := R.SSPDR;
      end loop;
      loop
         exit when not R.SSPSR.BSY;
      end loop;
      loop
         exit when not R.SSPSR.RNE;
         Junk := R.SSPDR;
      end loop;
      pragma Unreferenced (Junk);
      R.SSPICR := (RORIC => True, others => <>);
   end Drain;

   --  Each byte in as soon as the FIFO has room; what comes back is
   --  thrown away as it arrives, so the receive FIFO never overflows
   procedure Write (D : in out Device; Data : Byte_Array) is
      R    : SPI0_Peripheral renames Regs (D.Port).all;
      Junk : SSPDR_Register;
   begin
      for B of Data loop
         loop
            exit when R.SSPSR.TNF;
         end loop;
         R.SSPDR := (DATA => UInt16 (B), others => <>);
         if R.SSPSR.RNE then
            Junk := R.SSPDR;
         end if;
      end loop;
      pragma Unreferenced (Junk);
      Drain (R);
   end Write;

   procedure Exchange (D : in out Device; Data : in out Byte_Array) is
      R : SPI0_Peripheral renames Regs (D.Port).all;
   begin
      Drain (R);
      for B of Data loop
         loop
            exit when R.SSPSR.TNF;
         end loop;
         R.SSPDR := (DATA => UInt16 (B), others => <>);
         loop
            exit when R.SSPSR.RNE;
         end loop;
         B := Byte (R.SSPDR.DATA and 16#FF#);
      end loop;
   end Exchange;

   procedure Set_Frame (D : Device; Size : SSPCR0_DSS_Field) is
      R  : SPI0_Peripheral renames Regs (D.Port).all;
      C0 : SSPCR0_Register := R.SSPCR0;
   begin
      R.SSPCR1 := (SSE => False, others => <>);
      C0.DSS := Size;
      R.SSPCR0 := C0;
      R.SSPCR1 := (SSE => True, others => <>);
   end Set_Frame;

   procedure Start_Stream
     (D     : in out Device;
      From  : Keel.DMA.Region;
      Count : Positive;
      Stat  : out Status)
   is
      S : Port_State renames State (D.Port);
      R : SPI0_Peripheral renames Regs (D.Port).all;
      T : constant Transfer :=
        (From     => From,
         To       => Keel.DMA.Register (R.SSPDR'Address),
         Size     => Keel.DMA.Half_Word,
         Count    => Count,
         Paced_By => TX_Request (D.Port),
         Mode     => Once,
         Notify   => True,
         others   => <>);
   begin
      if not S.Has_DMA or else not Valid (T) then
         Stat := Not_Supported;
         return;
      end if;
      Set_Frame (D, Sixteen_Bits);
      R.SSPDMACR := (TXDMAE => True, others => <>);
      Start (S.Channel, T, Stat);
      if Stat /= Ok then
         R.SSPDMACR := (others => <>);
         Set_Frame (D, Eight_Bits);
         return;
      end if;
      D.Streaming := True;
   end Start_Stream;

   procedure Finish_Stream
     (D : in out Device; Done : out Keel.DMA.Receipt)
   is
      R : SPI0_Peripheral renames Regs (D.Port).all;
   begin
      Wait (State (D.Port).Channel, Done);
      --  The DMA has filled the FIFO for the last time; the frames
      --  still in it go out before the frame size changes back
      loop
         exit when R.SSPSR.TFE;
      end loop;
      Drain (R);
      R.SSPDMACR := (others => <>);
      Set_Frame (D, Eight_Bits);
      D.Streaming := False;
   end Finish_Stream;
end Keel.Bus.SPI.RP2350;
