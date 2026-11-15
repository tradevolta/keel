--  SPDX-License-Identifier: Apache-2.0
--  The Pico 2 W board. PIO block 0 runs both programs: state machine
--  0 the 1-Wire bus on GP22 (pin 29), state machine 1 the LEDs on
--  GP21 (pin 27). The probes' data wires join on GP22, with a 4.7
--  kohm pull-up to 3V3(OUT) (pin 36); their power wires go to 3V3,
--  their grounds to GND. The strip takes 5 V from VBUS (pin 40) and
--  its data from GP21 through a 74AHCT125 powered from VBUS, which
--  lifts 3.3 V logic to what a 5 V LED reads as high. The console is
--  RTT.
with Keel.Clock;          use type Keel.Clock.Frequency;
with Keel.Clock.RP2350;   use Keel.Clock.RP2350;
with Keel.GPIO.RP2350;
with Keel.OneWire.RP2350;
with Keel.PIO;
with Keel.PIO.RP2350;
with Keel.PIO.RP2350.WS2812;
with Keel.Time.Bare;
with Keel.Trace;
with RP2350_SVD;          use type RP2350_SVD.Byte;
with RP2350_SVD.QMI;      use RP2350_SVD.QMI;

package body Board is
   use type Keel.Status;

   Wire  : Keel.OneWire.RP2350.Bus (B => 0, M => 0, Pin => 22);
   Chain : Keel.PIO.RP2350.WS2812.Strip (B => 0, M => 1, Pin => 21);

   --  The flash's limit, as in Chapter 10
   Flash_Max : constant Keel.Clock.Frequency := 133_000_000;
   Target    : constant Keel.Clock.Frequency := 150_000_000;

   function Flash_Divisor return Keel.Clock.Frequency is
     (if QMI_Periph.M0_TIMING.CLKDIV = 0 then 256
      else Keel.Clock.Frequency (QMI_Periph.M0_TIMING.CLKDIV));

   procedure Check (Stat : Keel.Status; What : String) is
   begin
      if Stat /= Keel.Ok then
         Keel.Trace.Put_Line ("thermo: " & What & ": " & Stat'Image);
         loop
            null;
         end loop;
      end if;
   end Check;

   procedure Initialize is
      Stat  : Keel.Status;
      PLL   : Keel.Clock.PLL_Config;
      Found : Boolean;
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
      Keel.PIO.RP2350.Enable (0);

      Keel.OneWire.RP2350.Open (Wire, Positive (Sys_Frequency), Stat);
      Check (Stat, "1-Wire on GP22");
      Keel.PIO.RP2350.WS2812.Open
        (Chain, Positive (Sys_Frequency), Stat);
      Check (Stat, "WS2812 on GP21");
      Put_Line ("thermo: clk_sys" & Sys_Frequency'Image & " Hz");
   end Initialize;

   procedure Reset
     (B : in out Bus; Present : out Boolean; Stat : out Status)
   is
      pragma Unreferenced (B);
   begin
      Keel.OneWire.RP2350.Reset (Wire, Present, Stat);
   end Reset;

   procedure Touch
     (B : in out Bus; Bit : Boolean; Got : out Boolean;
      Stat : out Status)
   is
      pragma Unreferenced (B);
   begin
      Keel.OneWire.RP2350.Touch (Wire, Bit, Got, Stat);
   end Touch;

   procedure Put
     (S : in out Strip; Pixel : Pixel_Bits; Stat : out Keel.Status)
   is
      pragma Unreferenced (S);
   begin
      Keel.PIO.RP2350.WS2812.Put (Chain, Keel.PIO.Word (Pixel), Stat);
   end Put;

   procedure Latch (S : in out Strip; Stat : out Keel.Status) is
      pragma Unreferenced (S);
   begin
      Keel.PIO.RP2350.WS2812.Latch (Chain, Reset_Time, Stat);
   end Latch;

   function Now return Time is (Keel.Time.Bare.Clock);

   procedure Wait_Until (Deadline : Time) is
   begin
      Keel.Time.Bare.Wait_Until (Deadline);
   end Wait_Until;

   procedure Put_Line (Text : String) is
   begin
      Keel.Trace.Put_Line (Text);
   end Put_Line;
end Board;
