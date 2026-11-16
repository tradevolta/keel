--  SPDX-License-Identifier: Apache-2.0
--  Keel.Watchdog on the STM32G4: the independent watchdog, IWDG,
--  counting down a 12-bit reload from the LSI oscillator, about
--  32 kHz, through a prescaler of 4 to 256; and the reset reason,
--  from the flags in RCC_CSR. The register names are the SVD's and
--  STM32CubeG4's (stm32g4xx_hal_iwdg.c, stm32g4xx_ll_iwdg.h). Once
--  started, the IWDG cannot be stopped short of a reset.
with Keel.Watchdog.Chip_Limits;

package Keel.Watchdog.STM32G4
  with Preelaborate
is
   Limits : Counter_Limits renames Chip_Limits.STM32G4_IWDG;

   --  Count down from T. Pause_On_Debug: freeze the counter while
   --  the debugger halts the core (DBGMCU APB1L_FZ.DBG_IWDG_STOP).
   --  Not_Supported: T is over 32.7 s at the nominal 32 kHz.
   --  Timeout: the IWDG never took the new prescaler and reload.
   procedure Start
     (T : Timeout_Ms; Stat : out Status;
      Pause_On_Debug : Boolean := True);

   --  Load the counter again: the key 16#AAAA#
   procedure Feed;

   --  Why the chip last started. The first call reads RCC_CSR's
   --  flags, keeps them, and clears them (RMVF), so the next reset
   --  starts with a clean slate.
   function Last_Cause return Reset_Cause;

   --  RCC_CSR's flags as the first Last_Cause found them, bits 25
   --  to 31 shifted down to 0 to 6: OBL, PIN, BOR, SFT, IWDG, WWDG,
   --  LPWR
   function Reset_Flags return Natural;

   procedure Start_Default (T : Timeout_Ms; Stat : out Status);
   package Fits is new Signature (Start_Default, Feed, Last_Cause);
end Keel.Watchdog.STM32G4;
