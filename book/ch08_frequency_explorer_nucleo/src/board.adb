--  SPDX-License-Identifier: Apache-2.0
--  The NUCLEO-G474RE board. The button goes to ground from PB0
--  (Arduino A3), with a pull-up. PA8 (Arduino D7) carries SYSCLK /
--  16 (MCO). TIM2 counts microseconds; the console is RTT.
with Keel.Clock.STM32G4;     use Keel.Clock.STM32G4;
with Keel.GPIO;              use Keel.GPIO;
with Keel.GPIO.Debounce;     use Keel.GPIO.Debounce;
with Keel.GPIO.STM32G4;      use Keel.GPIO.STM32G4;
with Keel.Trace;
with STM32G4_SVD;            use STM32G4_SVD;
with STM32G4_SVD.RCC;        use STM32G4_SVD.RCC;
with STM32G4_SVD.TIM;        use STM32G4_SVD.TIM;

package body Board is

   Button  : Input_Pin (Port => B, Pin => 0);
   Contact : Debouncer (5);

   --  16 MHz is HSI16 itself; 170 MHz is the chip's rated maximum
   Steps : constant array (Step) of Frequency :=
     [16_000_000, 48_000_000, 150_000_000, 170_000_000];

   function Limits return PLL_Limits is (PLL);
   function Reference return Frequency is (HSI16);
   function Target (S : Step) return Frequency is (Steps (S));

   --  TIM2 runs from PCLK1, which is SYSCLK here: its prescaler
   --  must follow every switch to keep a 1 MHz count
   type Count is mod 2**31;
   function Now return Count is (Count (TIM2_Periph.TIM2_CNT.CNT));
   Last_Tick : Count := 0;

   procedure Retune_Timer is
   begin
      TIM2_Periph.TIM2_PSC :=
        UInt16 (Sys_Frequency / 1_000_000) - 1;
      --  An update event loads the prescaler now, and zeroes CNT
      TIM2_Periph.TIM2_EGR := (UG => B_0x1, others => <>);
      Last_Tick := Now;
   end Retune_Timer;

   procedure Check (Stat : Status; What : String) is
   begin
      if Stat /= Ok then
         Keel.Trace.Put_Line
           ("frequency_explorer: " & What & ": " & Stat'Image);
         loop
            null;
         end loop;
      end if;
   end Check;

   procedure Initialize is
      Stat : Status;
   begin
      Keel.Trace.Initialize;
      RCC_Periph.RCC_APB1ENR1.TIM2EN := B_0x1;
      Retune_Timer;
      TIM2_Periph.TIM2_CR1.CEN := B_0x1;
      Claim (Button, (Bias => Pull_Up), Stat);
      Check (Stat, "PB0");
      Reset (Contact, High);
      Start_Clock_Out (Stat);
      Check (Stat, "PA8");
   end Initialize;

   procedure Next_Tick is
   begin
      while Now - Last_Tick < 1_000 loop
         null;
      end loop;
      Last_Tick := Last_Tick + 1_000;
   end Next_Tick;

   function Pressed return Boolean is
      Changed : Boolean;
   begin
      Sample (Contact, Get (Button), Changed);
      return Changed and then Stable (Contact) = Low;
   end Pressed;

   procedure Switch (P : Plan; Stat : out Status) is
   begin
      case P.Kind is
         when From_Reference =>
            Run_From_HSI16;
            Stat := Ok;
         when From_PLL =>
            Run_From_PLL (P.Setting, Stat);
         when Refused =>
            Run_From_HSI16;
            Stat := Not_Supported;
      end case;
      Retune_Timer;
   end Switch;

   --  The G474 has no frequency counter to ask
   function Measured_Image return String is
     ("no counter on this chip: see PA8 (SYSCLK / 16)");

   function Supply_Image return String is
     ("no monitor on this board");

   procedure Put_Line (Text : String) is
   begin
      Keel.Trace.Put_Line (Text);
   end Put_Line;
end Board;
