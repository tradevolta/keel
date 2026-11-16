--  SPDX-License-Identifier: Apache-2.0
--  Keel.Bus.UART on the RP2350: its two PL011 UARTs, polled, by
--  interrupt, or receiving by DMA (datasheet 12.1). The Debug Probe's
--  UART goes to UART0 on GP0 (TX) and GP1 (RX).
--
--  Polled: Write waits on the transmit FIFO, Read takes what the
--  receive FIFO holds; 32 characters arrive between two Reads before
--  one is lost. Interrupt: the handler moves characters between the
--  FIFOs and two rings of 256 (Keel.Ring_Buffers), and Write waits
--  only while the transmit ring is full. DMA: a DMA channel copies
--  every received character into a ring of 256 in RAM, and the
--  program reads behind it; sending is by interrupt, as above.
with Keel.Bus.UART.Chip_Limits;
with Keel.DMA.RP2350;
with Keel.GPIO.RP2350; use Keel.GPIO.RP2350;
with Keel.Interrupts;

package Keel.Bus.UART.RP2350 is
   Limits : Divider_Limits renames Chip_Limits.RP2350_PL011;

   type Port_Id is (UART0, UART1);

   --  UART0_IRQ and UART1_IRQ (datasheet 3.2, Table 95)
   function IRQ (P : Port_Id) return Keel.Interrupts.IRQ is
     (if P = UART0 then 33 else 34);

   --  The pins with the UART as function 2 (datasheet 9.4, Table 677)
   function Valid_Pins (P : Port_Id; TX, RX : Pin_Id) return Boolean is
     (case P is
         when UART0 =>
            TX in 0 | 12 | 16 | 28 and then RX in 1 | 13 | 17 | 29,
         when UART1 =>
            TX in 4 | 8 | 20 | 24 and then RX in 5 | 9 | 21 | 25);

   --  Each ring holds 256 characters
   Ring_Size : constant := 256;

   --  Take P's pins, set its clock divider for Baud from clk_peri
   --  (started here if it isn't running) and its frame format, and
   --  start it the way How says. With DMA, Channel is the channel
   --  that receives, and Keel.DMA.RP2350 must be enabled.
   --  Not_Supported: clk_peri can't make Baud. In_Use: a pin, or the
   --  channel, has another owner.
   procedure Open
     (P        : Port_Id;
      TX, RX   : Pin_Id;
      Baud     : Baud_Rate;
      Stat     : out Status;
      F        : Format := Eight_N_One;
      How      : Mode := Interrupt;
      Channel  : Keel.DMA.RP2350.Channel := 11;
      Priority : Keel.Interrupts.Priority := 4)
     with Pre  => Keel.GPIO.RP2350.Is_Enabled
                  and then not Is_Open (P)
                  and then Valid_Pins (P, TX, RX)
                  and then (if How = DMA
                            then Keel.DMA.RP2350.Is_Enabled),
          Post => Is_Open (P) = (Stat = Ok)
                  and then (if Stat = Ok then Mode_Of (P) = How);

   function Is_Open (P : Port_Id) return Boolean;
   function Mode_Of (P : Port_Id) return Mode
     with Pre => Is_Open (P);

   --  The divisor in use: 64 * IBRD + FBRD
   function Divisor_Of (P : Port_Id) return Divisor
     with Pre => Is_Open (P);

   --  Send Text. Polled, it waits for the FIFO, character by
   --  character; otherwise it waits only while the ring is full. Not
   --  from an interrupt handler, nor with interrupts masked.
   procedure Write (P : Port_Id; Text : String)
     with Pre => Is_Open (P);

   --  The next character received, if any. Never waits.
   procedure Read (P : Port_Id; C : out Character; Got : out Boolean)
     with Pre => Is_Open (P);

   --  Characters Write takes now without waiting: room in the ring,
   --  or, polled, Natural'Last, since Write always waits its turn
   function Space (P : Port_Id) return Natural
     with Pre => Is_Open (P);

   --  Wait until everything written has left the pin
   procedure Flush (P : Port_Id)
     with Pre => Is_Open (P);

   function Statistics (P : Port_Id) return Counts;

   --  One port as a console, for Keel.CLI and Keel.Log
   generic
      Port : Port_Id;
   package Console is
      procedure Write (Text : String);
      procedure Read (C : out Character; Got : out Boolean);
      function Space return Natural;
      package Fits is new Text_Signature (Write, Read, Space);
   end Console;
end Keel.Bus.UART.RP2350;
