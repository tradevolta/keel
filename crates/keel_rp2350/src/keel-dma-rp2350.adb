--  SPDX-License-Identifier: Apache-2.0
with System.Storage_Elements;  use System.Storage_Elements;
with Keel.Sync.Bare;           use Keel.Sync.Bare;
with RP2350_SVD;               use RP2350_SVD;
with RP2350_SVD.Atomic;
with RP2350_SVD.BUSCTRL;       use RP2350_SVD.BUSCTRL;
with RP2350_SVD.DMA;           use RP2350_SVD.DMA;
with RP2350_SVD.DMA_Channels;
with RP2350_SVD.RESETS;        use RP2350_SVD.RESETS;

package body Keel.DMA.RP2350 is

   package Regs renames RP2350_SVD.DMA_Channels;
   package Reset_Bits is new RP2350_SVD.Atomic (RESET_Register);

   type Channel_Set is array (Channel) of Boolean;
   type Transfer_Array is array (Channel) of Transfer;
   type Event_Array is array (Channel) of Event;
   type Count_Array is array (Channel) of Natural
     with Volatile_Components;

   Claimed : Channel_Set := [others => False];
   Powered : Boolean := False;
   Current : Transfer_Array;
   --  Set by the handler at the end of each round
   Ended   : Event_Array;
   Done_N  : Count_Array := [others => 0];

   function Bit (Ch : Channel) return UInt16 is (2**Natural (Ch));

   function Is_Enabled return Boolean is (Powered);
   function Is_Claimed (Ch : Channel) return Boolean is (Claimed (Ch));

   function Regs_Of (Ch : Channel) return Regs.Channel is
     (Regs.Channel (Ch));

   --  DMA_IRQ_0: every channel's interrupt is routed here (INTE0).
   --  Clear what is pending, by writing it back to INTS0, then count
   --  and signal each channel in it (datasheet 12.6.5).
   procedure IRQ_0_Handler
     with Export, Convention => C, External_Name => "keel_isr_10";

   procedure IRQ_0_Handler is
      Pending : constant UInt16 := DMA_Periph.INTS0.INTS0;
   begin
      DMA_Periph.INTS0 := (INTS0 => Pending, others => <>);
      for Ch in Channel loop
         if (Pending and Bit (Ch)) /= 0 then
            Done_N (Ch) := Done_N (Ch) + 1;
            Signal (Ended (Ch));
         end if;
      end loop;
   end IRQ_0_Handler;

   procedure Enable (P : Keel.Interrupts.Priority := 8) is
   begin
      Reset_Bits.Clear
        (RESETS_Periph.RESET,
         (Reset_Bits.No_Bits with delta DMA => True));
      loop
         exit when RESETS_Periph.RESET_DONE.DMA;
      end loop;
      Keel.Interrupts.Set_Priority (IRQ, P);
      Keel.Interrupts.Enable (IRQ);
      Powered := True;
   end Enable;

   procedure Claim (Ch : Channel; Stat : out Status) is
   begin
      if Claimed (Ch) then
         Stat := In_Use;
      else
         Claimed (Ch) := True;
         Stat := Ok;
      end if;
   end Claim;

   --  The CTRL word that runs T on Ch
   function Control (Ch : Channel; T : Transfer)
     return Regs.CTRL_Register is
     (EN         => True,
      DATA_SIZE  => (case T.Size is
                       when Byte      => SIZE_BYTE,
                       when Half_Word => SIZE_HALFWORD,
                       when Word      => SIZE_WORD),
      INCR_READ  => not Is_Register (T.From),
      INCR_WRITE => not Is_Register (T.To),
      RING_SIZE  => UInt4 (T.Wrap),
      RING_SEL   => Ring_On_To (T),
      --  A channel that chains to itself doesn't chain
      CHAIN_TO   => UInt4 (if T.Chain then T.Chain_To else Ch),
      TREQ_SEL   => UInt6 (T.Paced_By),
      others     => <>);

   --  Everything but CTRL: the addresses, the count and its mode,
   --  and whether Ch's rounds reach DMA_IRQ_0
   procedure Set_Up (Ch : Channel; T : Transfer; Stat : out Status) is
      R : Regs.Channel_Registers renames Regs.Channels (Regs_Of (Ch));
      Mask : UInt16 := DMA_Periph.INTE0.INTE0;
   begin
      if not Valid (T) or else (T.Chain and then T.Chain_To = Ch) then
         Stat := Not_Supported;
         return;
      end if;
      Current (Ch) := T;
      Done_N (Ch) := 0;
      --  An event left from an earlier transfer: clear it
      if Is_Set (Ended (Ch)) then
         Wait (Ended (Ch));
      end if;
      Mask := (if T.Notify then Mask or Bit (Ch)
               else Mask and not Bit (Ch));
      DMA_Periph.INTE0 := (INTE0 => Mask, others => <>);
      R.READ_ADDR := UInt32 (Start (T.From));
      R.WRITE_ADDR := UInt32 (Start (T.To));
      R.TRANS_COUNT :=
        (COUNT => CH0_TRANS_COUNT_COUNT_Field (T.Count),
         MODE  => (case T.Mode is
                     when Once    => NORMAL,
                     when Repeat  => TRIGGER_SELF,
                     when Endless => ENDLESS));
      Stat := Ok;
   end Set_Up;

   --  CTRL_TRIG is alias 0's trigger: writing it starts the channel
   procedure Start (Ch : Channel; T : Transfer; Stat : out Status) is
   begin
      Set_Up (Ch, T, Stat);
      if Stat = Ok then
         Regs.Channels (Regs_Of (Ch)).CTRL_TRIG := Control (Ch, T);
      end if;
   end Start;

   --  Alias 1's CTRL is the same register, but no trigger
   procedure Prepare (Ch : Channel; T : Transfer; Stat : out Status)
   is
   begin
      Set_Up (Ch, T, Stat);
      if Stat = Ok then
         Regs.Channels (Regs_Of (Ch)).AL1_CTRL := Control (Ch, T);
      end if;
   end Prepare;

   procedure Start_Now (Ch : Channel) is
   begin
      DMA_Periph.MULTI_CHAN_TRIGGER :=
        (MULTI_CHAN_TRIGGER => Bit (Ch), others => <>);
   end Start_Now;

   function Is_Busy (Ch : Channel) return Boolean is
     (Regs.Channels (Regs_Of (Ch)).AL1_CTRL.BUSY);

   function Failed (Ch : Channel) return Boolean is
     (Regs.Channels (Regs_Of (Ch)).AL1_CTRL.AHB_ERROR);

   function Position (Ch : Channel) return Natural is
      T : Transfer renames Current (Ch);
      R : Regs.Channel_Registers renames Regs.Channels (Regs_Of (Ch));
   begin
      if Is_Register (T.To) then
         return Natural
           (Integer_Address (R.READ_ADDR) - Start (T.From));
      else
         return Natural
           (Integer_Address (R.WRITE_ADDR) - Start (T.To));
      end if;
   end Position;

   function Rounds (Ch : Channel) return Natural is (Done_N (Ch));

   procedure Wait_Round (Ch : Channel) is
   begin
      Wait (Ended (Ch));
   end Wait_Round;

   function Receipt_For (Ch : Channel) return Receipt is
     ((From => Current (Ch).From, To => Current (Ch).To,
       Done => Current (Ch).Count));

   procedure Wait (Ch : Channel; Done : out Receipt) is
   begin
      if Current (Ch).Notify then
         Wait (Ended (Ch));
      end if;
      --  The last writes may still be on the bus
      loop
         exit when not Is_Busy (Ch);
      end loop;
      Done := Receipt_For (Ch);
   end Wait;

   procedure Wait
     (Ch : Channel; Deadline : Keel.Time.Time; Done : out Receipt;
      Stat : out Status) is
   begin
      Done := (others => <>);
      Wait (Ended (Ch), Deadline, Stat);
      if Stat = Ok then
         loop
            exit when not Is_Busy (Ch);
         end loop;
         Done := Receipt_For (Ch);
      end if;
   end Wait;

   procedure Stop (Ch : Channel; Done : out Receipt) is
      T : Transfer renames Current (Ch);
      R : Regs.Channel_Registers renames Regs.Channels (Regs_Of (Ch));
      Left : constant Natural := Natural (R.TRANS_COUNT.COUNT);
   begin
      --  RP2350-E5: an aborted channel may fire its chain, or start
      --  again, unless it and the channel it chains to are disabled
      R.AL1_CTRL :=
        (R.AL1_CTRL with delta EN => False, CHAIN_TO => UInt4 (Ch));
      if T.Chain then
         Regs.Channels (Regs_Of (T.Chain_To)).AL1_CTRL :=
           (Regs.Channels (Regs_Of (T.Chain_To)).AL1_CTRL
            with delta EN => False);
      end if;
      DMA_Periph.CHAN_ABORT := (CHAN_ABORT => Bit (Ch), others => <>);
      loop
         exit when (DMA_Periph.CHAN_ABORT.CHAN_ABORT and Bit (Ch)) = 0;
      end loop;
      loop
         exit when not Is_Busy (Ch);
      end loop;
      Done := Receipt_For (Ch);
      Done.Done :=
        (if T.Mode = Once then T.Count - Natural'Min (Left, T.Count)
         else Position (Ch) / Bytes (T.Size));
   end Stop;

   procedure Favour_DMA (On : Boolean) is
   begin
      BUSCTRL_Periph.BUS_PRIORITY :=
        (DMA_R => On, DMA_W => On, others => <>);
   end Favour_DMA;
end Keel.DMA.RP2350;
