--  SPDX-License-Identifier: Apache-2.0
--  Keel.PWM on the STM32G474: the general-purpose timers TIM3 and
--  TIM4, four channels each, as outputs, and TIM2 as a counter of
--  rising edges. A timer's four channels share its setting. The
--  timers run on the APB1 timer clock, which is SYSCLK while Keel
--  leaves APB1's prescaler at 1.
with Keel.GPIO.STM32G4; use Keel.GPIO.STM32G4;
with Keel.PWM.Chip_Limits;

package Keel.PWM.STM32G4
  with Preelaborate
is
   --  A whole-number divider from 1 to 65_536 and a 16-bit
   --  counter; no phase-correct mode
   Timer_Limits : Counter_Limits renames Chip_Limits.STM32G474_Timer;

   type Timer_Id is (TIM3, TIM4);
   type Channel_Id is range 1 .. 4;

   type Output
     (Timer : Timer_Id; Channel : Channel_Id;
      Port : Port_Id; Pin : Pin_Number) is limited private;

   function Is_Claimed (O : Output) return Boolean;
   function Setting_Of (O : Output) return Setting
     with Pre => Is_Claimed (O);

   --  Drive the pin from its channel at S, from level 0 (low). AF
   --  is the pin's alternate function for this timer (DS12288,
   --  Table 13). Inverted swaps high and low (CCxP). In_Use: the
   --  pin has an owner, or the timer already runs another setting.
   procedure Claim
     (O : in out Output; S : Setting; AF : Alternate_Function;
      Stat : out Status; Inverted : Boolean := False)
     with Pre  => not Is_Claimed (O)
                  and then Limits (S) = Timer_Limits,
          Post => Is_Claimed (O) = (Stat = Ok)
                  and then (if Stat = Ok then Setting_Of (O) = S);

   --  The output is high for Level counts of each period. Takes
   --  effect at the next update.
   procedure Set_Level (O : in out Output; Level : Count)
     with Pre => Is_Claimed (O)
                 and then Level <= Top (Setting_Of (O)) + 1;

   --  TIM2's channel 1 pin counts: PA0 (AF1) on the NUCLEO's A0
   type Counter is limited private;

   function Is_Claimed (C : Counter) return Boolean;

   --  Count rising edges on PA0. In_Use: PA0 has an owner, or TIM2
   --  is in use. The input's high and low times must each be longer
   --  than about two timer clock cycles (RM0440 29.3.4).
   procedure Claim (C : in out Counter; Stat : out Status)
     with Pre  => not Is_Claimed (C),
          Post => Is_Claimed (C) = (Stat = Ok);

   procedure Start (C : in out Counter)
     with Pre => Is_Claimed (C);
   procedure Stop (C : in out Counter)
     with Pre => Is_Claimed (C);
   --  TIM2 is 32 bits wide: up to 2**31 - 1 edges
   function Value (C : Counter) return Natural
     with Pre => Is_Claimed (C);
   function Wrapped (C : Counter) return Boolean
     with Pre => Is_Claimed (C);
private
   type Output
     (Timer : Timer_Id; Channel : Channel_Id;
      Port : Port_Id; Pin : Pin_Number)
   is limited record
      Claimed : Boolean := False;
      S : Setting;
   end record;

   type Counter is limited record
      Claimed : Boolean := False;
   end record;

   function Is_Claimed (O : Output) return Boolean is (O.Claimed);
   function Setting_Of (O : Output) return Setting is (O.S);
   function Is_Claimed (C : Counter) return Boolean is (C.Claimed);
end Keel.PWM.STM32G4;
