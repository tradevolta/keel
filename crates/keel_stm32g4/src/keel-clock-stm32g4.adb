--  SPDX-License-Identifier: Apache-2.0
with STM32G4_SVD;              use STM32G4_SVD;
with STM32G4_SVD.Clock_Fields; use STM32G4_SVD.Clock_Fields;
with STM32G4_SVD.Flash;        use STM32G4_SVD.Flash;
with STM32G4_SVD.PWR;          use STM32G4_SVD.PWR;
with STM32G4_SVD.RCC;          use STM32G4_SVD.RCC;
with Keel.Cortex_M;
with Keel.GPIO.STM32G4;

package body Keel.Clock.STM32G4 is

   --  HSI16 and PLL name this package's constants too: the register
   --  values are Fields.HSI16 and Fields.PLL
   package Fields renames STM32G4_SVD.Clock_Fields;

   Sys : Frequency := HSI16;

   function Sys_Frequency return Frequency is (Sys);

   Patience : constant := 1_000_000;

   --  RM0440, 3.3.3, Table 9: the fastest HCLK for each number of
   --  wait states, in range 1 normal mode and in boost mode
   type Wait_States is range 0 .. 4;
   Normal_Max : constant array (Wait_States) of Frequency :=
     [30_000_000, 60_000_000, 90_000_000, 120_000_000, 150_000_000];
   Boost_Max : constant array (Wait_States) of Frequency :=
     [34_000_000, 68_000_000, 102_000_000, 136_000_000, 170_000_000];

   --  Boost mode above 150 MHz (RM0440, 6.1.5)
   function Needs_Boost (F : Frequency) return Boolean is
     (F > Normal_Max (Wait_States'Last));

   function Wait_States_For (F : Frequency) return Wait_States is
   begin
      for W in Wait_States loop
         if F <= (if Needs_Boost (F) then Boost_Max (W)
                  else Normal_Max (W))
         then
            return W;
         end if;
      end loop;
      return Wait_States'Last;
   end Wait_States_For;

   procedure Set_Wait_States (W : Wait_States) is
   begin
      FLASH_Periph.FLASH_ACR.LATENCY :=
        FLASH_ACR_LATENCY_Field'Val (Wait_States'Pos (W));
      --  RM0440, 3.3.3: read it back before the clock goes up
      loop
         exit when FLASH_Periph.FLASH_ACR.LATENCY =
                   FLASH_ACR_LATENCY_Field'Val (Wait_States'Pos (W));
      end loop;
   end Set_Wait_States;

   procedure Switch_To (Source : Sys_Source) is
   begin
      RCC_CFGR := (RCC_CFGR with delta SW => Source);
      loop
         exit when RCC_CFGR.SWS = Source;
      end loop;
   end Switch_To;

   procedure Run_From_HSI16 is
   begin
      --  Down from above 80 MHz: through HCLK = SYSCLK / 2 for at
      --  least 1 us, as ST's HAL and AN5093 do
      if Sys > 80_000_000 then
         RCC_CFGR := (RCC_CFGR with delta HPRE => Div_2);
         for I in 1 .. 200 loop
            Keel.Cortex_M.NOP;
         end loop;
      end if;
      Switch_To (Fields.HSI16);
      RCC_CFGR := (RCC_CFGR with delta HPRE => Div_1);
      --  Slower now: fewer wait states, boost off
      Set_Wait_States (Wait_States_For (HSI16));
      RCC_Periph.RCC_APB1ENR1.PWREN := B_0x1;
      PWR_Periph.PWR_CR5.R1MODE := B_0x1;
      Sys := HSI16;
   end Run_From_HSI16;

   procedure Run_From_PLL (Setting : PLL_Config; Stat : out Status) is
      Target : constant Frequency := Output (Setting);
      Locked : Boolean := False;
   begin
      --  1. Off the PLL, then stop it
      Run_From_HSI16;
      RCC_Periph.RCC_CR.PLLON := B_0x0;
      loop
         exit when RCC_Periph.RCC_CR.PLLRDY = B_0x0;
      end loop;

      --  2. Up: wait states first (RM0440, 3.3.3)
      Set_Wait_States (Wait_States_For (Target));

      --  3. M, N and R; R counts in twos (Post_Scale = 2)
      RCC_PLLCFGR :=
        (PLLSRC => Fields.HSI16,
         PLLM   => M_Code (Ref_Div (Setting) - 1),
         PLLN   => N_Code (Feedback (Setting)),
         PLLREN => True,
         PLLR   => R_Code (Post_1 (Setting) - 1));
      RCC_Periph.RCC_CR.PLLON := B_0x1;
      for Try in 1 .. Patience loop
         Locked := RCC_Periph.RCC_CR.PLLRDY = B_0x1;
         exit when Locked;
      end loop;
      if not Locked then
         Stat := Timeout;
         return;
      end if;

      --  4. AN5093's sequence: HCLK = SYSCLK / 2, the voltage mode,
      --  the switch, at least 1 us, then HCLK = SYSCLK
      RCC_CFGR := (RCC_CFGR with delta HPRE => Div_2);
      PWR_Periph.PWR_CR5.R1MODE :=
        (if Needs_Boost (Target) then B_0x0 else B_0x1);
      Switch_To (Fields.PLL);
      --  200 cycles of HCLK, at most 85 MHz here: over 2 us
      for I in 1 .. 200 loop
         Keel.Cortex_M.NOP;
      end loop;
      RCC_CFGR := (RCC_CFGR with delta HPRE => Div_1);
      Sys := Target;
      Stat := Ok;
   end Run_From_PLL;

   procedure Start_Clock_Out (Stat : out Status) is
   begin
      Keel.GPIO.STM32G4.Reserve (Keel.GPIO.STM32G4.A, 8, 0, Stat);
      if Stat = Ok then
         RCC_CFGR :=
           (RCC_CFGR with delta MCOSEL => SYSCLK, MCOPRE => Div_16);
      end if;
   end Start_Clock_Out;
end Keel.Clock.STM32G4;
