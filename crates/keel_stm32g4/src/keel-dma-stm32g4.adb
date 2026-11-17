--  SPDX-License-Identifier: Apache-2.0
with Interfaces;              use Interfaces;
with Keel.Sync.Bare;          use Keel.Sync.Bare;
with STM32G4_SVD;             use STM32G4_SVD;
with STM32G4_SVD.DMA;         use STM32G4_SVD.DMA;
with STM32G4_SVD.DMA_Channels;
with STM32G4_SVD.DMAMUX;      use STM32G4_SVD.DMAMUX;
with STM32G4_SVD.RCC;         use STM32G4_SVD.RCC;

package body Keel.DMA.STM32G4 is

   package Regs renames STM32G4_SVD.DMA_Channels;

   type Channel_Set is array (Channel) of Boolean;
   type Transfer_Array is array (Channel) of Transfer;
   type Event_Array is array (Channel) of Event;
   type Count_Array is array (Channel) of Natural
     with Volatile_Components;

   Claimed : Channel_Set := [others => False];
   Powered : Boolean := False;
   Level   : Keel.Interrupts.Priority := 8;
   Current : Transfer_Array;
   Ended   : Event_Array;
   Done_N  : Count_Array := [others => 0];

   function Is_Enabled return Boolean is (Powered);
   function Is_Claimed (Ch : Channel) return Boolean is (Claimed (Ch));

   function R (Ch : Channel) return Regs.Channel is (Regs.Channel (Ch));

   --  Ch's four flags in ISR and IFCR: GIF, TCIF, HTIF, TEIF
   function Shift (Ch : Channel) return Natural is
     (4 * (Natural (Ch) - 1));
   TC_Bit : constant := 2#0010#;
   HT_Bit : constant := 2#0100#;
   TE_Bit : constant := 2#1000#;
   All_4  : constant := 2#1111#;

   function Flags_Of (Ch : Channel) return Unsigned_32 is
     (Shift_Right (Unsigned_32 (Regs.Flags), Shift (Ch)) and All_4);

   procedure Clear (Ch : Channel) is
   begin
      Regs.Clear_Flags :=
        UInt32 (Shift_Left (Unsigned_32 (All_4), Shift (Ch)));
   end Clear;

   --  One handler for each channel: count, clear, signal
   procedure Handle (Ch : Channel) is
      F : constant Unsigned_32 := Flags_Of (Ch);
   begin
      Clear (Ch);
      if (F and (TC_Bit or HT_Bit or TE_Bit)) /= 0 then
         Done_N (Ch) := Done_N (Ch) + 1;
         Signal (Ended (Ch));
      end if;
   end Handle;

   procedure ISR_1 with Export, Convention => C,
     External_Name => "keel_isr_11";
   procedure ISR_2 with Export, Convention => C,
     External_Name => "keel_isr_12";
   procedure ISR_3 with Export, Convention => C,
     External_Name => "keel_isr_13";
   procedure ISR_4 with Export, Convention => C,
     External_Name => "keel_isr_14";
   procedure ISR_5 with Export, Convention => C,
     External_Name => "keel_isr_15";
   procedure ISR_6 with Export, Convention => C,
     External_Name => "keel_isr_16";
   procedure ISR_7 with Export, Convention => C,
     External_Name => "keel_isr_17";
   procedure ISR_8 with Export, Convention => C,
     External_Name => "keel_isr_96";

   procedure ISR_1 is begin Handle (1); end ISR_1;
   procedure ISR_2 is begin Handle (2); end ISR_2;
   procedure ISR_3 is begin Handle (3); end ISR_3;
   procedure ISR_4 is begin Handle (4); end ISR_4;
   procedure ISR_5 is begin Handle (5); end ISR_5;
   procedure ISR_6 is begin Handle (6); end ISR_6;
   procedure ISR_7 is begin Handle (7); end ISR_7;
   procedure ISR_8 is begin Handle (8); end ISR_8;

   procedure Enable (P : Keel.Interrupts.Priority := 8) is
   begin
      RCC_Periph.RCC_AHB1ENR :=
        (RCC_Periph.RCC_AHB1ENR with delta
           DMA1EN => B_0x1, DMAMUX1EN => B_0x1);
      --  The clock starts two cycles after its enable bit is set
      --  (RM0440 Rev 9, 7.2.17): read the bit back first
      declare
         Back : constant RCC_AHB1ENR_Register := RCC_Periph.RCC_AHB1ENR
           with Unreferenced;
      begin
         null;
      end;
      Level := P;
      Powered := True;
   end Enable;

   procedure Claim (Ch : Channel; Stat : out Status) is
   begin
      if Claimed (Ch) then
         Stat := In_Use;
      else
         Claimed (Ch) := True;
         Keel.Interrupts.Set_Priority (IRQ (Ch), Level);
         Keel.Interrupts.Enable (IRQ (Ch));
         Stat := Ok;
      end if;
   end Claim;

   function Size_Code (S : Element_Size) return CCR_PSIZE_Field is
     (case S is when Byte => 0, when Half_Word => 1, when Word => 2);

   procedure Start (Ch : Channel; T : Transfer; Stat : out Status) is
      C : Regs.Channel_Registers renames Regs.Channels (R (Ch));
      --  The peripheral side: the register, or for RAM to RAM the
      --  source (DIR = 0 reads from CPAR, as ST's HAL sets it)
      To_Register : constant Boolean :=
        T.Paced_By /= Memory_To_Memory and then Is_Register (T.To);
      Periph : constant Region :=
        (if To_Register then T.To else T.From);
      Memory : constant Region :=
        (if To_Register then T.From else T.To);
   begin
      if not Valid (T) then
         Stat := Not_Supported;
         return;
      end if;
      Current (Ch) := T;
      Done_N (Ch) := 0;
      if Is_Set (Ended (Ch)) then
         Wait (Ended (Ch));
      end if;
      --  CCR, CPAR, CMAR and CNDTR are written only while EN is off
      C.CCR := (EN => False, others => <>);
      Clear (Ch);
      Regs.Requests (R (Ch)) :=
        (DMAREQ_ID => C0CR_DMAREQ_ID_Field (T.Paced_By), others => <>);
      C.CPAR := UInt32 (Start (Periph));
      C.CMAR := UInt32 (Start (Memory));
      C.CNDTR := (NDT => CNDTR_NDT_Field (T.Count), others => <>);
      C.CCR :=
        (EN      => True,
         TCIE    => T.Notify,
         HTIE    => T.Notify and then T.Halves,
         TEIE    => True,
         DIR     => To_Register,
         CIRC    => T.Circular,
         PINC    => not Is_Register (Periph),
         MINC    => True,
         PSIZE   => Size_Code (T.Size),
         MSIZE   => Size_Code (T.Size),
         PL      => 0,
         MEM2MEM => T.Paced_By = Memory_To_Memory,
         others  => <>);
      Stat := Ok;
   end Start;

   function Is_Busy (Ch : Channel) return Boolean is
     (Regs.Channels (R (Ch)).CCR.EN
      and then Regs.Channels (R (Ch)).CNDTR.NDT /= 0);

   function Failed (Ch : Channel) return Boolean is
     ((Flags_Of (Ch) and TE_Bit) /= 0);

   function Remaining (Ch : Channel) return Natural is
     (Natural (Regs.Channels (R (Ch)).CNDTR.NDT));

   function Rounds (Ch : Channel) return Natural is (Done_N (Ch));

   procedure Wait_Round (Ch : Channel) is
   begin
      Wait (Ended (Ch));
   end Wait_Round;

   function Receipt_For (Ch : Channel; Moved : Count) return Receipt is
     ((From => Current (Ch).From, To => Current (Ch).To,
       Done => Moved));

   procedure Wait (Ch : Channel; Done : out Receipt) is
   begin
      if Current (Ch).Notify then
         Wait (Ended (Ch));
      end if;
      loop
         exit when not Is_Busy (Ch);
      end loop;
      Done := Receipt_For (Ch, Current (Ch).Count - Remaining (Ch));
   end Wait;

   procedure Stop (Ch : Channel; Done : out Receipt) is
      C : Regs.Channel_Registers renames Regs.Channels (R (Ch));
   begin
      C.CCR := (C.CCR with delta EN => False);
      Clear (Ch);
      Done := Receipt_For (Ch, Current (Ch).Count - Remaining (Ch));
   end Stop;
end Keel.DMA.STM32G4;
