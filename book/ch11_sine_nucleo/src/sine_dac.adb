--  SPDX-License-Identifier: Apache-2.0
--  The NUCLEO-G474RE's half of Chapter 11. DAC1 channel 1 puts a
--  50 Hz sine on PA4 (Arduino A2): 40 steps a period, 500 us each,
--  from 0.65 V to 2.65 V around 1.65 V. Join A2 to the Pico 2 W's
--  GP28, and the grounds. COMP1 compares the potentiometer's wiper
--  on PA1 (A1) with the same DAC channel, inside the chip, and
--  drives PA6 (D12) high while the wiper is above the sine. Once a
--  second the console (RTT) reports how much of the time it was.
with Keel;               use type Keel.Status;
with Keel.Clock;
with Keel.Clock.STM32G4; use Keel.Clock.STM32G4;
with Keel.DAC.STM32G4;   use Keel.DAC.STM32G4;
with Keel.GPIO.STM32G4;  use Keel.GPIO.STM32G4;
with Keel.Time;          use Keel.Time;
with Keel.Time.Bare;
with Keel.Trace;
with STM32G4_SVD.COMP;   use STM32G4_SVD.COMP;
with STM32G4_SVD.RCC;    use STM32G4_SVD.RCC;

procedure Sine_DAC is
   --  round (4096 / 3.25 * (1.65 + 1.0 * sin (2 pi N / 40))), worked
   --  out once on a computer; 3.25 V is the NUCLEO's VREF+
   Sine : constant array (0 .. 39) of DAC_Code :=
     [2_080, 2_277, 2_469, 2_652, 2_820, 2_971, 3_099, 3_202,
      3_278, 3_324, 3_340, 3_324, 3_278, 3_202, 3_099, 2_971,
      2_820, 2_652, 2_469, 2_277, 2_080, 1_882, 1_690, 1_507,
      1_339, 1_188, 1_060, 957, 881, 835, 819, 835,
      881, 957, 1_060, 1_188, 1_339, 1_507, 1_690, 1_882];

   Step_Time : constant Time_Span := Microseconds (500);

   --  COMP1's minus input from DAC1 channel 1 (INMSEL 2#101#), its
   --  plus input from PA1 (INPSEL 0): ST's HAL, stm32g4xx_hal_comp.h
   DAC1_Channel_1 : constant COMP_C1CSR_INMSEL_Field := 2#101#;
   --  COMP1_OUT on PA6 is AF8
   Comp_AF : constant Alternate_Function := 8;

   Target : constant Keel.Clock.Frequency := 150_000_000;

   Out_1  : Output;
   Stat   : Keel.Status;
   PLL_Setting : Keel.Clock.PLL_Config;
   Found  : Boolean;
   Next   : Time;
   Step   : Natural := 0;
   High   : Natural := 0;

   procedure Check (What : String) is
   begin
      if Stat /= Keel.Ok then
         Keel.Trace.Put_Line ("sine_dac: " & What & ": "
                              & Stat'Image);
         loop
            null;
         end loop;
      end if;
   end Check;
begin
   Keel.Trace.Initialize;
   Keel.Clock.Solve (PLL, HSI16, Target, False, PLL_Setting, Found);
   if Found then
      Run_From_PLL (PLL_Setting, Stat);
      Check ("PLL");
   end if;
   Keel.Time.Bare.Start (Sys_Frequency);

   Claim (Out_1, Stat);
   Check ("PA4");

   --  The comparators are clocked with SYSCFG
   RCC_Periph.RCC_APB2ENR.SYSCFGEN := B_0x1;
   Reserve_Analog (A, 1, Stat);
   Check ("PA1");
   Reserve (A, 6, Comp_AF, Stat);
   Check ("PA6");
   COMP_Periph.COMP_C1CSR :=
     (EN => True, INMSEL => DAC1_Channel_1, INPSEL => False,
      others => <>);

   Keel.Trace.Put_Line ("sine_dac: 50 Hz on A2, 40 steps of 500 us");
   Next := Keel.Time.Bare.Clock;
   loop
      Next := Next + Step_Time;
      Keel.Time.Bare.Wait_Until (Next);
      Set_Code (Out_1, Sine (Step mod 40));
      if COMP_Periph.COMP_C1CSR.VALUE then
         High := High + 1;
      end if;
      Step := Step + 1;
      if Step = 2_000 then
         Keel.Trace.Put_Line
           ("sine_dac: comparator high" & Natural'Image (High / 20)
            & " % of the time");
         Step := 0;
         High := 0;
      end if;
   end loop;
end Sine_DAC;
