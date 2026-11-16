--  SPDX-License-Identifier: Apache-2.0
with Keel.Clock;
with Keel.Clock.STM32G4;
with Keel.Cortex_M;
with Keel.GPIO.STM32G4;
with Keel.Ring_Buffers;
with STM32G4_SVD;       use STM32G4_SVD;
with STM32G4_SVD.RCC;   use STM32G4_SVD.RCC;
with STM32G4_SVD.USART; use STM32G4_SVD.USART;

package body Keel.Bus.UART.STM32G4 is
   --  One port: the P parameters name it, and are otherwise unused
   pragma Warnings (Off, "formal parameter ""P"" is not referenced");

   package Chars is new Keel.Ring_Buffers
     (Element => Character, Initial => ' ', Size_Bits => 8);
   use Chars;

   --  PA2 and PA3 as LPUART1_TX and LPUART1_RX: alternate function
   --  12 (STM32CubeG4, stm32g4xx_nucleo.h and stm32g4xx_hal_gpio_ex.h)
   package Pins renames Keel.GPIO.STM32G4;
   LPUART_AF : constant Pins.Alternate_Function := 12;

   R : LPUART1_Peripheral renames LPUART1_Periph;

   Opened : Boolean := False;
   How_It : Mode := Polled;
   BRR_In : Divisor := 0;
   RX, TX : Ring;
   Stats  : Counts
     with Volatile;
   Armed  : Boolean := False
     with Volatile;

   function Bump (N : Natural) return Natural is
     (if N = Natural'Last then N else N + 1);

   function Is_Open (P : Port_Id) return Boolean is (Opened);
   function Mode_Of (P : Port_Id) return Mode is (How_It);
   function Divisor_Of (P : Port_Id) return Divisor is (BRR_In);
   function Statistics (P : Port_Id) return Counts is (Stats);

   --  PE, FE, NE and ORE describe the character at the head of the
   --  receive FIFO; ICR clears them
   procedure Note_Errors is
      S : constant ISR_Register := R.ISR;
   begin
      if S.FE then
         Stats.Framing := Bump (Stats.Framing);
      end if;
      if S.PE then
         Stats.Parity := Bump (Stats.Parity);
      end if;
      if S.ORE then
         Stats.Overruns := Bump (Stats.Overruns);
      end if;
      if S.FE or else S.PE or else S.NF or else S.ORE then
         R.ICR := (PECF | FECF | NCF | ORECF => True, others => <>);
      end if;
   end Note_Errors;

   procedure Handler
     with Export, Convention => C, External_Name => "keel_isr_91";

   procedure Handler is
      C : Character;
   begin
      Keel.Cortex_M.DMB;
      Note_Errors;
      --  RXNE is RXFNE with the FIFO on: something to read
      while R.ISR.RXNE loop
         C := Character'Val (Natural (R.RDR.RDR) mod 256);
         if Is_Full (RX) then
            Stats.Dropped := Bump (Stats.Dropped);
         else
            Push (RX, C);
            Stats.Received := Bump (Stats.Received);
         end if;
      end loop;
      --  TXE is TXFNF: room in the transmit FIFO
      if Armed then
         while R.ISR.TXE and then not Is_Empty (TX) loop
            Pop (TX, C);
            R.TDR := (TDR => Character'Pos (C), others => <>);
            Stats.Sent := Bump (Stats.Sent);
         end loop;
         if Is_Empty (TX) then
            R.CR1.TXEIE := False;
            Armed := False;
         end if;
      end if;
      Keel.Cortex_M.DMB;
   end Handler;

   procedure Open
     (P        : Port_Id;
      Baud     : Baud_Rate;
      Stat     : out Status;
      F        : Format := Eight_N_One;
      How      : Mode := Interrupt;
      Priority : Keel.Interrupts.Priority := 4)
   is
      PCLK  : constant Keel.Clock.Frequency :=
        Keel.Clock.STM32G4.Sys_Frequency;
      D     : Divisor;
      Found : Boolean;
      --  The word holds the parity bit: 7 or 8 bits of data, and
      --  parity, make a word of 7, 8 or 9 (M1:M0 = 10, 00, 01)
      Word  : constant Positive :=
        Natural (F.Bits) + (if F.Check = None then 0 else 1);
   begin
      if How = DMA or else PCLK not in 1_000_000 .. 500_000_000 then
         Stat := Not_Supported;
         return;
      end if;
      Solve (Limits, Clock_Hz (PCLK), Baud, D, Found);
      if not Found then
         Stat := Not_Supported;
         return;
      end if;
      Pins.Reserve (Pins.A, 2, LPUART_AF, Stat);
      if Stat /= Ok then
         return;
      end if;
      Pins.Reserve (Pins.A, 3, LPUART_AF, Stat);
      if Stat /= Ok then
         return;
      end if;

      --  Clock from PCLK1 (LPUART1SEL = 00), then the registers,
      --  written while UE is off
      RCC_Periph.RCC_CCIPR.LPUART1SEL := B_0x0;
      RCC_Periph.RCC_APB1ENR2.LPUART1EN := B_0x1;
      R.CR1 := (others => <>);
      R.PRESC := (others => <>);
      R.BRR := (BRR => BRR_BRR_Field (D), others => <>);
      R.CR2 := (STOP => (if F.Stops = 2 then 2#10# else 2#00#),
                others => <>);
      R.CR1 :=
        (FIFOEN => True,
         M1     => Word = 7,
         M0     => Word = 9,
         PCE    => F.Check /= None,
         PS     => F.Check = Odd,
         RXNEIE => How = Interrupt,
         TE     => True,
         RE     => True,
         others => <>);
      R.CR1.UE := True;
      if How = Interrupt then
         Keel.Interrupts.Set_Priority (IRQ, Priority);
         Keel.Interrupts.Enable (IRQ);
      end if;
      Opened := True;
      How_It := How;
      BRR_In := D;
      Stat := Ok;
   end Open;

   procedure Arm is
   begin
      Keel.Cortex_M.Disable_Interrupts;
      if not Armed then
         Armed := True;
         R.CR1.TXEIE := True;
      end if;
      Keel.Cortex_M.Enable_Interrupts;
   end Arm;

   procedure Write (P : Port_Id; Text : String) is
   begin
      if How_It = Polled then
         for C of Text loop
            loop
               exit when R.ISR.TXE;
            end loop;
            R.TDR := (TDR => Character'Pos (C), others => <>);
            Stats.Sent := Bump (Stats.Sent);
         end loop;
         return;
      end if;
      for C of Text loop
         loop
            Keel.Cortex_M.DMB;
            exit when not Is_Full (TX);
            Arm;
            Keel.Cortex_M.WFI;
         end loop;
         Push (TX, C);
         Keel.Cortex_M.DMB;
      end loop;
      Arm;
   end Write;

   procedure Read (P : Port_Id; C : out Character; Got : out Boolean) is
   begin
      C := ASCII.NUL;
      Got := False;
      if How_It = Polled then
         Note_Errors;
         if R.ISR.RXNE then
            C := Character'Val (Natural (R.RDR.RDR) mod 256);
            Got := True;
            Stats.Received := Bump (Stats.Received);
         end if;
      else
         Keel.Cortex_M.DMB;
         if not Is_Empty (RX) then
            Pop (RX, C);
            Got := True;
         end if;
         Keel.Cortex_M.DMB;
      end if;
   end Read;

   function Space (P : Port_Id) return Natural is
   begin
      if How_It = Polled then
         return Natural'Last;
      end if;
      Keel.Cortex_M.DMB;
      return Ring_Size - Length (TX);
   end Space;

   procedure Flush (P : Port_Id) is
   begin
      loop
         Keel.Cortex_M.DMB;
         exit when (How_It = Polled or else Is_Empty (TX))
           and then R.ISR.TC;
      end loop;
   end Flush;

   package body Console is
      procedure Write (Text : String) is
      begin
         STM32G4.Write (Port, Text);
      end Write;

      procedure Read (C : out Character; Got : out Boolean) is
      begin
         STM32G4.Read (Port, C, Got);
      end Read;

      function Space return Natural is (STM32G4.Space (Port));
   end Console;
end Keel.Bus.UART.STM32G4;
