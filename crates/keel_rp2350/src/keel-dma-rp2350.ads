--  SPDX-License-Identifier: Apache-2.0
--  Keel.DMA on the RP2350: 16 channels, each moving one transfer at
--  a time, paced by a peripheral's DREQ or as fast as the bus goes.
--  Every channel's end-of-round interrupt goes to DMA_IRQ_0, whose
--  handler counts the round and signals the channel's event; Wait
--  sleeps on that event. A transfer's ends are Keel.DMA regions,
--  so the RAM it touches is a lent buffer, and Wait and Stop hand
--  back the receipt that returns it.
with Keel.Interrupts;
with Keel.Time;

package Keel.DMA.RP2350 is
   type Channel is range 0 .. 15;

   --  DMA_IRQ_0 (datasheet 3.2, Table 95)
   IRQ : constant Keel.Interrupts.IRQ := 10;

   --  What paces a transfer: a peripheral's DREQ (datasheet 12.6.4.1,
   --  Table 1254), a pacing timer (59 to 62), or nothing (63)
   type Request is range 0 .. 63;
   ADC_Request : constant Request := 48;
   Unpaced     : constant Request := 63;

   --  Once: Count elements, then stop. Repeat: Count elements, then
   --  go on from where it got to; each round ends with the event and
   --  the chain. Endless: the count never runs down, and no round
   --  ever ends (datasheet 12.6.2.2.1).
   type Count_Mode is (Once, Repeat, Endless);

   type Transfer is record
      From, To : Region := No_Region;
      Size     : Element_Size := Word;
      Count    : DMA.Count := 0;
      Paced_By : Request := Unpaced;
      Mode     : Count_Mode := Once;
      --  A ring of 2**Wrap bytes on the end in RAM (To, if both are)
      Wrap     : Ring_Bits := 0;
      --  At the end, start Chain_To, which Prepare has set up
      Chain    : Boolean := False;
      Chain_To : Channel := 0;
      --  At the end of each round: the interrupt, the event
      Notify   : Boolean := True;
   end record;

   --  The ring is on To if To is in RAM, else on From
   function Ring_On_To (T : Transfer) return Boolean is
     (not Is_Register (T.To));

   --  T can run: each end fits it, a ring end is the whole ring, and
   --  a transfer that goes round again has its only RAM end in a
   --  ring. Count is not 0 (a chain from an empty transfer may not
   --  fire: erratum RP2350-E8).
   function Valid (T : Transfer) return Boolean is
     (T.Count > 0
      and then (if Is_Register (T.From) then Aligned (T.From, T.Size)
                else Fits (T.From, T.Size, T.Count,
                           (if Ring_On_To (T) then 0 else T.Wrap)))
      and then (if Is_Register (T.To) then Aligned (T.To, T.Size)
                else Fits (T.To, T.Size, T.Count, T.Wrap))
      and then (T.Mode = Once
                or else (T.Wrap > 0
                         and then (Is_Register (T.From)
                                   or else Is_Register (T.To)))));

   --  Take the DMA out of reset; DMA_IRQ_0 on, at priority P
   procedure Enable (P : Keel.Interrupts.Priority := 8)
     with Post => Is_Enabled;
   function Is_Enabled return Boolean;

   --  In_Use: Ch has another owner
   procedure Claim (Ch : Channel; Stat : out Status)
     with Pre  => Is_Enabled,
          Post => (if Stat = Ok then Is_Claimed (Ch));
   function Is_Claimed (Ch : Channel) return Boolean;

   --  Set Ch up for T and start it. Not_Supported: T isn't Valid,
   --  or chains to Ch itself.
   procedure Start (Ch : Channel; T : Transfer; Stat : out Status)
     with Pre => Is_Claimed (Ch) and then not Is_Busy (Ch);

   --  The same, but don't start it: a chain, or Start_Now, does
   procedure Prepare (Ch : Channel; T : Transfer; Stat : out Status)
     with Pre => Is_Claimed (Ch) and then not Is_Busy (Ch);
   procedure Start_Now (Ch : Channel)
     with Pre => Is_Claimed (Ch);

   function Is_Busy (Ch : Channel) return Boolean;
   --  A bus error stopped Ch (datasheet 12.6.7)
   function Failed (Ch : Channel) return Boolean;

   --  How far Ch has got through To (through From, if To is a
   --  register): bytes from its start, or from the ring's start
   function Position (Ch : Channel) return Natural
     with Pre => Is_Claimed (Ch);

   --  Rounds that Ch has finished since its Start, counted by the
   --  interrupt handler
   function Rounds (Ch : Channel) return Natural;

   --  Sleep until Ch's next round ends (Repeat mode)
   procedure Wait_Round (Ch : Channel)
     with Pre => Is_Claimed (Ch);

   --  Sleep until Ch has finished (Once mode, with Notify). Done
   --  covers its two ends.
   procedure Wait (Ch : Channel; Done : out Receipt)
     with Pre => Is_Claimed (Ch);

   --  The same, but not past Deadline. Timeout: Ch is still going,
   --  and Done covers nothing; Stop it to take its buffers back.
   procedure Wait
     (Ch : Channel; Deadline : Keel.Time.Time; Done : out Receipt;
      Stat : out Status)
     with Pre => Is_Claimed (Ch);

   --  Stop Ch now, wherever it is, and wait until nothing of it is
   --  left on the bus (datasheet 12.6.8.3, erratum RP2350-E5)
   procedure Stop (Ch : Channel; Done : out Receipt)
     with Pre  => Is_Claimed (Ch),
          Post => not Is_Busy (Ch);

   --  Bus priority for the DMA's read and write ports over the
   --  cores (datasheet 2.1.1). On the APB and fast-peripheral
   --  arbiters the bits are wired to the wrong managers (erratum
   --  RP2350-E27): this sets the priority for SRAM, ROM and XIP.
   procedure Favour_DMA (On : Boolean);
end Keel.DMA.RP2350;
