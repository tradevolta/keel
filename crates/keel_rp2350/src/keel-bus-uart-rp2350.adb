--  SPDX-License-Identifier: Apache-2.0
with Interfaces;                use Interfaces;
with Keel.Clock.RP2350;
with Keel.Cortex_M;
with Keel.GPIO;
with Keel.DMA;                  use Keel.DMA;
with Keel.DMA.Buffers;
with Keel.Ring_Buffers;
with RP2350_SVD;                use RP2350_SVD;
with RP2350_SVD.Atomic;
with RP2350_SVD.RESETS;         use RP2350_SVD.RESETS;
with RP2350_SVD.UART0;          use RP2350_SVD.UART0;
with RP2350_SVD.UART_Blocks;

package body Keel.Bus.UART.RP2350 is

   package Reset_Bits is new RP2350_SVD.Atomic (RESET_Register);
   package Chars is new Keel.Ring_Buffers
     (Element => Character, Initial => ' ', Size_Bits => 8);
   use Chars;

   UART_Function : constant Function_Number := 2;

   --  DREQ_UART0_RX and DREQ_UART1_RX (datasheet 12.6.4.1, Table
   --  1254)
   function RX_Request (P : Port_Id) return Keel.DMA.RP2350.Request is
     (if P = UART0 then 29 else 31);

   function Regs (P : Port_Id) return UART_Blocks.Block_Access is
     (UART_Blocks.Blocks (Port_Id'Pos (P)));

   ------------------------------------------------------------------
   --  State. The interrupt handler produces into RX and consumes
   --  from TX; the program does the opposite. Every ring operation
   --  sits between two DMBs, on both sides.
   ------------------------------------------------------------------
   type Port_State is record
      Open    : Boolean := False;
      How     : Mode := Polled;
      D       : Divisor := 0;
      Channel : Keel.DMA.RP2350.Channel := 0;
   end record;
   type State_Array is array (Port_Id) of Port_State;
   type Ring_Array is array (Port_Id) of Ring;
   type Count_Array is array (Port_Id) of Counts
     with Volatile_Components;
   type Flag_Array is array (Port_Id) of Boolean
     with Volatile_Components;

   State : State_Array;
   RX    : Ring_Array;
   TX    : Ring_Array;
   Stats : Count_Array;
   --  TXIM is on: the handler is draining TX
   Armed : Flag_Array := [others => False];

   --  The DMA's ring, 256 bytes on a 256-byte boundary per port
   package Bytes is new Keel.DMA.Buffers (Unsigned_8, Ring_Size);
   type Aligned_Buffer is limited record
      B : Bytes.Buffer;
   end record
     with Alignment => Ring_Size;
   type Buffer_Array is array (Port_Id) of Aligned_Buffer;
   DMA_Ring : Buffer_Array;
   --  How far the program has read the DMA's ring, in characters
   --  since Open
   type DMA_Count is mod 2**32;
   DMA_Tail : array (Port_Id) of DMA_Count := [others => 0];

   function Bump (N : Natural) return Natural is
     (if N = Natural'Last then N else N + 1);

   function Is_Open (P : Port_Id) return Boolean is (State (P).Open);
   function Mode_Of (P : Port_Id) return Mode is (State (P).How);
   function Divisor_Of (P : Port_Id) return Divisor is (State (P).D);
   function Statistics (P : Port_Id) return Counts is (Stats (P));

   procedure Note_Errors (P : Port_Id; FE, PE, BE, OE : Boolean) is
   begin
      if FE then
         Stats (P).Framing := Bump (Stats (P).Framing);
      end if;
      if PE then
         Stats (P).Parity := Bump (Stats (P).Parity);
      end if;
      if BE then
         Stats (P).Breaks := Bump (Stats (P).Breaks);
      end if;
      if OE then
         Stats (P).Overruns := Bump (Stats (P).Overruns);
      end if;
   end Note_Errors;

   ------------------------------------------------------------------
   --  The interrupt handler, for both ports
   ------------------------------------------------------------------
   procedure Service (P : Port_Id) is
      R   : UART0_Peripheral renames Regs (P).all;
      MIS : constant UARTMIS_Register := R.UARTMIS;
      W   : UARTDR_Register;
      C   : Character;
   begin
      Keel.Cortex_M.DMB;
      if State (P).How = Interrupt then
         --  Empty the receive FIFO into RX; each character carries
         --  its own error bits (12.1.3.2.3)
         while not R.UARTFR.RXFE loop
            W := R.UARTDR;
            Note_Errors (P, W.FE, W.PE, W.BE, W.OE);
            if Is_Full (RX (P)) then
               Stats (P).Dropped := Bump (Stats (P).Dropped);
            else
               Push (RX (P), Character'Val (W.DATA));
               Stats (P).Received := Bump (Stats (P).Received);
            end if;
         end loop;
      else
         --  The DMA took the characters; only the flags are left
         Note_Errors (P, MIS.FEMIS, MIS.PEMIS, MIS.BEMIS, MIS.OEMIS);
      end if;
      R.UARTICR :=
        (RTIC | FEIC | PEIC | BEIC | OEIC => True, others => <>);

      --  Fill the transmit FIFO from TX; when TX is empty, stop
      --  the transmit interrupt until Write arms it again
      if Armed (P) then
         while not R.UARTFR.TXFF and then not Is_Empty (TX (P)) loop
            Pop (TX (P), C);
            R.UARTDR := (DATA => Character'Pos (C), others => <>);
            Stats (P).Sent := Bump (Stats (P).Sent);
         end loop;
         if Is_Empty (TX (P)) then
            R.UARTIMSC.TXIM := False;
            Armed (P) := False;
         end if;
      end if;
      Keel.Cortex_M.DMB;
   end Service;

   procedure UART0_Handler
     with Export, Convention => C, External_Name => "keel_isr_33";
   procedure UART1_Handler
     with Export, Convention => C, External_Name => "keel_isr_34";

   procedure UART0_Handler is
   begin
      Service (UART0);
   end UART0_Handler;

   procedure UART1_Handler is
   begin
      Service (UART1);
   end UART1_Handler;

   ------------------------------------------------------------------
   --  Open
   ------------------------------------------------------------------
   procedure Open
     (P        : Port_Id;
      TX, RX   : Pin_Id;
      Baud     : Baud_Rate;
      Stat     : out Status;
      F        : Format := Eight_N_One;
      How      : Mode := Interrupt;
      Channel  : Keel.DMA.RP2350.Channel := 11;
      Priority : Keel.Interrupts.Priority := 4)
   is
      use type Keel.Clock.Frequency;
      package Clk renames Keel.Clock.RP2350;
      R     : UART0_Peripheral renames Regs (P).all;
      Bit   : constant UInt2 := (if P = UART0 then 1 else 2);
      D     : Divisor;
      Found : Boolean;
      Ring  : Region;
   begin
      if Clk.Peri_Frequency = 0 then
         Clk.Start_Peri_Clock;
      end if;
      if Clk.Peri_Frequency not in 1_000_000 .. 500_000_000 then
         Stat := Not_Supported;
         return;
      end if;
      Solve (Limits, Clock_Hz (Clk.Peri_Frequency), Baud, D, Found);
      if not Found then
         Stat := Not_Supported;
         return;
      end if;

      --  The pins: RX pulled up, so a loose wire idles high, not low,
      --  which the UART would read as a break
      Reserve (TX, Stat);
      if Stat /= Ok then
         return;
      end if;
      Reserve (RX, Stat, Bias => Keel.GPIO.Pull_Up);
      if Stat /= Ok then
         return;
      end if;
      if How = DMA then
         Keel.DMA.RP2350.Claim (Channel, Stat);
         if Stat /= Ok then
            return;
         end if;
      end if;

      --  Through reset, then the divisor; the LCR_H write latches
      --  IBRD and FBRD (12.1.3.2), so it comes after them
      Reset_Bits.Set
        (RESETS_Periph.RESET,
         (Reset_Bits.No_Bits with delta UART => (False, Bit)));
      Reset_Bits.Clear
        (RESETS_Periph.RESET,
         (Reset_Bits.No_Bits with delta UART => (False, Bit)));
      loop
         exit when RESETS_Periph.RESET_DONE.UART.Arr (Port_Id'Pos (P));
      end loop;
      R.UARTIBRD := (BAUD_DIVINT => UInt16 (D / 64), others => <>);
      R.UARTFBRD := (BAUD_DIVFRAC => UInt6 (D mod 64), others => <>);
      R.UARTLCR_H :=
        (WLEN => UInt2 (Natural (F.Bits) - 5),
         FEN  => True,
         STP2 => F.Stops = 2,
         PEN  => F.Check /= None,
         EPS  => F.Check = Even,
         others => <>);

      --  The receive side
      case How is
         when Polled =>
            null;
         when Interrupt =>
            --  A FIFO half full, or a pause of 32 bit times with
            --  anything in it (12.1.6.4), wakes the handler
            R.UARTIMSC := (RXIM | RTIM => True, others => <>);
         when DMA =>
            Bytes.Lend (DMA_Ring (P).B, Ring);
            R.UARTDMACR := (RXDMAE => True, others => <>);
            Keel.DMA.RP2350.Start
              (Channel,
               (From     => Register (R.UARTDR'Address),
                To       => Ring,
                Size     => Keel.DMA.Byte,
                Count    => Ring_Size,
                Paced_By => RX_Request (P),
                Mode     => Keel.DMA.RP2350.Repeat,
                Wrap     => 8,
                Notify   => True,
                others   => <>),
               Stat);
            if Stat /= Ok then
               return;
            end if;
            DMA_Tail (P) := 0;
            R.UARTIMSC :=
              (FEIM | PEIM | BEIM | OEIM => True, others => <>);
      end case;

      Select_Function (TX, UART_Function);
      Select_Function (RX, UART_Function);
      R.UARTCR := (UARTEN | TXE | RXE => True, others => <>);
      if How /= Polled then
         Keel.Interrupts.Set_Priority (IRQ (P), Priority);
         Keel.Interrupts.Enable (IRQ (P));
      end if;
      State (P) := (Open => True, How => How, D => D,
                    Channel => Channel);
      Stat := Ok;
   end Open;

   ------------------------------------------------------------------
   --  Writing
   ------------------------------------------------------------------

   --  Turn the transmit interrupt on, if it is off, and make it
   --  pending: it fires only when the FIFO drains past its level
   --  (12.1.6.3), and an idle FIFO never does. IMSC is shared with
   --  the handler, so its update is the one place with interrupts
   --  masked.
   procedure Arm (P : Port_Id) is
   begin
      Keel.Cortex_M.Disable_Interrupts;
      if not Armed (P) then
         Armed (P) := True;
         Regs (P).UARTIMSC.TXIM := True;
         Keel.Interrupts.Set_Pending (IRQ (P));
      end if;
      Keel.Cortex_M.Enable_Interrupts;
   end Arm;

   procedure Write (P : Port_Id; Text : String) is
      R : UART0_Peripheral renames Regs (P).all;
   begin
      if State (P).How = Polled then
         for C of Text loop
            loop
               exit when not R.UARTFR.TXFF;
            end loop;
            R.UARTDR := (DATA => Character'Pos (C), others => <>);
            Stats (P).Sent := Bump (Stats (P).Sent);
         end loop;
         return;
      end if;

      for C of Text loop
         --  Wait for room: the handler makes it, and its interrupt
         --  ends the WFI
         loop
            Keel.Cortex_M.DMB;
            exit when not Is_Full (TX (P));
            Arm (P);
            Keel.Cortex_M.WFI;
         end loop;
         Push (TX (P), C);
         Keel.Cortex_M.DMB;
      end loop;
      Arm (P);
   end Write;

   function Space (P : Port_Id) return Natural is
   begin
      if State (P).How = Polled then
         return Natural'Last;
      end if;
      Keel.Cortex_M.DMB;
      return Ring_Size - Length (TX (P));
   end Space;

   procedure Flush (P : Port_Id) is
      R : UART0_Peripheral renames Regs (P).all;
   begin
      loop
         Keel.Cortex_M.DMB;
         exit when (State (P).How = Polled or else Is_Empty (TX (P)))
           and then not R.UARTFR.BUSY;
      end loop;
   end Flush;

   ------------------------------------------------------------------
   --  Reading
   ------------------------------------------------------------------

   --  How many characters the DMA has written since Open. Rounds
   --  counts the ring's laps, but the interrupt that counts one comes
   --  a moment after the write address wraps: a count that would put
   --  the DMA behind the program is one lap short.
   function DMA_Head (P : Port_Id) return DMA_Count is
      Ch     : constant Keel.DMA.RP2350.Channel := State (P).Channel;
      R1, R2 : Natural;
      Pos    : Natural;
      H      : DMA_Count;
   begin
      loop
         R1 := Keel.DMA.RP2350.Rounds (Ch);
         Pos := Keel.DMA.RP2350.Position (Ch);
         R2 := Keel.DMA.RP2350.Rounds (Ch);
         exit when R1 = R2;
      end loop;
      H := DMA_Count (R1 mod 2**24) * Ring_Size
        + DMA_Count (Pos mod Ring_Size);
      if H - DMA_Tail (P) > 2**31 then
         H := H + Ring_Size;
      end if;
      return H;
   end DMA_Head;

   procedure Read (P : Port_Id; C : out Character; Got : out Boolean) is
      R : UART0_Peripheral renames Regs (P).all;
      W : UARTDR_Register;
      Ahead : DMA_Count;
   begin
      C := ASCII.NUL;
      Got := False;
      case State (P).How is
         when Polled =>
            if not R.UARTFR.RXFE then
               W := R.UARTDR;
               Note_Errors (P, W.FE, W.PE, W.BE, W.OE);
               C := Character'Val (W.DATA);
               Got := True;
               Stats (P).Received := Bump (Stats (P).Received);
            end if;

         when Interrupt =>
            Keel.Cortex_M.DMB;
            if not Is_Empty (RX (P)) then
               Pop (RX (P), C);
               Got := True;
            end if;
            Keel.Cortex_M.DMB;

         when DMA =>
            Ahead := DMA_Head (P) - DMA_Tail (P);
            if Ahead > Ring_Size then
               --  The DMA has lapped the program: what the ring holds
               --  is no longer in order. Drop it all.
               Stats (P).Dropped :=
                 (if Natural'Last - Stats (P).Dropped < Natural (Ahead)
                  then Natural'Last
                  else Stats (P).Dropped + Natural (Ahead));
               DMA_Tail (P) := DMA_Tail (P) + Ahead;
            elsif Ahead > 0 then
               C := Character'Val
                 (Bytes.Peek (DMA_Ring (P).B,
                              Natural (DMA_Tail (P) mod Ring_Size)));
               DMA_Tail (P) := DMA_Tail (P) + 1;
               Got := True;
               Stats (P).Received := Bump (Stats (P).Received);
            end if;
      end case;
   end Read;

   package body Console is
      procedure Write (Text : String) is
      begin
         RP2350.Write (Port, Text);
      end Write;

      procedure Read (C : out Character; Got : out Boolean) is
      begin
         RP2350.Read (Port, C, Got);
      end Read;

      function Space return Natural is (RP2350.Space (Port));
   end Console;
end Keel.Bus.UART.RP2350;
