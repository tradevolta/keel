--  SPDX-License-Identifier: Apache-2.0
--  Keel.PIO on the RP2350: three PIO blocks, each with 32 instruction
--  slots shared by four state machines (datasheet, 11.1). Load puts a
--  Keel.PIO program in a block's free slots and moves its jumps;
--  Configure sets a state machine up to run it, and Start runs it.
--  A pin a block drives is given to it with Use_Pin.
with Keel.GPIO.RP2350;
with Keel.Time;

package Keel.PIO.RP2350 is
   type Block is range 0 .. 2;
   type Machine is range 0 .. 3;
   subtype Pin_Id is Keel.GPIO.RP2350.Pin_Id;

   --  Take block B out of reset, with all 32 slots free
   procedure Enable (B : Block)
     with Post => Is_Enabled (B);
   function Is_Enabled (B : Block) return Boolean;

   --  Put P in the first run of P.Last + 1 free slots of B, its JMPs
   --  moved by Offset, where it starts. Not_Supported: no room.
   procedure Load
     (B : Block; P : Program; Offset : out Address; Stat : out Status)
     with Pre  => Is_Enabled (B) and then Well_Formed (P),
          Post => (if Stat = Ok
                   then Integer (Offset) + Integer (P.Last) <= 31);

   --  In_Use: M of B has another owner
   procedure Claim (B : Block; M : Machine; Stat : out Status)
     with Pre  => Is_Enabled (B),
          Post => (if Stat = Ok then Is_Claimed (B, M));
   function Is_Claimed (B : Block; M : Machine) return Boolean;

   --  Reserve pin Id and connect it to block B (function PIO0, PIO1
   --  or PIO2). In_Use: the pin has an owner.
   procedure Use_Pin (B : Block; Id : Pin_Id; Stat : out Status)
     with Pre => Is_Enabled (B)
                 and then Keel.GPIO.RP2350.Is_Enabled;

   type Direction is (Shift_Left, Shift_Right);
   --  Join the FIFOs into one of 8 words, for TX or for RX
   type FIFO_Join is (No_Join, Join_TX, Join_RX);
   subtype Threshold is Positive range 1 .. 32;

   --  How a state machine runs: its clock, its pins (each a base and
   --  a count), how its shift registers shift, and when it pulls and
   --  pushes on its own
   type Machine_Config is record
      Clock          : Divider := (Int => 1, Frac => 0);
      Out_Base       : Pin_Id := 0;
      Out_Count      : Natural range 0 .. 32 := 0;
      Set_Base       : Pin_Id := 0;
      Set_Count      : Natural range 0 .. 5 := 0;
      Side_Base      : Pin_Id := 0;
      In_Base        : Pin_Id := 0;
      Jmp_Pin        : Pin_Id := 0;
      Out_Shift      : Direction := Shift_Right;
      In_Shift       : Direction := Shift_Right;
      Autopull       : Boolean := False;
      Pull_Threshold : Threshold := 32;
      Autopush       : Boolean := False;
      Push_Threshold : Threshold := 32;
      FIFO           : FIFO_Join := No_Join;
   end record;

   --  Stop M, set it up for P loaded at Offset (its wrap and its
   --  side-set come from P), empty its FIFOs, restart it and its
   --  clock, and jump to Offset. It runs from there at Start.
   procedure Configure
     (B      : Block;
      M      : Machine;
      P      : Program;
      Offset : Address;
      Config : Machine_Config)
     with Pre => Is_Claimed (B, M)
                 and then Integer (Offset) + Integer (P.Last) <= 31;

   --  Empty M's FIFOs and restart it (CTRL's SM_RESTART): the ISR,
   --  the shift counters, the delay and any stalled instruction are
   --  cleared, and the next OUT pulls. The OSR, X, Y and PC stay.
   procedure Restart (B : Block; M : Machine)
     with Pre => Is_Claimed (B, M);

   procedure Start (B : Block; M : Machine)
     with Pre => Is_Claimed (B, M);
   procedure Stop (B : Block; M : Machine)
     with Pre => Is_Claimed (B, M);

   --  Run I at once, without its delay (datasheet 11.5.7). A JMP
   --  moves the program counter; a stopped machine stays stopped.
   procedure Execute (B : Block; M : Machine; I : Instruction)
     with Pre => Is_Claimed (B, M);

   --  Drive Count pins from Base to the bits of Value, or set their
   --  directions (1: output), with forced SET instructions. Count is
   --  at most 5. Call it before Start: it borrows PINCTRL.
   procedure Set_Pins
     (B : Block; M : Machine; Base : Pin_Id; Count : Positive;
      Value : Natural)
     with Pre => Is_Claimed (B, M) and then Count <= 5
                 and then Value < 2**Count;
   procedure Set_Directions
     (B : Block; M : Machine; Base : Pin_Id; Count : Positive;
      Outputs : Natural)
     with Pre => Is_Claimed (B, M) and then Count <= 5
                 and then Outputs < 2**Count;

   --  The FIFOs
   function TX_Full (B : Block; M : Machine) return Boolean;
   function TX_Empty (B : Block; M : Machine) return Boolean;
   function RX_Empty (B : Block; M : Machine) return Boolean;

   --  Put W in M's TX FIFO, waiting while it is full
   procedure Put (B : Block; M : Machine; W : Word)
     with Pre => Is_Claimed (B, M);

   --  Take a word from M's RX FIFO, waiting for one until Deadline.
   --  Timeout: none came. Needs Keel.Time.Bare started.
   procedure Get
     (B        : Block;
      M        : Machine;
      W        : out Word;
      Deadline : Keel.Time.Time;
      Stat     : out Status)
     with Pre => Is_Claimed (B, M);

   --  Wait until M's TX FIFO is empty, until Deadline. The last
   --  word is then in the machine, still going out. Timeout: not by
   --  Deadline. Needs Keel.Time.Bare started.
   procedure Wait_Empty
     (B        : Block;
      M        : Machine;
      Deadline : Keel.Time.Time;
      Stat     : out Status)
     with Pre => Is_Claimed (B, M);
end Keel.PIO.RP2350;
