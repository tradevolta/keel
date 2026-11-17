--  SPDX-License-Identifier: Apache-2.0
--  Keel.DMA on the STM32G474: DMA1's eight channels. A channel
--  moves up to 65 535 elements between a peripheral's register and
--  RAM, paced by the request DMAMUX1 routes to it, or from RAM to
--  RAM as fast as the bus goes. Circular mode starts again from the
--  first element, so a ring is any length, on any address; there is
--  no chaining. Each channel has its own interrupt, which counts
--  rounds and signals the channel's event, as on the RP2350.
with Keel.Interrupts; use type Keel.Interrupts.IRQ;

package Keel.DMA.STM32G4 is
   type Channel is range 1 .. 8;

   --  DMA1_Channel1_IRQn .. DMA1_Channel8_IRQn (ST's CMSIS header,
   --  stm32g474xx.h; the device's SVD file agrees)
   function IRQ (Ch : Channel) return Keel.Interrupts.IRQ is
     (if Ch = 8 then 96 else 10 + Keel.Interrupts.IRQ (Ch));

   --  DMAMUX1's request inputs (RM0440 Rev 9, 13.3.2, Table 93)
   type Request is range 0 .. 127;
   Memory_To_Memory : constant Request := 0;
   ADC1_Request     : constant Request := 5;
   SPI1_RX_Request  : constant Request := 10;
   SPI1_TX_Request  : constant Request := 11;

   subtype Count_16 is DMA.Count range 0 .. 65_535;

   type Transfer is record
      From, To : Region := No_Region;
      Size     : Element_Size := Word;
      Count    : Count_16 := 0;
      Paced_By : Request := Memory_To_Memory;
      --  Start again from the first element after the last
      Circular : Boolean := False;
      --  The interrupt and the event: at the end of each round, and
      --  with Halves at the middle too
      Notify   : Boolean := True;
      Halves   : Boolean := False;
   end record;

   --  T can run: from RAM to RAM, unpaced and once; or between a
   --  register and RAM, paced, where the RAM end holds Count
   --  elements (the ring, if Circular)
   function Valid (T : Transfer) return Boolean is
     (T.Count > 0
      and then
        (if T.Paced_By = Memory_To_Memory then
           not T.Circular
           and then Fits (T.From, T.Size, T.Count, 0)
           and then Fits (T.To, T.Size, T.Count, 0)
         else
           (Is_Register (T.From) and then Aligned (T.From, T.Size)
            and then Fits (T.To, T.Size, T.Count, 0))
           or else
           (Is_Register (T.To) and then Aligned (T.To, T.Size)
            and then Fits (T.From, T.Size, T.Count, 0))));

   --  Clock DMA1 and DMAMUX1; each claimed channel's interrupt at P
   procedure Enable (P : Keel.Interrupts.Priority := 8)
     with Post => Is_Enabled;
   function Is_Enabled return Boolean;

   procedure Claim (Ch : Channel; Stat : out Status)
     with Pre  => Is_Enabled,
          Post => (if Stat = Ok then Is_Claimed (Ch));
   function Is_Claimed (Ch : Channel) return Boolean;

   --  Not_Supported: T isn't Valid
   procedure Start (Ch : Channel; T : Transfer; Stat : out Status)
     with Pre => Is_Claimed (Ch) and then not Is_Busy (Ch);

   function Is_Busy (Ch : Channel) return Boolean;
   --  A bus error stopped Ch (TEIF): the hardware cleared EN
   function Failed (Ch : Channel) return Boolean;

   --  Elements still to go in this round (CNDTR)
   function Remaining (Ch : Channel) return Natural;

   --  Ends of rounds, and of halves with Halves, since Start
   function Rounds (Ch : Channel) return Natural;

   procedure Wait_Round (Ch : Channel)
     with Pre => Is_Claimed (Ch);

   --  Sleep until Ch has finished (not Circular, with Notify)
   procedure Wait (Ch : Channel; Done : out Receipt)
     with Pre => Is_Claimed (Ch);

   --  Clear EN: the channel stops after the element on the bus
   procedure Stop (Ch : Channel; Done : out Receipt)
     with Pre  => Is_Claimed (Ch),
          Post => not Is_Busy (Ch);
end Keel.DMA.STM32G4;
