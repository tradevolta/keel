--  SPDX-License-Identifier: Apache-2.0
with RP2350_SVD;          use RP2350_SVD;
with RP2350_SVD.Atomic;
with RP2350_SVD.CLOCKS;   use RP2350_SVD.CLOCKS;
with RP2350_SVD.IO_BANK0; use RP2350_SVD.IO_BANK0;
with RP2350_SVD.PLL_SYS;  use RP2350_SVD.PLL_SYS;
with RP2350_SVD.RESETS;   use RP2350_SVD.RESETS;
with RP2350_SVD.XOSC;     use RP2350_SVD.XOSC;
with Keel.GPIO.RP2350;

package body Keel.Clock.RP2350 is

   Sys : Frequency := 0;
   Running : Boolean := False;

   function Sys_Frequency return Frequency is (Sys);
   function Crystal_Running return Boolean is (Running);

   --  How many times a wait polls before it reports Timeout: far
   --  longer than any of them takes, at any clk_sys
   Patience : constant := 1_000_000;

   --  One bit per source in each SELECTED register (one-hot)
   Ref_Is_XOSC : constant := 2#0100#;
   Sys_Is_Ref : constant := 2#01#;
   Sys_Is_Aux : constant := 2#10#;

   package Reset_Bits is new RP2350_SVD.Atomic (RESET_Register);

   procedure Start_Crystal (Stat : out Status) is
   begin
      --  1 ms of crystal cycles, in units of 256 (datasheet 8.2.4)
      XOSC_Periph.STARTUP :=
        (DELAY_k => STARTUP_DELAY_Field ((Crystal / 1_000 + 255) / 256),
         others => <>);
      XOSC_Periph.CTRL :=
        (FREQ_RANGE => Val_1_15MHZ, ENABLE => ENABLE, others => <>);
      Stat := Timeout;
      for Try in 1 .. Patience loop
         if XOSC_Periph.STATUS.STABLE then
            Stat := Ok;
            exit;
         end if;
      end loop;
      if Stat /= Ok then
         return;
      end if;

      CLOCKS_Periph.CLK_REF_DIV := (INT => 1, others => <>);
      CLOCKS_Periph.CLK_REF_CTRL := (SRC => xosc_clksrc, others => <>);
      loop
         exit when CLOCKS_Periph.CLK_REF_SELECTED.CLK_REF_SELECTED
                     = Ref_Is_XOSC;
      end loop;
      Running := True;
      Run_From_Crystal;
   end Start_Crystal;

   procedure Run_From_Crystal is
   begin
      CLOCKS_Periph.CLK_SYS_CTRL.SRC := clk_ref;
      loop
         exit when CLOCKS_Periph.CLK_SYS_SELECTED.CLK_SYS_SELECTED
                     = Sys_Is_Ref;
      end loop;
      Sys := Crystal;
   end Run_From_Crystal;

   procedure Run_From_PLL (Setting : PLL_Config; Stat : out Status) is
      Locked : Boolean := False;
   begin
      --  1. Off the PLL before touching it
      Run_From_Crystal;

      --  2. Reset pll_sys, as the SDK's pll_init does
      Reset_Bits.Set
        (RESETS_Periph.RESET,
         (Reset_Bits.No_Bits with delta PLL_SYS => True));
      Reset_Bits.Clear
        (RESETS_Periph.RESET,
         (Reset_Bits.No_Bits with delta PLL_SYS => True));
      loop
         exit when RESETS_Periph.RESET_DONE.PLL_SYS;
      end loop;

      --  3. Dividers, then power and VCO on, then wait for LOCK
      PLL_SYS_Periph.CS :=
        (REFDIV => CS_REFDIV_Field (Ref_Div (Setting)), others => <>);
      PLL_SYS_Periph.FBDIV_INT :=
        (FBDIV_INT => FBDIV_INT_FBDIV_INT_Field (Feedback (Setting)),
         others => <>);
      PLL_SYS_Periph.PWR :=
        (PD => False, VCOPD => False, others => <>);
      for Try in 1 .. Patience loop
         Locked := PLL_SYS_Periph.CS.LOCK;
         exit when Locked;
      end loop;
      if not Locked then
         Stat := Timeout;
         return;
      end if;

      --  4. Post dividers, then their power: no dirty clock comes out
      PLL_SYS_Periph.PRIM :=
        (POSTDIV1 => PRIM_POSTDIV1_Field (Post_1 (Setting)),
         POSTDIV2 => PRIM_POSTDIV2_Field (Post_2 (Setting)),
         others => <>);
      PLL_SYS_Periph.PWR :=
        (PD => False, VCOPD => False, POSTDIVPD => False,
         others => <>);

      --  5. The auxiliary mux is not glitchless: change it only while
      --  the glitchless mux selects clk_ref, then switch
      CLOCKS_Periph.CLK_SYS_CTRL.AUXSRC := clksrc_pll_sys;
      CLOCKS_Periph.CLK_SYS_DIV := (INT => 1, FRAC => 0);
      CLOCKS_Periph.CLK_SYS_CTRL.SRC := clksrc_clk_sys_aux;
      loop
         exit when CLOCKS_Periph.CLK_SYS_SELECTED.CLK_SYS_SELECTED
                     = Sys_Is_Aux;
      end loop;
      Sys := Output (Setting);
      Stat := Ok;
   end Run_From_PLL;

   procedure Start_Clock_Out (Divisor : Positive; Stat : out Status)
   is
   begin
      Keel.GPIO.RP2350.Reserve (21, Stat);
      if Stat /= Ok then
         return;
      end if;
      --  clk_gpout0 counts clk_sys; a whole divisor, no fraction
      CLOCKS_Periph.CLK_GPOUT0_CTRL :=
        (AUXSRC => clk_sys, others => <>);
      CLOCKS_Periph.CLK_GPOUT0_DIV :=
        (INT => CLK_GPOUT0_DIV_INT_Field (Divisor), FRAC => 0);
      CLOCKS_Periph.CLK_GPOUT0_CTRL :=
        (AUXSRC => clk_sys, ENABLE => True, others => <>);
      --  Only GPIO13's and GPIO21's function lists have it
      IO_BANK0_Periph.GPIO21_CTRL :=
        (FUNCSEL => clocks_gpout_0, others => <>);
   end Start_Clock_Out;

   function Measure_Sys_kHz return Natural is
   begin
      --  Datasheet 8.1.6.2: the reference, the interval (10: 1 ms,
      --  Table 574), no limits, then writing the source starts it
      loop
         exit when not CLOCKS_Periph.FC0_STATUS.RUNNING;
      end loop;
      CLOCKS_Periph.FC0_REF_KHZ :=
        (FC0_REF_KHZ => FC0_REF_KHZ_FC0_REF_KHZ_Field (Crystal / 1_000),
         others => <>);
      CLOCKS_Periph.FC0_INTERVAL := (FC0_INTERVAL => 10, others => <>);
      CLOCKS_Periph.FC0_MIN_KHZ := (FC0_MIN_KHZ => 0, others => <>);
      CLOCKS_Periph.FC0_MAX_KHZ :=
        (FC0_MAX_KHZ => FC0_MAX_KHZ_FC0_MAX_KHZ_Field'Last,
         others      => <>);
      CLOCKS_Periph.FC0_SRC := (FC0_SRC => clk_sys, others => <>);
      loop
         exit when CLOCKS_Periph.FC0_STATUS.DONE;
      end loop;
      return Natural (CLOCKS_Periph.FC0_RESULT.KHZ);
   end Measure_Sys_kHz;
end Keel.Clock.RP2350;
