--  SPDX-License-Identifier: Apache-2.0
with Keel.PIO.Assembler;
with Keel.PIO.OneWire_Program;
with Keel.Time.Bare;

package body Keel.OneWire.RP2350 is
   use type Keel.Time.Time;
   use type Keel.PIO.Address;
   use type Keel.PIO.Word;

   package Asm is new Keel.PIO.Assembler;
   package Code renames Keel.PIO.OneWire_Program;

   procedure Open
     (Wire     : in out Bus;
      Clock_Hz : Positive;
      Stat     : out Keel.Status)
   is
      --  1 MHz: a cycle a microsecond
      Clock : constant Keel.PIO.Divider :=
        Keel.PIO.Divider_For (Clock_Hz, 1_000_000);
   begin
      Claim (Wire.B, Wire.M, Stat);
      if Stat = Keel.Ok then
         Use_Pin (Wire.B, Wire.Pin, Stat);
      end if;
      if Stat = Keel.Ok then
         Load (Wire.B, Code.Code, Wire.Offset, Stat);
      end if;
      if Stat /= Keel.Ok then
         return;
      end if;
      Configure
        (Wire.B, Wire.M, Code.Code, Wire.Offset,
         (Clock          => Clock,
          Set_Base       => Wire.Pin,
          Set_Count      => 1,
          In_Base        => Wire.Pin,
          --  A bit a word each way, in bit 0
          Out_Shift      => Shift_Right,
          In_Shift       => Shift_Left,
          Autopull       => True,
          Pull_Threshold => 1,
          Autopush       => True,
          Push_Threshold => 1,
          others         => <>));
      --  Open drain: the level is always 0; the direction drives it
      Set_Pins (Wire.B, Wire.M, Wire.Pin, 1, 0);
      Set_Directions (Wire.B, Wire.M, Wire.Pin, 1, 0);
      Start (Wire.B, Wire.M);
      Wire.Open := True;
   end Open;

   procedure Reset
     (Wire : in out Bus; Present : out Boolean; Stat : out Status)
   is
      W      : Keel.PIO.Word;
      Result : Keel.Status;
   begin
      --  Stop the machine, wherever it waits, empty its FIFOs and
      --  start it again at the program's Reset
      Stop (Wire.B, Wire.M);
      Restart (Wire.B, Wire.M);
      Execute (Wire.B, Wire.M,
               Asm.Jmp (Wire.Offset + Code.Reset));
      Start (Wire.B, Wire.M);
      Get (Wire.B, Wire.M, W,
           Keel.Time.Bare.Clock + Reset_Wait, Result);
      --  The bus low at the sample: a device is there
      Present := Result = Keel.Ok and then W mod 2 = 0;
      Stat := (if Result = Keel.Ok then Ok else Timeout);
   end Reset;

   procedure Touch
     (Wire : in out Bus; Bit : Boolean; Got : out Boolean;
      Stat : out Status)
   is
      W      : Keel.PIO.Word;
      Result : Keel.Status;
   begin
      Put (Wire.B, Wire.M, (if Bit then 1 else 0));
      Get (Wire.B, Wire.M, W,
           Keel.Time.Bare.Clock + Slot_Wait, Result);
      Got := Result = Keel.Ok and then W mod 2 = 1;
      Stat := (if Result = Keel.Ok then Ok else Timeout);
   end Touch;
end Keel.OneWire.RP2350;
