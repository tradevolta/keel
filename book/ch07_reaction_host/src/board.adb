--  SPDX-License-Identifier: Apache-2.0
--  The host board: the same pins as the Pico 2 W, on Keel.GPIO.Fake,
--  and a bench that plays two scripted players. Time is simulated:
--  each Next_Tick is one millisecond, so a run is instant and gives
--  the same transcript every time.
with Ada.Text_IO;
with GNAT.OS_Lib;
with Keel;                      use Keel;
with Keel.GPIO;                 use Keel.GPIO;
with Keel.GPIO.Fake;            use Keel.GPIO.Fake;
with Keel.GPIO.Input_Signature;
with Keel.GPIO.Output_Signature;
with Panel;

package body Board is

   Go_Lamp  : Output_Pin (15);
   Lamp_A   : Output_Pin (14);
   Lamp_B   : Output_Pin (13);
   Button_A : Input_Pin (16);
   Button_B : Input_Pin (17);

   package Lamp_Pins is new Keel.GPIO.Output_Signature (Output_Pin);
   package Button_Pins is new Keel.GPIO.Input_Signature (Input_Pin);
   package The_Panel is new Panel
     (Lamp_Pins, Button_Pins,
      Go_Lamp, Lamp_A, Lamp_B, Button_A, Button_B);

   Button_Of : constant array (Player) of Pin_Id := [A => 16, B => 17];

   --  The script: when each player presses, in ms after the start
   --  press (Early, before Go) or after the bench sees Go (Late)
   Never : constant := -1;
   type Offset is range Never .. 5_000;
   type Times is array (Player) of Offset;
   type Round is record
      Early, Late : Times := [others => Never];
   end record;

   Script : constant array (1 .. 4) of Round :=
     [(Late => [A => 213, B => 260], others => <>),
      (Early => [A => Never, B => 400], others => <>),
      (Late => [A => 150, B => 150], others => <>),
      (others => <>)];

   --  A press: down, three bounces, held 120 ms, one bounce up
   Contact : constant array (0 .. 122) of Level :=
     [1 | 3 | 120 | 122 => High, others => Low];

   type Stage is (Resting, Waiting_Go, After_Go);

   Now_Ms  : Natural := 0;
   At_Rest : Natural := 0;     --  ms with every lamp dark
   Current : Positive := 1;    --  round of the script
   Bench   : Stage := Resting;
   Due     : array (Player) of Integer := [others => Never];
   Held    : array (Player) of Integer := [others => Never];

   function Stamp return String is
      Ms : constant String := Natural'Image (1_000 + Now_Ms mod 1_000);
   begin
      return Natural'Image (Now_Ms / 1_000) & "."
        & Ms (Ms'Last - 2 .. Ms'Last) & " s  ";
   end Stamp;

   procedure Note (Text : String) is
   begin
      Ada.Text_IO.Put_Line (Stamp & "[bench] " & Text);
   end Note;

   procedure Schedule (T : Times) is
   begin
      for P in Player loop
         Due (P) := (if T (P) = Never then Never
                     else Now_Ms + Integer (T (P)));
      end loop;
   end Schedule;

   procedure End_Round is
   begin
      Bench := Resting;
      At_Rest := 0;
      Due := [others => Never];
      Current := Current + 1;
   end End_Round;

   --  The bench looks at the lamps as they were left by the last
   --  Show, then moves the players' fingers for this millisecond.
   procedure Play is
      Go  : constant Boolean := Lamp (15) = High;
      Won : constant Boolean :=
        Lamp (14) = High or else Lamp (13) = High;
   begin
      case Bench is
         when Resting =>
            At_Rest := (if Go or else Won then 0 else At_Rest + 1);
            if At_Rest = 2_500 then
               if Current > Script'Last then
                  Note ("end of script");
                  GNAT.OS_Lib.OS_Exit (0);
               end if;
               Note ("round" & Current'Image);
               Schedule (Script (Current).Early);
               Due (A) := Now_Ms;            --  A starts each round
               Bench := Waiting_Go;
            end if;
         when Waiting_Go =>
            if Go then
               Note ("Go lamp seen");
               Schedule (Script (Current).Late);
               Bench := After_Go;
            elsif Won then
               End_Round;
            end if;
         when After_Go =>
            if not Go then
               End_Round;
            end if;
      end case;

      for P in Player loop
         if Due (P) = Now_Ms then
            Note (P'Image & " presses");
            Held (P) := 0;
            Due (P) := Never;
         end if;
         if Held (P) /= Never then
            Press (Button_Of (P), Contact (Held (P)));
            Held (P) := (if Held (P) = Contact'Last then Never
                         else Held (P) + 1);
            if Held (P) = Never then
               Let_Go (Button_Of (P));
            end if;
         end if;
      end loop;
   end Play;

   procedure Initialize is
      Stat : Status;
   begin
      Claim (Go_Lamp, (others => <>), Stat);
      pragma Assert (Stat = Ok);
      Claim (Lamp_A, (others => <>), Stat);
      pragma Assert (Stat = Ok);
      Claim (Lamp_B, (others => <>), Stat);
      pragma Assert (Stat = Ok);
      Claim (Button_A, (Bias => Pull_Up), Stat);
      pragma Assert (Stat = Ok);
      Claim (Button_B, (Bias => Pull_Up), Stat);
      pragma Assert (Stat = Ok);
   end Initialize;

   procedure Next_Tick is
   begin
      Now_Ms := Now_Ms + 1;
      Play;
   end Next_Tick;

   function Clock return Natural is (Now_Ms * 1_000);

   function Presses return Players renames The_Panel.Presses;
   procedure Show (L : Lamps) renames The_Panel.Show;

   procedure Put_Line (Text : String) is
   begin
      Ada.Text_IO.Put_Line (Text);
   end Put_Line;
end Board;
