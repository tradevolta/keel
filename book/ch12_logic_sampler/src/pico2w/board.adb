--  SPDX-License-Identifier: Apache-2.0
--  The Pico 2 W board. ADC input 0, GP26, is the probe. The test
--  signal is GP16: a 500 Hz square wave through 10 kohm into 100 nF
--  to AGND, whose joint goes to GP26, so the probe sees the
--  capacitor charge and discharge. Any other signal from 0 to 3.3 V
--  can go to GP26 instead, with the grounds joined. The console is
--  RTT.
with Keel;              use type Keel.Status;
with Keel.Clock;        use type Keel.Clock.Frequency;
with Keel.Clock.RP2350; use Keel.Clock.RP2350;
with Keel.Cortex_M;
with Keel.GPIO.RP2350;
with Keel.PWM;          use Keel.PWM;
with Keel.PWM.RP2350;   use Keel.PWM.RP2350;
with Keel.Time.Bare;
with Keel.Trace;
with Keel.Units;
with RP2350_SVD;        use type RP2350_SVD.Byte;
with RP2350_SVD.QMI;    use RP2350_SVD.QMI;

package body Board is

   Signal_Pin : Keel.PWM.RP2350.Output (16);

   --  The flash's limit, as in Chapter 10
   Flash_Max : constant Keel.Clock.Frequency := 133_000_000;
   Target    : constant Keel.Clock.Frequency := 150_000_000;

   function Flash_Divisor return Keel.Clock.Frequency is
     (if QMI_Periph.M0_TIMING.CLKDIV = 0 then 256
      else Keel.Clock.Frequency (QMI_Periph.M0_TIMING.CLKDIV));

   procedure Check (Stat : Keel.Status; What : String) is
   begin
      if Stat /= Keel.Ok then
         Keel.Trace.Put_Line ("sampler: " & What & ": " & Stat'Image);
         loop
            null;
         end loop;
      end if;
   end Check;

   procedure Initialize is
      Stat   : Keel.Status;
      PLL    : Keel.Clock.PLL_Config;
      Found  : Boolean;
      Square : Setting;
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

      --  The DWT cycle counter
      Keel.Cortex_M.DEMCR := (TRCENA => True);
      Keel.Cortex_M.DWT_Ctrl := (CYCCNTENA => True);

      --  clk_adc: 48 MHz from pll_usb, as in Chapter 11
      Keel.Clock.Solve (PLL_SYS, Crystal, 48_000_000, False, PLL,
                        Found);
      Check ((if Found then Keel.Ok else Keel.Not_Supported),
             "pll_usb setting");
      Start_ADC_Clock (PLL, Stat);
      Check (Stat, "clk_adc");
      Keel.ADC.RP2350.Enable (Stat);
      Check (Stat, "ADC");
      Keel.ADC.RP2350.Claim (0, Stat);
      Check (Stat, "ADC input 0");

      --  The test signal: 500 Hz, half the time high
      Solve (Slice_Limits, Keel.Units.Hertz (Sys_Frequency), "500 Hz",
             Trailing_Edge, Square, Stat);
      Check (Stat, "test signal setting");
      Claim (Signal_Pin, Square, Stat);
      Check (Stat, "GP16");
      Set_Level (Signal_Pin, Level_For (Square, 0.5));

      Keel.DMA.RP2350.Enable;
      for Ch in Keel.DMA.RP2350.Channel range Sampler .. Bench_B loop
         Keel.DMA.RP2350.Claim (Ch, Stat);
         Check (Stat, "DMA channel" & Ch'Image);
      end loop;
      Put_Line ("sampler: clk_sys" & Sys_Frequency'Image
                & " Hz, test signal" & Keel.PWM.Output (Square)'Image
                & " Hz");
   end Initialize;

   function Now return Time is (Keel.Time.Bare.Clock);

   procedure Wait_Until (Deadline : Time) is
   begin
      Keel.Time.Bare.Wait_Until (Deadline);
   end Wait_Until;

   function Cycles return Interfaces.Unsigned_32 is
     (Keel.Cortex_M.DWT_CYCCNT);

   procedure Put_Line (Text : String) is
   begin
      Keel.Trace.Put_Line (Text);
   end Put_Line;

   --  The probe reads the console every few milliseconds; a capture
   --  is 13 KB and the console's buffer 1 KB, so wait for room
   procedure Put_Line_Waiting (Text : String) is
      Give_Up : constant Time := Now + Milliseconds (1_000);
   begin
      loop
         exit when Keel.Trace.Space > Text'Length
           or else Now >= Give_Up;
      end loop;
      Keel.Trace.Put_Line (Text);
   end Put_Line_Waiting;
end Board;
