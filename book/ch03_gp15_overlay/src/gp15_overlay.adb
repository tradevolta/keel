--  SPDX-License-Identifier: Apache-2.0
--  Hello, Photon again, written with the Chapter 3 overlays instead
--  of masks: GP15 blinks at 2 Hz.
with Ada.Real_Time;     use Ada.Real_Time;
with RP2350.IO_Bank0;   use RP2350.IO_Bank0;
with RP2350.Pads_Bank0; use RP2350.Pads_Bank0;
with RP2350.Resets;     use RP2350.Resets;
with RP2350.SIO;        use RP2350.SIO;
with Pico_Regs;         use Pico_Regs;

procedure GP15_Overlay is
   LED  : constant Pin_Mask := [15 => True, others => False];
   Next : Time := Clock;
begin
   --  Release IO_BANK0 and PADS_BANK0: one write to the CLR alias.
   Resets_Clear.Reset :=
     [IO_Bank0 | Pads_Bank0 => True, others => False];
   while not (Resets_Regs.Reset_Done (IO_Bank0)
              and then Resets_Regs.Reset_Done (Pads_Bank0))
   loop
      null;
   end loop;

   --  Full-register writes: every field named or defaulted.
   IO_Regs.GPIO (15).Ctrl := (Funcsel => SIO, others => <>);
   Pads_Clear.GPIO (15) := (No_Bits with delta Isolate => True);
   SIO_Regs.GPIO_OE_Set := LED;

   loop
      SIO_Regs.GPIO_Out_XOR := LED;
      Next := Next + Milliseconds (250);
      delay until Next;
   end loop;
end GP15_Overlay;
