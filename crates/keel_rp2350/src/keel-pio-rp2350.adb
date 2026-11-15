--  SPDX-License-Identifier: Apache-2.0
with RP2350_SVD;               use RP2350_SVD;
with RP2350_SVD.Atomic;
with RP2350_SVD.PIO0;          use RP2350_SVD.PIO0;
with RP2350_SVD.PIO_Blocks;    use RP2350_SVD.PIO_Blocks;
with RP2350_SVD.RESETS;        use RP2350_SVD.RESETS;
with Keel.PIO.Assembler;
with Keel.Time.Bare;

package body Keel.PIO.RP2350 is

   package Reset_Bits is new RP2350_SVD.Atomic (RESET_Register);
   package Ctrl_Bits is new RP2350_SVD.Atomic (CTRL_Register);
   --  For forced instructions: no side-set
   package Asm is new Keel.PIO.Assembler;

   type Block_Access is access all Block_Registers;
   Blocks : constant array (Block) of Block_Access :=
     [PIO_Blocks.PIO0'Access, PIO_Blocks.PIO1'Access,
      PIO_Blocks.PIO2'Access];

   type Slot_Use is array (Address) of Boolean;
   type Machine_Use is array (Machine) of Boolean;

   Powered : array (Block) of Boolean := [others => False];
   Used    : array (Block) of Slot_Use := [others => [others => False]];
   Claimed : array (Block) of Machine_Use :=
     [others => [others => False]];

   function Bit (M : Machine) return UInt4 is (2**Natural (M));

   function Regs (B : Block) return Block_Access is (Blocks (B));

   function Is_Enabled (B : Block) return Boolean is (Powered (B));
   function Is_Claimed (B : Block; M : Machine) return Boolean is
     (Claimed (B) (M));

   procedure Enable (B : Block) is
      Mask : RESET_PIO_Field_Array := [others => False];
   begin
      Mask (Natural (B)) := True;
      Reset_Bits.Clear
        (RESETS_Periph.RESET,
         (Reset_Bits.No_Bits with delta
            PIO => (As_Array => True, Arr => Mask)));
      loop
         exit when RESETS_Periph.RESET_DONE.PIO.Arr (Natural (B));
      end loop;
      Used (B) := [others => False];
      Powered (B) := True;
   end Enable;

   procedure Load
     (B : Block; P : Program; Offset : out Address; Stat : out Status)
   is
      Length : constant Natural := Natural (P.Last) + 1;
   begin
      Offset := 0;
      Stat := Not_Supported;
      --  The first run of Length free slots
      for First in 0 .. 32 - Length loop
         if (for all S in First .. First + Length - 1 =>
               not Used (B) (Address (S)))
         then
            Offset := Address (First);
            Stat := Ok;
            exit;
         end if;
      end loop;
      if Stat = Ok then
         for I in P.Code'Range loop
            Regs (B).INSTR_MEM (Slot (Offset + I)) :=
              (INSTR_MEM0 => UInt16 (Relocated (P.Code (I), Offset)),
               others     => <>);
            Used (B) (Offset + I) := True;
         end loop;
      end if;
   end Load;

   procedure Claim (B : Block; M : Machine; Stat : out Status) is
   begin
      if Claimed (B) (M) then
         Stat := In_Use;
      else
         Claimed (B) (M) := True;
         Stat := Ok;
      end if;
   end Claim;

   procedure Use_Pin (B : Block; Id : Pin_Id; Stat : out Status) is
   begin
      Keel.GPIO.RP2350.Reserve (Id, Stat);
      if Stat = Ok then
         --  PIO0 is function 6, PIO1 7, PIO2 8 (9.4, Table 677)
         Keel.GPIO.RP2350.Select_Function
           (Id, Keel.GPIO.RP2350.Function_Number (6 + Natural (B)));
      end if;
   end Use_Pin;

   --  IN, OUT and the thresholds encode 32 as 0
   function Count_Field (N : Natural) return UInt5 is
     (UInt5 (N mod 32));

   --  Flipping FJOIN_RX empties both FIFOs; flip it back
   procedure Clear_FIFOs (R : in out Machine_Registers) is
      Join : constant Boolean := R.SHIFTCTRL.FJOIN_RX;
   begin
      R.SHIFTCTRL := (R.SHIFTCTRL with delta FJOIN_RX => not Join);
      R.SHIFTCTRL := (R.SHIFTCTRL with delta FJOIN_RX => Join);
   end Clear_FIFOs;

   procedure Configure
     (B      : Block;
      M      : Machine;
      P      : Program;
      Offset : Address;
      Config : Machine_Config)
   is
      R : Machine_Registers renames
        Regs (B).SM (PIO_Blocks.Machine (M));
   begin
      Stop (B, M);
      R.CLKDIV :=
        (INT => UInt16 (Config.Clock.Int mod 65_536),
         FRAC => Byte (Config.Clock.Frac), others => <>);
      R.EXECCTRL :=
        (WRAP_BOTTOM => UInt5 (Offset + P.Wrap_Target),
         WRAP_TOP    => UInt5 (Offset + P.Wrap),
         JMP_PIN     => UInt5 (Config.Jmp_Pin),
         SIDE_EN     => P.Side_Optional,
         others      => <>);
      R.SHIFTCTRL :=
        (AUTOPUSH     => Config.Autopush,
         AUTOPULL     => Config.Autopull,
         IN_SHIFTDIR  => Config.In_Shift = Shift_Right,
         OUT_SHIFTDIR => Config.Out_Shift = Shift_Right,
         PUSH_THRESH  => Count_Field (Config.Push_Threshold),
         PULL_THRESH  => Count_Field (Config.Pull_Threshold),
         FJOIN_TX     => Config.FIFO = Join_TX,
         FJOIN_RX     => Config.FIFO = Join_RX,
         others       => <>);
      R.PINCTRL :=
        (OUT_BASE      => UInt5 (Config.Out_Base),
         OUT_COUNT     => UInt6 (Config.Out_Count),
         SET_BASE      => UInt5 (Config.Set_Base),
         SET_COUNT     => UInt3 (Config.Set_Count),
         SIDESET_BASE  => UInt5 (Config.Side_Base),
         --  The count includes the enable bit (11.7, PINCTRL)
         SIDESET_COUNT =>
           UInt3 (P.Side_Bits + Boolean'Pos (P.Side_Optional)),
         IN_BASE       => UInt5 (Config.In_Base));
      --  Changing FJOIN empties the FIFOs; set it again to be sure
      Restart (B, M);
      Ctrl_Bits.Set
        (Regs (B).CTRL,
         (Ctrl_Bits.No_Bits with delta CLKDIV_RESTART => Bit (M)));
      Execute (B, M, Asm.Jmp (Offset));
   end Configure;

   procedure Restart (B : Block; M : Machine) is
   begin
      Clear_FIFOs (Regs (B).SM (PIO_Blocks.Machine (M)));
      Ctrl_Bits.Set
        (Regs (B).CTRL,
         (Ctrl_Bits.No_Bits with delta SM_RESTART => Bit (M)));
   end Restart;

   procedure Start (B : Block; M : Machine) is
   begin
      Ctrl_Bits.Set
        (Regs (B).CTRL,
         (Ctrl_Bits.No_Bits with delta SM_ENABLE => Bit (M)));
   end Start;

   procedure Stop (B : Block; M : Machine) is
   begin
      Ctrl_Bits.Clear
        (Regs (B).CTRL,
         (Ctrl_Bits.No_Bits with delta SM_ENABLE => Bit (M)));
   end Stop;

   procedure Execute (B : Block; M : Machine; I : Instruction) is
   begin
      Regs (B).SM (PIO_Blocks.Machine (M)).INSTR :=
        (SM0_INSTR => UInt16 (I), others => <>);
   end Execute;

   --  Run a forced SET with PINCTRL's SET pins at Base, Count, and
   --  no side-set, then put PINCTRL and EXECCTRL back
   procedure Forced_Set
     (B : Block; M : Machine; Base : Pin_Id; Count : Positive;
      I : Instruction)
   is
      R       : Machine_Registers renames
        Regs (B).SM (PIO_Blocks.Machine (M));
      Pins    : constant SM0_PINCTRL_Register := R.PINCTRL;
      Control : constant SM0_EXECCTRL_Register := R.EXECCTRL;
   begin
      R.PINCTRL :=
        (SET_BASE  => UInt5 (Base), SET_COUNT => UInt3 (Count),
         OUT_BASE  => 0, OUT_COUNT => 0, SIDESET_BASE => 0,
         SIDESET_COUNT => 0, IN_BASE => 0);
      R.EXECCTRL := (Control with delta SIDE_EN => False);
      Execute (B, M, I);
      R.PINCTRL := Pins;
      R.EXECCTRL := Control;
   end Forced_Set;

   procedure Set_Pins
     (B : Block; M : Machine; Base : Pin_Id; Count : Positive;
      Value : Natural) is
   begin
      Forced_Set (B, M, Base, Count, Asm.Set (Asm.Pins, Value));
   end Set_Pins;

   procedure Set_Directions
     (B : Block; M : Machine; Base : Pin_Id; Count : Positive;
      Outputs : Natural) is
   begin
      Forced_Set (B, M, Base, Count, Asm.Set (Asm.Pindirs, Outputs));
   end Set_Directions;

   function TX_Full (B : Block; M : Machine) return Boolean is
     ((Regs (B).FSTAT.TXFULL and Bit (M)) /= 0);
   function TX_Empty (B : Block; M : Machine) return Boolean is
     ((Regs (B).FSTAT.TXEMPTY and Bit (M)) /= 0);
   function RX_Empty (B : Block; M : Machine) return Boolean is
     ((Regs (B).FSTAT.RXEMPTY and Bit (M)) /= 0);

   procedure Put (B : Block; M : Machine; W : Word) is
   begin
      loop
         exit when not TX_Full (B, M);
      end loop;
      Regs (B).TXF (PIO_Blocks.Machine (M)) := UInt32 (W);
   end Put;

   procedure Get
     (B        : Block;
      M        : Machine;
      W        : out Word;
      Deadline : Keel.Time.Time;
      Stat     : out Status)
   is
      use type Keel.Time.Time;
   begin
      W := 0;
      loop
         if not RX_Empty (B, M) then
            W := Word (Regs (B).RXF (PIO_Blocks.Machine (M)));
            Stat := Ok;
            return;
         end if;
         if Keel.Time.Bare.Clock > Deadline then
            Stat := Timeout;
            return;
         end if;
      end loop;
   end Get;

   procedure Wait_Empty
     (B        : Block;
      M        : Machine;
      Deadline : Keel.Time.Time;
      Stat     : out Status)
   is
      use type Keel.Time.Time;
   begin
      loop
         if TX_Empty (B, M) then
            Stat := Ok;
            return;
         end if;
         if Keel.Time.Bare.Clock > Deadline then
            Stat := Timeout;
            return;
         end if;
      end loop;
   end Wait_Empty;
end Keel.PIO.RP2350;
