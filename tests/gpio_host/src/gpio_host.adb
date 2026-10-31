--  SPDX-License-Identifier: Apache-2.0
--  Keel.GPIO on the host: ownership and Status from Claim, pulls,
--  the debouncer against a bouncing contact, and the same pin used
--  through the signature generic and through the interface.
with Ada.Text_IO;      use Ada.Text_IO;
with Ada.Command_Line;
with Ada.Assertions;
with Keel;             use Keel;
with Keel.GPIO;        use Keel.GPIO;
with Keel.GPIO.Debounce;
with Keel.GPIO.Fake;   use Keel.GPIO.Fake;
with Keel.GPIO.Lines;
with Keel.GPIO.Output_Adapter;
with Keel.GPIO.Output_Signature;
with Pulse;

procedure GPIO_Host is
   Failures : Natural := 0;

   procedure Check (Name : String; OK : Boolean) is
   begin
      Put_Line ((if OK then "ok:   " else "FAIL: ") & Name);
      if not OK then
         Failures := Failures + 1;
      end if;
   end Check;

   Stat : Status;

   package Fake_Pins is new Keel.GPIO.Output_Signature (Output_Pin);
   procedure Fake_Pulse is new Pulse (Fake_Pins);
   package Fake_Lines is new Keel.GPIO.Output_Adapter (Fake_Pins);
begin
   --  Ownership
   declare
      Led   : Output_Pin (15);
      Again : Output_Pin (15);
   begin
      Claim (Led, (Initial => High, others => <>), Stat);
      Check ("claim GP15 -> Ok", Stat = Ok);
      Check ("GP15 starts High", Lamp (15) = High);
      Claim (Again, (others => <>), Stat);
      Check ("claim GP15 again -> In_Use", Stat = In_Use);
      Check ("second object not claimed", not Is_Claimed (Again));
      Release (Led);
      Claim (Again, (others => <>), Stat);
      Check ("claim after Release -> Ok", Stat = Ok);
      Set (Again, High);
      Check ("Set High drives High", Lamp (15) = High);
      Release (Again);
   end;

   --  The precondition stops a Set on a pin nobody claimed
   declare
      Stray : Output_Pin (3);
   begin
      Set (Stray, High);
      Check ("Set unclaimed pin is refused", False);
   exception
      when Ada.Assertions.Assertion_Error =>
         Check ("Set unclaimed pin is refused", True);
   end;

   --  Inputs and pulls
   declare
      Button : Input_Pin (16);
      Other  : Input_Pin (17);
   begin
      Claim (Button, (Bias => Pull_Up), Stat);
      Check ("claim GP16 Pull_Up -> Ok", Stat = Ok);
      Check ("released button reads High", Get (Button) = High);
      Press (16, Low);
      Check ("pressed button reads Low", Get (Button) = Low);
      Let_Go (16);
      Check ("let go: High again", Get (Button) = High);

      Refuse_Pull_Down (True);
      Claim (Other, (Bias => Pull_Down), Stat);
      Check ("Pull_Down on an A2 -> Not_Supported",
             Stat = Not_Supported);
      Refuse_Pull_Down (False);
      Release (Button);
   end;

   --  A contact that bounces for four samples, then settles Low
   declare
      use Keel.GPIO.Debounce;
      D       : Debouncer (Samples => 5);
      Raw     : constant array (1 .. 10) of Level :=
        [Low, High, Low, High, Low, Low, Low, Low, Low, Low];
      Changed : Boolean;
      Flips   : Natural := 0;
      At_Flip : Natural := 0;
   begin
      Reset (D, High);
      for I in Raw'Range loop
         Sample (D, Raw (I), Changed);
         if Changed then
            Flips := Flips + 1;
            At_Flip := I;
         end if;
      end loop;
      Check ("bouncing contact: one change", Flips = 1);
      Check ("change on sample 9, the 5th Low in a row", At_Flip = 9);
      Check ("stable level is Low", Stable (D) = Low);
   end;

   --  The same pin through the signature and through the interface
   declare
      Led : aliased Output_Pin (13);
      Line : Fake_Lines.Line (Led'Access);

      procedure Light (L : in out Lines.Output_Line'Class) is
      begin
         L.Set (High);
      end Light;
   begin
      Claim (Led, (others => <>), Stat);
      Fake_Pulse (Led);
      Check ("generic Pulse: two edges", Edges (13) = 2);
      Light (Line);
      Check ("Output_Line'Class Set: High", Lamp (13) = High);
   end;

   if Failures = 0 then
      Put_Line ("gpio_host: all passed");
   else
      Put_Line ("gpio_host:" & Failures'Image & " failed");
      Ada.Command_Line.Set_Exit_Status (Ada.Command_Line.Failure);
   end if;
end GPIO_Host;
