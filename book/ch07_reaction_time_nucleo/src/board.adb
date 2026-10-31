--  SPDX-License-Identifier: Apache-2.0
--  The NUCLEO-G474RE board. Lamps: Go on PA0 (Arduino A0), winner A
--  on PA1 (A1), winner B on PA4 (A2). Buttons to ground: A on PB0
--  (A3), B on PC1 (A4), with pull-ups. TIM2 counts microseconds;
--  the console is RTT.
with Keel;                      use Keel;
with Keel.GPIO;                 use Keel.GPIO;
with Keel.GPIO.Input_Signature;
with Keel.GPIO.Output_Signature;
with Keel.GPIO.STM32G4;         use Keel.GPIO.STM32G4;
with Keel.Trace;
with Keel.Units;                use Keel.Units;
with Panel;
with STM32G4_SVD;               use STM32G4_SVD;
with STM32G4_SVD.RCC;           use STM32G4_SVD.RCC;
with STM32G4_SVD.TIM;           use STM32G4_SVD.TIM;

package body Board is

   Go_Lamp  : Output_Pin (Port => A, Pin => 0);
   Lamp_A   : Output_Pin (Port => A, Pin => 1);
   Lamp_B   : Output_Pin (Port => A, Pin => 4);
   Button_A : Input_Pin (Port => B, Pin => 0);
   Button_B : Input_Pin (Port => C, Pin => 1);

   --  The same three lines as on the Pico 2 W
   package Lamp_Pins is new Keel.GPIO.Output_Signature (Output_Pin);
   package Button_Pins is new Keel.GPIO.Input_Signature (Input_Pin);
   package The_Panel is new Panel
     (Lamp_Pins, Button_Pins,
      Go_Lamp, Lamp_A, Lamp_B, Button_A, Button_B);

   --  TIM2 runs from PCLK1, 170 MHz, as in Chapter 6
   Timer_Clock : constant Hertz := "170 MHz";
   Tick_Rate   : constant Hertz := "1 MHz";

   --  CNT holds the low 31 bits of the counter (Chapter 6)
   type Count is mod 2**31;
   function Now return Count is (Count (TIM2_Periph.TIM2_CNT.CNT));
   Last_Tick : Count := 0;

   procedure Start_Timer is
   begin
      RCC_Periph.RCC_APB1ENR1.TIM2EN := B_0x1;
      TIM2_Periph.TIM2_PSC := UInt16 (Timer_Clock / Tick_Rate) - 1;
      TIM2_Periph.TIM2_EGR := (UG => B_0x1, others => <>);
      TIM2_Periph.TIM2_CR1.CEN := B_0x1;
   end Start_Timer;

   procedure Check (Stat : Status; What : String) is
   begin
      if Stat /= Ok then
         Keel.Trace.Put_Line
           ("reaction_time: " & What & ": " & Stat'Image);
         loop
            null;
         end loop;
      end if;
   end Check;

   procedure Initialize is
      Stat : Status;
   begin
      Keel.Trace.Initialize;
      Start_Timer;
      Claim (Go_Lamp, (Initial => Low, Slew => Slow), Stat);
      Check (Stat, "PA0");
      Claim (Lamp_A, (Initial => Low, Slew => Slow), Stat);
      Check (Stat, "PA1");
      Claim (Lamp_B, (Initial => Low, Slew => Slow), Stat);
      Check (Stat, "PA4");
      Claim (Button_A, (Bias => Pull_Up), Stat);
      Check (Stat, "PB0");
      Claim (Button_B, (Bias => Pull_Up), Stat);
      Check (Stat, "PC1");
      Last_Tick := Now;
   end Initialize;

   procedure Next_Tick is
   begin
      while Now - Last_Tick < 1_000 loop
         null;
      end loop;
      Last_Tick := Last_Tick + 1_000;
   end Next_Tick;

   function Clock return Natural is (Natural (Now));

   function Presses return Players renames The_Panel.Presses;
   procedure Show (L : Lamps) renames The_Panel.Show;

   procedure Put_Line (Text : String) is
   begin
      Keel.Trace.Put_Line (Text);
   end Put_Line;
end Board;
