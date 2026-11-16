--  SPDX-License-Identifier: Apache-2.0
with RP2350_SVD;          use RP2350_SVD;
with RP2350_SVD.CLOCKS;   use RP2350_SVD.CLOCKS;
with RP2350_SVD.WATCHDOG; use RP2350_SVD.WATCHDOG;
with RP2350_SVD.POWMAN_Words;
with Ada.Unchecked_Conversion;
with Keel.Clock.RP2350;
with Keel.Cortex_M;       use Keel.Cortex_M;
with Keel.Interrupts;
with Keel.RTC.RP2350;
with Keel.Time.Bare;

package body Keel.Power.RP2350 is

   use type Keel.RTC.Epoch_Ms;
   package Words renames RP2350_SVD.POWMAN_Words;
   use type Words.Offset;
   subtype Reg is RP2350_SVD.UInt32;
   package AON renames Keel.RTC.RP2350;
   package Bare renames Keel.Time.Bare;

   ------------------------------------------------------------------
   --  Retained words
   ------------------------------------------------------------------

   function Scratch (I : Retained_Index) return Words.Offset is
     (Words.SCRATCH0 + Words.Offset (4 * Integer (I)));

   function Retained (I : Retained_Index) return Word is
     (Word (Words.Read (Scratch (I))));

   procedure Retain (I : Retained_Index; Value : Word) is
   begin
      Words.Write (Scratch (I), Reg (Value));
   end Retain;

   ------------------------------------------------------------------
   --  Registers and bits
   ------------------------------------------------------------------

   --  CHIP_RESET (Table 521) and the PWRUPx, STATE and TIMER bits
   --  (Tables 524, 544, 545)
   Had_Swcore_PD    : constant Reg := 2**25;
   Pwrup_Status     : constant Reg := 2**9;
   Pwrup_Edge       : constant Reg := 2**8;
   Pwrup_Enable     : constant Reg := 2**6;
   State_Waiting    : constant Reg := 2**12;
   State_Bad_Sw_Req : constant Reg := 2**10;
   State_Ignored    : constant Reg := 2**8;
   VREG_Unlock      : constant Reg := 2**13;
   --  SEQ_CFG: HW_PWRUP_SRAM0 and SRAM1 clear, so a power-up from
   --  P1.7 powers both SRAMs (Table 523)
   Pwrup_SRAM_Bits  : constant Reg := 2#11#;
   --  P1.7: switched core, XIP, SRAM0 and SRAM1 all off (Table 507)
   P1_7             : constant Reg := 2#1111#;

   --  SLEEP_EN0 bit 23, CLK_REF_POWMAN; SLEEP_EN1 bits 28, 19 and
   --  17: CLK_SYS_WATCHDOG, CLK_SYS_TIMER0, CLK_REF_TICKS
   Keep_POWMAN : constant Reg := 2**23;
   Keep_Timer  : constant Reg := 2**28 or 2**19 or 2**17;

   function To_EN0 is new Ada.Unchecked_Conversion
     (Reg, SLEEP_EN0_Register);
   function To_EN1 is new Ada.Unchecked_Conversion
     (Reg, SLEEP_EN1_Register);
   function From_EN0 is new Ada.Unchecked_Conversion
     (SLEEP_EN0_Register, Reg);
   function From_EN1 is new Ada.Unchecked_Conversion
     (SLEEP_EN1_Register, Reg);

   --  The masks as they were at Initialize, all ones from reset
   Awake_EN0 : Reg := 16#FFFF_FFFF#;
   Awake_EN1 : Reg := 16#FFFF_FFFF#;

   procedure Gate (EN0, EN1 : Reg) is
   begin
      CLOCKS_Periph.SLEEP_EN0 := To_EN0 (EN0);
      CLOCKS_Periph.SLEEP_EN1 := To_EN1 (EN1);
   end Gate;

   procedure Ungate is
   begin
      Gate (Awake_EN0, Awake_EN1);
   end Ungate;

   ------------------------------------------------------------------
   --  Start-up
   ------------------------------------------------------------------

   Woke     : Wake_Source := Not_Powered_Down;
   Pin_Set  : Boolean := False;

   procedure Initialize is
      Spare : constant Keel.Interrupts.IRQ := 46;  --  SPAREIRQ_IRQ_0
   begin
      Awake_EN0 := From_EN0 (CLOCKS_Periph.SLEEP_EN0);
      Awake_EN1 := From_EN1 (CLOCKS_Periph.SLEEP_EN1);

      if (Words.Read (Words.CHIP_RESET) and Had_Swcore_PD) /= 0 then
         if AON.Alarm_Fired then
            Woke := Alarm;
         elsif (Words.Read (Words.PWRUP0) and Pwrup_Status) /= 0 then
            Woke := Wake_Pin;
         else
            Woke := Other;
         end if;
      end if;
      --  Disarm both wake sources, so the next power down starts
      --  clean: the Pico SDK's powman_disable_all_wakeups
      AON.Clear_Alarm;
      Words.Write (Words.PWRUP0, 16#3F#);
      Words.Write (Words.PWRUP0, 16#3F# or Pwrup_Status);

      --  After a watchdog reset the Pico SDK sleeps once, woken at
      --  once by a spare interrupt (runtime_init_rp2350_sleep_fix),
      --  before any real sleep. Keel does the same.
      if WATCHDOG_Periph.REASON.TIMER
        or else WATCHDOG_Periph.REASON.FORCE
      then
         Disable_Interrupts;
         Keel.Interrupts.Clear_Pending (Spare);
         Keel.Interrupts.Enable (Spare);
         Keel.Interrupts.Set_Pending (Spare);
         WFI;
         Keel.Interrupts.Disable (Spare);
         Keel.Interrupts.Clear_Pending (Spare);
         Enable_Interrupts;
      end if;
   end Initialize;

   function Last_Wake return Wake_Source is (Woke);

   function Last_Power_Up_Source return Natural is
     (Natural (Words.Read (Words.LAST_SWCORE_PWRUP) and 16#7F#));

   Wake_Pin_Source : Reg := 16#3F#;

   procedure Set_Wake_Pin (Pin : Keel.GPIO.RP2350.Pin_Id) is
   begin
      Wake_Pin_Source := Reg (Pin);
      Pin_Set := True;
   end Set_Wake_Pin;

   procedure Ignore_Debugger (Ignore : Boolean := True) is
   begin
      Words.Write (Words.DBG_PWRCFG, (if Ignore then 1 else 0));
   end Ignore_Debugger;

   ------------------------------------------------------------------
   --  The modes
   ------------------------------------------------------------------

   --  The deadline as a count of always-on milliseconds from now,
   --  rounded up; 0 if it is under Least
   function Ms_Until (Deadline : Keel.Time.Time; Least : Natural)
     return Natural
   is
      Now  : constant Keel.Time.Time := Bare.Clock;
      Span : constant Long_Long_Integer :=
        (if Deadline > Now
         then Long_Long_Integer (Deadline) - Long_Long_Integer (Now)
         else 0);
      Ms   : constant Long_Long_Integer :=
        Long_Long_Integer'Min ((Span + 999) / 1_000, 86_400_000);
   begin
      return
        (if Ms < Long_Long_Integer (Least) then 0 else Natural (Ms));
   end Ms_Until;

   procedure Sleep_Until (Deadline : Keel.Time.Time) is
   begin
      Disable_Interrupts;
      if Bare.Clock < Deadline then
         Bare.Wake_At (Deadline);
         Gate (0, Keep_Timer);
         Set_Deep_Sleep (True);
         WFI;
         Set_Deep_Sleep (False);
         Ungate;
      end if;
      Enable_Interrupts;
   end Sleep_Until;

   procedure Dormant_Until (Deadline : Keel.Time.Time) is
      Ms : constant Natural := Ms_Until (Deadline, 2);
      Start_us : constant Keel.Time.Time := Bare.Clock;
      Start_ms : Keel.RTC.Epoch_Ms;
      Stat : Status;
   begin
      if Ms = 0 or else not AON.Running
        or else not Keel.Clock.RP2350.Crystal_Running
      then
         Sleep_Until (Deadline);
         return;
      end if;
      Disable_Interrupts;
      AON.Use_LPOSC;
      Start_ms := AON.Now;
      Keel.Clock.RP2350.Prepare_Dormant;
      AON.Set_Alarm (Start_ms + Keel.RTC.Epoch_Ms (Ms));
      Gate (Keep_POWMAN, 0);
      Set_Deep_Sleep (True);
      Keel.Clock.RP2350.Enter_Dormant;
      Set_Deep_Sleep (False);
      Ungate;
      AON.Clear_Alarm;
      Keel.Clock.RP2350.Restart_After_Dormant (Stat);
      if Stat = Ok then
         AON.Use_Crystal;
      end if;
      --  TIMER0 stood still: add what the always-on timer counted
      Bare.Catch_Up
        (Keel.Time."+" (Start_us,
           Keel.Time.Time_Span (AON.Now - Start_ms) * 1_000));
      Enable_Interrupts;
   end Dormant_Until;

   procedure Power_Down_Until (Deadline : Keel.Time.Time) is
      Ms : constant Natural := Ms_Until (Deadline, 2);
      State : Reg;
   begin
      if Ms = 0 or else not AON.Running then
         Sleep_Until (Deadline);
         return;
      end if;
      Disable_Interrupts;
      --  Nothing pending may end the WFI below
      Keel.Interrupts.Disable (3);
      Keel.Interrupts.Clear_Pending (3);

      AON.Use_LPOSC;
      Words.Set_Bits (Words.VREG_CTRL, VREG_Unlock);
      --  Boot to the program, not a POWMAN boot vector (5.2.3)
      for I in 0 .. 3 loop
         Words.Write (Words.BOOT0 + Words.Offset (4 * I), 0);
      end loop;
      Words.Clear_Bits (Words.SEQ_CFG, Pwrup_SRAM_Bits);

      AON.Set_Alarm
        (AON.Now + Keel.RTC.Epoch_Ms (Ms), Power_Up => True);
      if Pin_Set then
         Words.Write (Words.PWRUP0, Wake_Pin_Source or Pwrup_Edge);
         Words.Write (Words.PWRUP0,
                      Wake_Pin_Source or Pwrup_Edge or Pwrup_Status);
         Words.Write (Words.PWRUP0,
                      Wake_Pin_Source or Pwrup_Edge or Pwrup_Enable);
      end if;

      --  Ask for P1.7 (6.2.3.1); WAITING stays set until the
      --  processors sleep
      Words.Clear_Bits (Words.STATE, State_Ignored);
      Words.Write (Words.STATE, P1_7 * 2**4);
      State := Words.Read (Words.STATE);
      for Try in 1 .. 500 loop
         exit when (State and State_Waiting) /= 0
           or else (State and (State_Ignored or State_Bad_Sw_Req)) /= 0;
         State := Words.Read (Words.STATE);
      end loop;
      if (State and State_Waiting) = 0 then
         --  Refused: a pending power-up request or a debugger
         AON.Clear_Alarm;
         Keel.Interrupts.Enable (3);
         Enable_Interrupts;
         Sleep_Until (Deadline);
         return;
      end if;
      Set_Deep_Sleep (True);
      loop
         WFI;
      end loop;
   end Power_Down_Until;

   procedure Enter (M : Mode; Deadline : Keel.Time.Time) is
   begin
      case M is
         when Run        => null;
         when Sleep      => Sleep_Until (Deadline);
         when Dormant    => Dormant_Until (Deadline);
         when Power_Down => Power_Down_Until (Deadline);
      end case;
   end Enter;

   --  Policy has defaults that are not static, so a preelaborated
   --  unit keeps it in parts
   Set_Deepest : Mode := Sleep;
   Set_Costs   : Costs;
   Policy_Set  : Boolean := False;

   procedure Set_Policy (P : Policy) is
   begin
      Set_Deepest := P.Deepest;
      Set_Costs := P.Wake;
      Policy_Set := True;
   end Set_Policy;

   function Current return Policy is
     ((Deepest => Set_Deepest,
       Wake    => (if Policy_Set then Set_Costs else Default_Costs)));

   function Clock return Keel.Time.Time is (Bare.Clock);

   package Waits is new Idle (Clock, Enter, Current);

   procedure Wait_Until (Deadline : Keel.Time.Time) is
   begin
      Waits.Wait_Until (Deadline);
   end Wait_Until;

   --  The policy-driven wait fits the seam
   package Fits is new Keel.Time.Clock_Signature (Clock, Wait_Until);
   pragma Unreferenced (Fits);
end Keel.Power.RP2350;
