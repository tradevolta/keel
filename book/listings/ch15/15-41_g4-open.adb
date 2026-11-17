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
   --  The clock starts two cycles after its enable bit is set
   --  (RM0440 Rev 9, 7.2.17): read the bit back before the first
   --  access to the LPUART, as ST's HAL does
   declare
      Back : constant RCC_APB1ENR2_Register :=
        RCC_Periph.RCC_APB1ENR2
        with Unreferenced;
   begin
      null;
   end;
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
   Opened := True;
   How_It := How;
   BRR_In := D;
   R.CR1.UE := True;
   if How = Interrupt then
      Keel.Interrupts.Set_Priority (IRQ, Priority);
      Keel.Interrupts.Enable (IRQ);
   end if;
   Stat := Ok;
end Open;
