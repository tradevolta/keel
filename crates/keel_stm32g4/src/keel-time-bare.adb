--  SPDX-License-Identifier: Apache-2.0
with Interfaces;    use Interfaces;
with System;
with Keel.Cortex_M; use Keel.Cortex_M;

package body Keel.Time.Bare is

   --  SysTick (PM0214, 4.5): control, reload and current value
   type CSR_Register is record
      ENABLE    : Boolean := False;
      TICKINT   : Boolean := False;  --  interrupt at each wrap
      CLKSOURCE : Boolean := False;  --  True: the core clock
   end record
     with Volatile_Full_Access, Object_Size => 32;
   for CSR_Register use record
      ENABLE    at 0 range 0 .. 0;
      TICKINT   at 0 range 1 .. 1;
      CLKSOURCE at 0 range 2 .. 2;
   end record;

   SYST_CSR : CSR_Register
     with Import, Address => System'To_Address (16#E000_E010#);
   SYST_RVR : Unsigned_32
     with Import, Atomic, Address => System'To_Address (16#E000_E014#);
   SYST_CVR : Unsigned_32
     with Import, Atomic, Address => System'To_Address (16#E000_E018#);

   --  ICSR.PENDSTSET: SysTick has wrapped and its handler hasn't run
   ICSR : Unsigned_32
     with Import, Atomic, Address => System'To_Address (16#E000_ED04#);
   PENDSTSET : constant Unsigned_32 := 2**26;

   --  SHPR3's top byte is SysTick's priority; the G4 keeps its top
   --  four bits
   SHPR3 : Unsigned_32
     with Import, Atomic, Address => System'To_Address (16#E000_ED20#);

   Started : Boolean := False;
   Per_Us  : Unsigned_32 := 1;
   Reload  : Unsigned_32 := 0;

   --  Written by the handler only; read with interrupts masked
   Ticks : Unsigned_64 := 0 with Volatile;

   function Is_Started return Boolean is (Started);

   procedure Tick_Handler
     with Export, Convention => C, External_Name => "keel_systick";

   procedure Tick_Handler is
   begin
      Ticks := Ticks + 1;
   end Tick_Handler;

   procedure Start (Reference : Keel.Clock.Frequency) is
   begin
      SYST_CSR := (others => False);
      Per_Us := Unsigned_32 (Reference / 1_000_000);
      Reload := Unsigned_32 (Reference / 1_000) - 1;
      SYST_RVR := Reload;
      SYST_CVR := 0;
      SHPR3 := (SHPR3 and 16#00FF_FFFF#) or 16#F000_0000#;
      SYST_CSR := (ENABLE | TICKINT | CLKSOURCE => True);
      Started := True;
   end Start;

   --  With interrupts masked, a wrap's handler can't run: if the
   --  wrap is pending, count it here, and read the counter again
   --  in case it wrapped after the first read
   function Clock return Time is
      Masked : constant Boolean := Interrupts_Disabled;
      Ms     : Unsigned_64;
      Left   : Unsigned_32;
   begin
      Disable_Interrupts;
      Ms := Ticks;
      Left := SYST_CVR;
      if (ICSR and PENDSTSET) /= 0 then
         Left := SYST_CVR;
         Ms := Ms + 1;
      end if;
      if not Masked then
         Enable_Interrupts;
      end if;
      return Time (Unsigned_64'Min
                     (Ms * 1_000
                      + Unsigned_64 ((Reload - Left) / Per_Us),
                      Unsigned_64 (Max_Clock)));
   end Clock;

   procedure Wait_Until (Deadline : Time) is
   begin
      loop
         Disable_Interrupts;
         exit when Clock + Time_Span'(1_000) >= Deadline;
         WFI;
         Enable_Interrupts;
      end loop;
      Enable_Interrupts;
      loop
         exit when Clock >= Deadline;
      end loop;
   end Wait_Until;

   procedure Wake_At (Deadline : Time) is null;

   --  The bare backend fits the seam: this fails to compile if not
   package Fits is new Keel.Time.Clock_Signature (Clock, Wait_Until);
   pragma Unreferenced (Fits);
end Keel.Time.Bare;
