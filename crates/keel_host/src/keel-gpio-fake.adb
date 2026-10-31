--  SPDX-License-Identifier: Apache-2.0
package body Keel.GPIO.Fake is

   type Pin_State is record
      Taken    : Boolean := False;
      Output   : Level   := Low;
      Bias     : Pull    := Floating;
      Pressed  : Boolean := False;
      Outside  : Level   := Low;
      Changes  : Natural := 0;
   end record;

   Pins : array (Pin_Id) of Pin_State;
   No_Pull_Down : Boolean := False;

   function Driven (P : Output_Pin) return Level is
     (Pins (P.Id).Output);

   procedure Claim
     (P : in out Output_Pin; Config : Output_Config; Stat : out Status)
   is
   begin
      if Pins (P.Id).Taken then
         Stat := In_Use;
      else
         Pins (P.Id) :=
           (Taken => True, Output => Config.Initial, others => <>);
         P.Claimed := True;
         Stat := Ok;
      end if;
   end Claim;

   procedure Claim
     (P : in out Input_Pin; Config : Input_Config; Stat : out Status)
   is
   begin
      if Pins (P.Id).Taken then
         Stat := In_Use;
      elsif Config.Bias = Pull_Down and then No_Pull_Down then
         Stat := Not_Supported;
      else
         Pins (P.Id).Taken := True;
         Pins (P.Id).Bias := Config.Bias;
         P.Claimed := True;
         Stat := Ok;
      end if;
   end Claim;

   procedure Release (P : in out Output_Pin) is
   begin
      Pins (P.Id).Taken := False;
      P.Claimed := False;
   end Release;

   procedure Release (P : in out Input_Pin) is
   begin
      Pins (P.Id).Taken := False;
      P.Claimed := False;
   end Release;

   procedure Set (P : in out Output_Pin; To : Level) is
   begin
      if Pins (P.Id).Output /= To then
         Pins (P.Id).Changes := Pins (P.Id).Changes + 1;
      end if;
      Pins (P.Id).Output := To;
   end Set;

   function Get (P : Input_Pin) return Level is
      S : Pin_State renames Pins (P.Id);
   begin
      if S.Pressed then
         return S.Outside;
      end if;
      return (if S.Bias = Pull_Up then High else Low);
   end Get;

   procedure Press (Id : Pin_Id; To : Level) is
   begin
      Pins (Id).Pressed := True;
      Pins (Id).Outside := To;
   end Press;

   procedure Let_Go (Id : Pin_Id) is
   begin
      Pins (Id).Pressed := False;
   end Let_Go;

   function Lamp (Id : Pin_Id) return Level is (Pins (Id).Output);
   function Edges (Id : Pin_Id) return Natural is (Pins (Id).Changes);

   procedure Refuse_Pull_Down (Refuse : Boolean) is
   begin
      No_Pull_Down := Refuse;
   end Refuse_Pull_Down;

   procedure Reset_All is
   begin
      Pins := [others => <>];
      No_Pull_Down := False;
   end Reset_All;
end Keel.GPIO.Fake;
