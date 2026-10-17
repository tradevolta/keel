--  SPDX-License-Identifier: Apache-2.0
with RP2350.IO_Bank0; use RP2350.IO_Bank0;
with RP2350.Pads_Bank0; use RP2350.Pads_Bank0;
with RP2350.Resets; use RP2350.Resets;
with Cartographer_Regs; use Cartographer_Regs;

package body Hot_Loops is

   procedure Setup_LED is
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
   end Setup_LED;

   procedure Burst_In_Flash (Count : Natural) is
   begin
      for I in 1 .. Count loop
         SIO_Regs.GPIO_Out_XOR := LED;
      end loop;
   end Burst_In_Flash;

   procedure Burst_In_SRAM (Count : Natural) is
   begin
      for I in 1 .. Count loop
         SIO_Regs.GPIO_Out_XOR := LED;
      end loop;
   end Burst_In_SRAM;
end Hot_Loops;
