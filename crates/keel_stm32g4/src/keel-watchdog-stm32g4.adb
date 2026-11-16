--  SPDX-License-Identifier: Apache-2.0
with Interfaces;         use Interfaces;
with Ada.Unchecked_Conversion;
with STM32G4_SVD;        use STM32G4_SVD;
with STM32G4_SVD.DBGMCU; use STM32G4_SVD.DBGMCU;
with STM32G4_SVD.IWDG;   use STM32G4_SVD.IWDG;
with STM32G4_SVD.RCC;    use STM32G4_SVD.RCC;

package body Keel.Watchdog.STM32G4 is

   --  The keys written to IWDG_KR (stm32g4xx_ll_iwdg.h)
   Key_Reload : constant := 16#AAAA#;
   Key_Enable : constant := 16#CCCC#;
   Key_Access : constant := 16#5555#;

   --  The flags, in RCC_CSR's bits 25 to 31
   OBL  : constant Unsigned_32 := 2**25;
   PIN  : constant Unsigned_32 := 2**26;
   BOR  : constant Unsigned_32 := 2**27;
   SFT  : constant Unsigned_32 := 2**28;
   IWDG : constant Unsigned_32 := 2**29;
   WWDG : constant Unsigned_32 := 2**30;
   LPWR : constant Unsigned_32 := 2**31;

   function To_Word is new Ada.Unchecked_Conversion
     (RCC_CSR_Register, Unsigned_32);

   Captured : Boolean := False;
   Flags    : Unsigned_32 := 0;

   procedure Start
     (T : Timeout_Ms; Stat : out Status;
      Pause_On_Debug : Boolean := True)
   is
      S     : Setting;
      Found : Boolean;
   begin
      Solve (Limits, T, S, Found);
      if not Found then
         Stat := Not_Supported;
         return;
      end if;
      DBGMCU_Periph.APB1L_FZ.DBG_IWDG_STOP := Pause_On_Debug;

      --  Start it (which starts the LSI), open the configuration
      --  registers, then the prescaler, 2**(PR + 2), and the reload
      IWDG_Periph.KR := (KEY => Key_Enable, others => <>);
      IWDG_Periph.KR := (KEY => Key_Access, others => <>);
      IWDG_Periph.PR := (PR => PR_PR_Field (S.Shift - 2), others => <>);
      IWDG_Periph.RLR := (RL => RLR_RL_Field (S.Reload), others => <>);

      --  PVU and RVU clear once the LSI domain has the values: up to
      --  5 LSI periods times the prescaler, 40 ms at /256. The poll
      --  gives up after many times that at any clock Keel uses.
      Stat := Timeout;
      for Try in 1 .. 20_000_000 loop
         if not IWDG_Periph.SR.PVU and then not IWDG_Periph.SR.RVU then
            Stat := Ok;
            exit;
         end if;
      end loop;
      Feed;
   end Start;

   procedure Start_Default (T : Timeout_Ms; Stat : out Status) is
   begin
      Start (T, Stat);
   end Start_Default;

   procedure Feed is
   begin
      IWDG_Periph.KR := (KEY => Key_Reload, others => <>);
   end Feed;

   procedure Capture is
   begin
      if not Captured then
         Flags := To_Word (RCC_Periph.RCC_CSR);
         RCC_Periph.RCC_CSR.RMVF := B_0x1;
         Captured := True;
      end if;
   end Capture;

   --  A reset from inside drives NRST low too, so PINRSTF comes with
   --  most of the others: it means the pin only when alone. A power-on
   --  sets BORRSTF with it.
   function Last_Cause return Reset_Cause is
   begin
      Capture;
      if (Flags and (IWDG or WWDG)) /= 0 then
         return Watchdog_Timeout;
      elsif (Flags and SFT) /= 0 then
         return Software;
      elsif (Flags and BOR) /= 0 then
         return Power_On;
      elsif (Flags and (LPWR or OBL)) /= 0 then
         return Unknown;
      elsif (Flags and PIN) /= 0 then
         return Reset_Pin;
      else
         return Unknown;
      end if;
   end Last_Cause;

   function Reset_Flags return Natural is
   begin
      Capture;
      return Natural (Shift_Right (Flags, 25));
   end Reset_Flags;
end Keel.Watchdog.STM32G4;
