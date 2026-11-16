--  SPDX-License-Identifier: Apache-2.0
--  Keel.Clock on the RP2350: the crystal oscillator, pll_sys, the
--  clk_sys multiplexer, a clock out on GP21 and the frequency
--  counter. Settings come from Keel.Clock.Solve, so a setting outside
--  the datasheet's limits cannot reach these procedures.
with Keel.Clock.Chip_Limits;

package Keel.Clock.RP2350
  with Preelaborate
is
   --  The Pico 2 W's crystal
   Crystal : constant Frequency := 12_000_000;
   PLL_SYS : PLL_Limits renames Chip_Limits.RP2350_PLL_SYS;

   --  What Keel last set clk_sys to; 0 until Start_Crystal
   function Sys_Frequency return Frequency;
   function Crystal_Running return Boolean;

   --  Start the crystal oscillator, run clk_ref from it and clk_sys
   --  from clk_ref. Timeout: the oscillator never reported STABLE,
   --  and the clocks are as they were.
   procedure Start_Crystal (Stat : out Status)
     with Post => (if Stat = Ok then Crystal_Running
                     and then Sys_Frequency = Crystal);

   --  clk_sys straight from the crystal, through clk_ref
   procedure Run_From_Crystal
     with Pre  => Crystal_Running,
          Post => Sys_Frequency = Crystal;

   --  clk_sys from pll_sys at Setting. clk_sys runs from the crystal
   --  while the PLL relocks. Timeout: no lock; clk_sys stays on the
   --  crystal.
   procedure Run_From_PLL (Setting : PLL_Config; Stat : out Status)
     with Pre  => Crystal_Running
                  and then Limits (Setting) = PLL_SYS
                  and then Reference (Setting) = Crystal,
          Post => Sys_Frequency =
                    (if Stat = Ok then Output (Setting) else Crystal);

   --  clk_adc at 48 MHz from pll_usb at Setting, which the ADC
   --  needs (datasheet 12.4.3). Timeout: no lock; clk_adc stays off.
   procedure Start_ADC_Clock (Setting : PLL_Config; Stat : out Status)
     with Pre  => Crystal_Running
                  and then Limits (Setting) = PLL_SYS
                  and then Reference (Setting) = Crystal
                  and then Output (Setting) = 48_000_000,
          Post => ADC_Clock_Running = (Stat = Ok);
   function ADC_Clock_Running return Boolean;

   --  Stop clk_adc and power pll_usb down: 48 MHz that only the
   --  ADC needs, between readings
   procedure Stop_ADC_Clock
     with Post => not ADC_Clock_Running;

   --  clk_peri, the UARTs' and SPI's clock (datasheet 8.1, Figure
   --  36): clk_sys, undivided, from now on. Set clk_sys first: a later
   --  change of clk_sys changes clk_peri, and every baud rate with it.
   procedure Start_Peri_Clock
     with Post => Peri_Frequency = Sys_Frequency;

   --  clk_peri in hertz; 0 while it's stopped
   function Peri_Frequency return Frequency;

   --  DORMANT (datasheet 6.5.3) the way the Pico SDK's
   --  pico_low_power enters it when the always-on timer is to wake
   --  the chip: clk_ref from LPOSC, so POWMAN keeps a clock; clk_sys
   --  and clk_peri from the ring oscillator, ROSC; clk_adc, clk_usb
   --  and clk_hstx stopped; both PLLs and the crystal off. Until
   --  Restart_After_Dormant, clk_sys runs at an unknown ROSC rate:
   --  Sys_Frequency is 0.
   procedure Prepare_Dormant
     with Pre  => Crystal_Running,
          Post => not Crystal_Running and then not ADC_Clock_Running
                  and then Sys_Frequency = 0;

   --  Write DORMANT to ROSC: every clock stops, and this returns once
   --  a wake event has restarted ROSC
   procedure Enter_Dormant
     with Pre => not Crystal_Running;

   --  Start the crystal again and run clk_ref and clk_sys from it.
   --  Timeout: as for Start_Crystal.
   procedure Restart_After_Dormant (Stat : out Status)
     with Post => (if Stat = Ok then Crystal_Running
                     and then Sys_Frequency = Crystal);

   --  clk_gpout0 on GP21: clk_sys / Divisor, from now on. In_Use:
   --  GP21 has another owner.
   procedure Start_Clock_Out (Divisor : Positive; Stat : out Status)
     with Pre => Divisor < 2**16;

   --  clk_sys measured by the frequency counter against clk_ref, in
   --  kHz. The count takes 1 ms and is good to 2 kHz.
   function Measure_Sys_kHz return Natural
     with Pre => Crystal_Running;
end Keel.Clock.RP2350;
