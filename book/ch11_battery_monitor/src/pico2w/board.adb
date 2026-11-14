--  SPDX-License-Identifier: Apache-2.0
--  The Pico 2 W board. ADC input 0, GP26, is the light: an LDR from
--  3V3(OUT) to GP26 and 10 kohm from GP26 to AGND. Input 1, GP27,
--  reads the PWM DAC back: GP16 drives 10 kohm into 100 nF to AGND,
--  and GP27 joins them. Input 2, GP28, takes the NUCLEO's sine, with
--  the grounds joined. Input 3, GPIO29, is VSYS / 3 on the board,
--  readable while GPIO25 is high (Pico 2 W datasheet). Input 4 is
--  the chip's temperature sensor. The LED bar is GP8 to GP15
--  through 220 ohm, as in Chapter 9. The console is RTT.
with Keel;              use type Keel.Status;
with Keel.Clock;        use type Keel.Clock.Frequency;
with Keel.Clock.RP2350; use Keel.Clock.RP2350;
with Keel.DAC.PWM_Adapter;
with Keel.GPIO;         use Keel.GPIO;
with Keel.GPIO.RP2350;  use Keel.GPIO.RP2350;
with Keel.PWM;          use Keel.PWM;
with Keel.PWM.RP2350;   use Keel.PWM.RP2350;
with Keel.Time.Bare;
with Keel.Trace;
with RP2350_SVD;        use type RP2350_SVD.Byte;
with RP2350_SVD.QMI;    use RP2350_SVD.QMI;

package body Board is

   type Bar is limited record
      L1 : Output_Pin (8);
      L2 : Output_Pin (9);
      L3 : Output_Pin (10);
      L4 : Output_Pin (11);
      L5 : Output_Pin (12);
      L6 : Output_Pin (13);
      L7 : Output_Pin (14);
      L8 : Output_Pin (15);
   end record;

   LEDs : Bar;

   --  GPIO25 high connects VSYS / 3 to GPIO29
   VSYS_Enable : Output_Pin (25);

   --  The PWM DAC: 150 kHz, 1000 levels, through 10 kohm and 100 nF
   DAC_Pin : Keel.PWM.RP2350.Output (16);

   package PWM_DAC is new Keel.DAC.PWM_Adapter
     (PWM_Output => Keel.PWM.RP2350.Output, Supply => 3.3);

   --  The flash's limit, as in Chapter 10
   Flash_Max : constant Keel.Clock.Frequency := 133_000_000;
   Target    : constant Keel.Clock.Frequency := 150_000_000;

   function Flash_Divisor return Keel.Clock.Frequency is
     (if QMI_Periph.M0_TIMING.CLKDIV = 0 then 256
      else Keel.Clock.Frequency (QMI_Periph.M0_TIMING.CLKDIV));

   procedure Check (Stat : Keel.Status; What : String) is
   begin
      if Stat /= Keel.Ok then
         Keel.Trace.Put_Line ("monitor: " & What & ": " & Stat'Image);
         loop
            null;
         end loop;
      end if;
   end Check;

   procedure Initialize is
      Stat  : Keel.Status;
      PLL   : Keel.Clock.PLL_Config;
      Found : Boolean;
      DAC_Setting : Setting;
      Off : constant Output_Config := (Initial => Low, others => <>);
      On  : constant Output_Config := (Initial => High, others => <>);

      procedure LED (P : in out Output_Pin) is
      begin
         Claim (P, Off, Stat);
         Check (Stat, "LED on GP" & P.Id'Image);
      end LED;
   begin
      Keel.Trace.Initialize;
      Start_Crystal (Stat);
      Check (Stat, "crystal");
      Keel.Clock.Solve (PLL_SYS, Crystal, Target, False, PLL, Found);
      if Found and then Target / Flash_Divisor <= Flash_Max then
         Run_From_PLL (PLL, Stat);
         Check (Stat, "pll_sys");
      end if;
      Keel.Time.Bare.Start (Crystal);
      Keel.GPIO.RP2350.Enable;
      Keel.PWM.RP2350.Enable;

      --  clk_adc: 48 MHz from pll_usb, solved like pll_sys
      Keel.Clock.Solve (PLL_SYS, Crystal, 48_000_000, False, PLL,
                        Found);
      Check ((if Found then Keel.Ok else Keel.Not_Supported),
             "pll_usb setting");
      Start_ADC_Clock (PLL, Stat);
      Check (Stat, "clk_adc");
      Enable (Stat);
      Check (Stat, "ADC");
      Claim (VSYS_Enable, On, Stat);
      Check (Stat, "GPIO25");
      for Ch in Channel loop
         Claim (Ch, Stat);
         Check (Stat, "ADC input" & Ch'Image);
      end loop;

      Solve (Slice_Limits, Hertz (Sys_Frequency), "150 kHz",
             Trailing_Edge, DAC_Setting, Stat);
      Check (Stat, "DAC setting");
      Claim (DAC_Pin, DAC_Setting, Stat);
      Check (Stat, "GP16");

      LED (LEDs.L1);
      LED (LEDs.L2);
      LED (LEDs.L3);
      LED (LEDs.L4);
      LED (LEDs.L5);
      LED (LEDs.L6);
      LED (LEDs.L7);
      LED (LEDs.L8);
      Put_Line ("monitor: clk_sys" & Sys_Frequency'Image
                & " Hz, DAC top" & Top (DAC_Setting)'Image);
   end Initialize;

   function Now return Time is (Keel.Time.Bare.Clock);

   procedure Wait_Until (Deadline : Time) is
   begin
      Keel.Time.Bare.Wait_Until (Deadline);
   end Wait_Until;

   procedure Set_DAC (V : Volts) is
   begin
      PWM_DAC.Set (DAC_Pin, V);
   end Set_DAC;

   procedure Show (Lit : Lit_Count) is
      function On (N : Lit_Count) return Level is
        (if Lit >= N then High else Low);
   begin
      Set (LEDs.L1, On (1));
      Set (LEDs.L2, On (2));
      Set (LEDs.L3, On (3));
      Set (LEDs.L4, On (4));
      Set (LEDs.L5, On (5));
      Set (LEDs.L6, On (6));
      Set (LEDs.L7, On (7));
      Set (LEDs.L8, On (8));
   end Show;

   procedure Put_Line (Text : String) is
   begin
      Keel.Trace.Put_Line (Text);
   end Put_Line;
end Board;
