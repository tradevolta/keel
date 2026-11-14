--  SPDX-License-Identifier: Apache-2.0
--  The Pico 2 W board. The encoder's contacts A and B go to ground
--  from GP16 and GP17, its push switch from GP18, all with the
--  pads' pull-ups. The bar's eight LEDs are on GP8 to GP15, each
--  through its resistor to ground. The console is RTT.
with Keel;              use Keel;
with Keel.GPIO;         use Keel.GPIO;
with Keel.GPIO.RP2350;  use Keel.GPIO.RP2350;
with Keel.Interrupts;   use Keel.Interrupts;
with Keel.Quadrature;   use Keel.Quadrature;
with Keel.Sync.Bare;    use Keel.Sync.Bare;
with Keel.Trace;

package body Board is

   A      : Input_Pin (16);
   B      : Input_Pin (17);
   Switch : Input_Pin (18);

   type Bar is limited record
      L1 : Output_Pin (8);
      L2 : Output_Pin (9);
      L3 : Output_Pin (10);
      L4 : Output_Pin (11);
      L5 : Output_Pin (12);
      L6 : Output_Pin (13);
      L7 : Output_Pin (14);
      L8 : Output_Pin (15);
   end record;
   LEDs : Bar;

   Both : constant Edges := (Falling => True, Rising => True);

   --  Shared with the handler: touched by the program only between
   --  Enter_Critical and Leave_Critical
   Knob    : Decoder (Low => Volume'First, High => Volume'Last);
   Press   : Boolean := False;
   Changed : Event;

   function Contacts return Phase is
     (Phase_Of (A => Get (A) = High, B => Get (B) = High));

   --  IO_IRQ_BANK0 (21): an edge on A, B or the switch
   procedure IO_Bank0_Handler
     with Export, Convention => C, External_Name => "keel_isr_21";

   procedure IO_Bank0_Handler is
   begin
      --  Clear first: an edge during the read latches again
      Acknowledge (A, Both);
      Acknowledge (B, Both);
      Update (Knob, Contacts);
      if Seen (Switch).Falling then
         Acknowledge (Switch, Both);
         Press := True;
      end if;
      Signal (Changed);
   end IO_Bank0_Handler;

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

      procedure LED (P : in out Output_Pin) is
      begin
         Claim (P, Off, Stat);
         Check (Stat, "LED on GP" & P.Id'Image);
      end LED;
   begin
      Keel.Trace.Initialize;
      Enable;
      Claim (A, Up, Stat);
      Check (Stat, "GP16");
      Claim (B, Up, Stat);
      Check (Stat, "GP17");
      Claim (Switch, Up, Stat);
      Check (Stat, "GP18");
      LED (LEDs.L1);
      LED (LEDs.L2);
      LED (LEDs.L3);
      LED (LEDs.L4);
      LED (LEDs.L5);
      LED (LEDs.L6);
      LED (LEDs.L7);
      LED (LEDs.L8);
      Knob.Last := Contacts;
      Watch (A, Both);
      Watch (B, Both);
      Watch (Switch, (Falling => True, others => <>));
      Set_Priority (IO_IRQ_BANK0, 8);
      Clear_Pending (IO_IRQ_BANK0);
      Enable (IO_IRQ_BANK0);
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
