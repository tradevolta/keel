--  SPDX-License-Identifier: Apache-2.0
--  Keel.Bus.UART on the STM32G474: LPUART1, which the NUCLEO-G474RE
--  wires to its ST-LINK's virtual COM port on PA2 (TX) and PA3 (RX)
--  (UM2505, 7.6.5). Polled or by interrupt, with the same rings as
--  the RP2350's driver; receiving by DMA is left to an exercise.
--  The LPUART's FIFOs are 8 deep, a quarter of the PL011's 32.
with Keel.Bus.UART.Chip_Limits;
with Keel.Interrupts;

package Keel.Bus.UART.STM32G4 is
   Limits : Divider_Limits renames Chip_Limits.STM32G4_LPUART;

   type Port_Id is (LPUART1);

   --  LPUART1_IRQn (STM32CubeG4, stm32g474xx.h)
   IRQ : constant Keel.Interrupts.IRQ := 91;

   Ring_Size : constant := 256;

   --  PA2 and PA3 to the LPUART, its clock PCLK1 (which Keel keeps
   --  at clk_sys), the divider for Baud and the frame format.
   --  Not_Supported: PCLK1 can't make Baud, or How is DMA. In_Use: a
   --  pin has another owner.
   procedure Open
     (P        : Port_Id;
      Baud     : Baud_Rate;
      Stat     : out Status;
      F        : Format := Eight_N_One;
      How      : Mode := Interrupt;
      Priority : Keel.Interrupts.Priority := 4)
     with Pre  => not Is_Open (P),
          Post => Is_Open (P) = (Stat = Ok);

   function Is_Open (P : Port_Id) return Boolean;
   function Mode_Of (P : Port_Id) return Mode
     with Pre => Is_Open (P);
   --  BRR
   function Divisor_Of (P : Port_Id) return Divisor
     with Pre => Is_Open (P);

   procedure Write (P : Port_Id; Text : String)
     with Pre => Is_Open (P);
   procedure Read (P : Port_Id; C : out Character; Got : out Boolean)
     with Pre => Is_Open (P);
   function Space (P : Port_Id) return Natural
     with Pre => Is_Open (P);
   procedure Flush (P : Port_Id)
     with Pre => Is_Open (P);
   function Statistics (P : Port_Id) return Counts;

   generic
      Port : Port_Id;
   package Console is
      procedure Write (Text : String);
      procedure Read (C : out Character; Got : out Boolean);
      function Space return Natural;
      package Fits is new Text_Signature (Write, Read, Space);
   end Console;
end Keel.Bus.UART.STM32G4;
