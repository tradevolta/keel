--  SPDX-License-Identifier: Apache-2.0
--  The NUCLEO-G474RE board. The encoder's contacts A and B go to
--  ground from PA0 (Arduino A0) and PA1 (A1), its push switch from
--  PA4 (A2), with pull-ups: EXTI lines 0, 1 and 4, each with its
--  own interrupt. The bar's eight LEDs are on Arduino D2 to D9:
--  PA10, PB3, PB5, PB4, PB10, PA8, PA9, PC7. The console is RTT.
with Keel;              use Keel;
with Keel.GPIO;         use Keel.GPIO;
with Keel.GPIO.STM32G4; use Keel.GPIO.STM32G4;
with Keel.Interrupts;   use Keel.Interrupts;
with Keel.Quadrature;   use Keel.Quadrature;
with Keel.Sync.Bare;    use Keel.Sync.Bare;
with Keel.Trace;

package body Board is

   Pin_A  : Input_Pin (Port => A, Pin => 0);
   Pin_B  : Input_Pin (Port => A, Pin => 1);
   Switch : Input_Pin (Port => A, Pin => 4);

   Lines : constant array (1 .. 3) of IRQ := [EXTI0, EXTI1, EXTI4];

   type Bar is limited record
      L1 : Output_Pin (Port => A, Pin => 10);
      L2 : Output_Pin (Port => B, Pin => 3);
      L3 : Output_Pin (Port => B, Pin => 5);
      L4 : Output_Pin (Port => B, Pin => 4);
      L5 : Output_Pin (Port => B, Pin => 10);
      L6 : Output_Pin (Port => A, Pin => 8);
      L7 : Output_Pin (Port => A, Pin => 9);
      L8 : Output_Pin (Port => C, Pin => 7);
   end record;
   LEDs : Bar;

   Both : constant Edges := (Falling => True, Rising => True);

   --  Shared with the handlers: touched by the program only between
   --  Enter_Critical and Leave_Critical
   Knob    : Decoder (Low => Volume'First, High => Volume'Last);
   Press   : Boolean := False;
   Changed : Event;

   function Contacts return Phase is
     (Phase_Of (A => Get (Pin_A) = High, B => Get (Pin_B) = High));

   --  EXTI0 and EXTI1: an edge on A or B. Both lines are read each
   --  time, so either handler does the whole job.
   procedure Encoder_Handler is
   begin
      Acknowledge (Pin_A);
      Acknowledge (Pin_B);
      Update (Knob, Contacts);
      Signal (Changed);
   end Encoder_Handler;

   procedure EXTI0_Handler
     with Export, Convention => C, External_Name => "keel_isr_6";
   procedure EXTI0_Handler renames Encoder_Handler;

   procedure EXTI1_Handler
     with Export, Convention => C, External_Name => "keel_isr_7";
   procedure EXTI1_Handler renames Encoder_Handler;

   --  EXTI4: the push switch
   procedure EXTI4_Handler
     with Export, Convention => C, External_Name => "keel_isr_10";

   procedure EXTI4_Handler is
   begin
      Acknowledge (Switch);
      Press := True;
      Signal (Changed);
   end EXTI4_Handler;

   procedure Check (Stat : Status; What : String) is
   begin
      if Stat /= Ok then
         Keel.Trace.Put_Line ("volume_knob: " & What & ": "
                              & Stat'Image);
         loop
            null;
         end loop;
      end if;
   end Check;

   procedure Initialize is
      Stat : Status;
      Off  : constant Output_Config := (Initial => Low, others => <>);
      Up   : constant Input_Config := (Bias => Pull_Up);

      procedure LED (P : in out Output_Pin; Name : String) is
      begin
         Claim (P, Off, Stat);
         Check (Stat, "LED on " & Name);
      end LED;
   begin
      Keel.Trace.Initialize;
      Claim (Pin_A, Up, Stat);
      Check (Stat, "PA0");
      Claim (Pin_B, Up, Stat);
      Check (Stat, "PA1");
      Claim (Switch, Up, Stat);
      Check (Stat, "PA4");
      LED (LEDs.L1, "PA10");
      LED (LEDs.L2, "PB3");
      LED (LEDs.L3, "PB5");
      LED (LEDs.L4, "PB4");
      LED (LEDs.L5, "PB10");
      LED (LEDs.L6, "PA8");
      LED (LEDs.L7, "PA9");
      LED (LEDs.L8, "PC7");
      Knob.Last := Contacts;
      Watch (Pin_A, Both);
      Watch (Pin_B, Both);
      Watch (Switch, (Falling => True, others => <>));
      for N of Lines loop
         Set_Priority (N, 8);
         Clear_Pending (N);
         Enable (N);
      end loop;
   end Initialize;

   procedure Wait_For_Change is
   begin
      Wait (Changed);
   end Wait_For_Change;

   procedure Read (Position : out Volume; Misses : out Natural) is
   begin
      Enter_Critical;
      Position := Knob.Position;
      Misses := Knob.Misses;
      Leave_Critical;
   end Read;

   function Pressed return Boolean is
      Was : Boolean;
   begin
      Enter_Critical;
      Was := Press;
      Press := False;
      Leave_Critical;
      return Was;
   end Pressed;

   procedure Show (Lit : Lit_Count) is
      function On (N : Lit_Count) return Level is
        (if Lit >= N then High else Low);
   begin
      Set (LEDs.L1, On (1));
      Set (LEDs.L2, On (2));
      Set (LEDs.L3, On (3));
      Set (LEDs.L4, On (4));
      Set (LEDs.L5, On (5));
      Set (LEDs.L6, On (6));
      Set (LEDs.L7, On (7));
      Set (LEDs.L8, On (8));
   end Show;

   procedure Put_Line (Text : String) is
   begin
      Keel.Trace.Put_Line (Text);
   end Put_Line;
end Board;
