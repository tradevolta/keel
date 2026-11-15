--  SPDX-License-Identifier: Apache-2.0
with Keel.PIO.WS2812_Program;
with Keel.Time.Bare;

package body Keel.PIO.RP2350.WS2812 is
   use type Keel.Time.Time;

   package Code renames Keel.PIO.WS2812_Program;

   Bit_Rate : constant := 800_000;
   --  When the queue is empty, the last pixel has just gone into the
   --  machine, behind at most one bit of the one before: 25 bits at
   --  1.25 us each, rounded up
   Pixel_Time : constant Keel.Time.Time_Span :=
     Keel.Time.Microseconds (32);

   procedure Open
     (S : in out Strip; Clock_Hz : Positive; Stat : out Status)
   is
      Offset : Address;
   begin
      Claim (S.B, S.M, Stat);
      if Stat = Ok then
         Use_Pin (S.B, S.Pin, Stat);
      end if;
      if Stat = Ok then
         Load (S.B, Code.Code, Offset, Stat);
      end if;
      if Stat /= Ok then
         return;
      end if;
      Configure
        (S.B, S.M, Code.Code, Offset,
         (Clock          =>
            Divider_For (Clock_Hz, Bit_Rate * Code.Cycles_Per_Bit),
          Side_Base      => S.Pin,
          --  The first bit is the top one: put pixels in bits 31..8
          Out_Shift      => Shift_Left,
          Autopull       => True,
          Pull_Threshold => 24,
          FIFO           => Join_TX,
          others         => <>));
      --  An output, low: the idle level, and a reset to begin with
      Set_Pins (S.B, S.M, S.Pin, 1, 0);
      Set_Directions (S.B, S.M, S.Pin, 1, 1);
      Start (S.B, S.M);
      S.Open := True;
   end Open;

   procedure Put (S : in out Strip; GRB : Word; Stat : out Status) is
   begin
      Put (S.B, S.M, GRB * 2**8);
      Stat := Ok;
   end Put;

   procedure Latch
     (S          : in out Strip;
      Reset_Time : Keel.Time.Time_Span;
      Stat       : out Status) is
   begin
      Wait_Empty
        (S.B, S.M, Keel.Time.Bare.Clock + Keel.Time.Milliseconds (1),
         Stat);
      if Stat = Ok then
         Keel.Time.Bare.Wait_Until
           (Keel.Time.Bare.Clock + Pixel_Time + Reset_Time);
      end if;
   end Latch;
end Keel.PIO.RP2350.WS2812;
