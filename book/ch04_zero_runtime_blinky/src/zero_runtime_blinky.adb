--  SPDX-License-Identifier: Apache-2.0
--  GP15 blinks with no runtime startup code: Keel.Startup brings the
--  core from reset to here. Nothing sets up the clocks, so the delay
--  is a counted loop and its length depends on the boot clock.
with Keel.Cortex_M;
with RP2350.IO_Bank0; use RP2350.IO_Bank0;
with RP2350.Pads_Bank0; use RP2350.Pads_Bank0;
with RP2350.Resets; use RP2350.Resets;
with RP2350.SIO; use RP2350.SIO;
with Blinky_Regs; use Blinky_Regs;

procedure Zero_Runtime_Blinky is
   LED : constant Pin_Mask := [15 => True, others => False];

   Half_Period : constant := 2_000_000;

   procedure Spin (Count : Natural) is
   begin
      for I in 1 .. Count loop
         Keel.Cortex_M.NOP;
      end loop;
   end Spin;
begin
   Resets_Clear.Reset :=
     [IO_Bank0 | Pads_Bank0 => True, others => False];
   while not (Resets_Regs.Reset_Done (IO_Bank0)
              and then Resets_Regs.Reset_Done (Pads_Bank0))
   loop
      null;
   end loop;

   IO_Regs.GPIO (15).Ctrl := (Funcsel => SIO, others => <>);
   Pads_Set.GPIO (15) := (No_Bits with delta Input_Enable => True);
   Pads_Clear.GPIO (15) := (No_Bits with delta Isolate => True);
   SIO_Regs.GPIO_OE_Set := LED;

   loop
      SIO_Regs.GPIO_Out_XOR := LED;
      Spin (Half_Period);
   end loop;
end Zero_Runtime_Blinky;
