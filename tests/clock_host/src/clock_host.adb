--  SPDX-License-Identifier: Apache-2.0
--  Keel.Clock.Solve on the host: a table of settings for both
--  chips, checked against the settings the datasheets print.
with Ada.Text_IO;            use Ada.Text_IO;
with Ada.Command_Line;
with Keel.Clock;             use Keel.Clock;
with Keel.Clock.Chip_Limits; use Keel.Clock.Chip_Limits;

procedure Clock_Host is
   Failures : Natural := 0;

   procedure Check (Name : String; OK : Boolean) is
   begin
      Put_Line ((if OK then "ok:   " else "FAIL: ") & Name);
      if not OK then
         Failures := Failures + 1;
      end if;
   end Check;

   function MHz (F : Frequency) return String is
     (Frequency'Image (F / 1_000_000));

   --  One row: target, then R F P1 P2 and the VCO, or "none"
   procedure Row
     (L : PLL_Limits; Ref, Target : Frequency; Over : Boolean)
   is
      C     : PLL_Config;
      Found : Boolean;
   begin
      Solve (L, Ref, Target, Over, C, Found);
      Put (MHz (Target) & " MHz:");
      if Found then
         Put_Line
           (Divider'Image (Ref_Div (C)) & Divider'Image (Feedback (C))
            & Post_Divider'Image (Post_1 (C))
            & Post_Divider'Image (Post_2 (C))
            & "  VCO" & MHz (VCO (C)) & " MHz");
      else
         Put_Line (" none");
      end if;
   end Row;

   --  Does Solve find exactly R F P1 P2?
   function Gives
     (L : PLL_Limits; Ref, Target : Frequency; Over : Boolean;
      R, F : Divider; P1, P2 : Post_Divider) return Boolean
   is
      C     : PLL_Config;
      Found : Boolean;
   begin
      Solve (L, Ref, Target, Over, C, Found);
      return Found and then Ref_Div (C) = R and then Feedback (C) = F
        and then Post_1 (C) = P1 and then Post_2 (C) = P2;
   end Gives;

   function Has_None
     (L : PLL_Limits; Ref, Target : Frequency; Over : Boolean)
      return Boolean
   is
      C     : PLL_Config;
      Found : Boolean;
   begin
      Solve (L, Ref, Target, Over, C, Found);
      return not Found;
   end Has_None;

   type Targets is array (Positive range <>) of Frequency;
   RP2350_Targets : constant Targets := [12, 48, 125, 133, 150, 200];
   STM32_Targets  : constant Targets := [16, 48, 150, 170];

   XOSC  : constant Frequency := 12_000_000;
   HSI16 : constant Frequency := 16_000_000;
begin
   Put_Line ("RP2350 pll_sys from 12 MHz:  REFDIV FBDIV PD1 PD2");
   for T of RP2350_Targets loop
      Row (RP2350_PLL_SYS, XOSC, T * 1_000_000, True);
   end loop;
   Put_Line ("STM32G474 PLL from 16 MHz:   PLLM PLLN R/2 (1)");
   for T of STM32_Targets loop
      Row (STM32G474_PLL, HSI16, T * 1_000_000, False);
   end loop;

   --  RP2350 datasheet 8.6.3: vcocalc.py 48 gives 1, 120, 6, 5
   Check ("48 MHz is 12 / 1 * 120 / 6 / 5",
          Gives (RP2350_PLL_SYS, XOSC, 48_000_000, False,
                 1, 120, 6, 5));
   --  Datasheet 8.6.4: the SDK's default pll_sys is 1, 125, 5, 2
   Check ("150 MHz is 12 / 1 * 125 / 5 / 2",
          Gives (RP2350_PLL_SYS, XOSC, 150_000_000, False,
                 1, 125, 5, 2));
   Check ("12 MHz has no setting (VCO >= 750 MHz)",
          Has_None (RP2350_PLL_SYS, XOSC, 12_000_000, True));
   Check ("200 MHz is refused without Overclock",
          Has_None (RP2350_PLL_SYS, XOSC, 200_000_000, False));
   Check ("200 MHz with Overclock is 12 / 1 * 100 / 6 / 1",
          Gives (RP2350_PLL_SYS, XOSC, 200_000_000, True,
                 1, 100, 6, 1));
   --  ST's HAL examples: 170 MHz from HSI16 is M 4, N 85, R 2
   Check ("170 MHz is 16 / 4 * 85 / 2",
          Gives (STM32G474_PLL, HSI16, 170_000_000, False,
                 4, 85, 1, 1));

   if Failures > 0 then
      Put_Line (Natural'Image (Failures) & " failed");
      Ada.Command_Line.Set_Exit_Status (Ada.Command_Line.Failure);
   end if;
end Clock_Host;
