--  SPDX-License-Identifier: Apache-2.0
with Board;
with Commands;        use Commands;
with Console_Shell;   use Console_Shell;
with Display;
with Keel;            use Keel;
with Keel.CLI.Words;  use Keel.CLI.Words;

package body Screen_Commands is
   use Dashboard;

   Day_Ms : constant := 86_400_000;

   Source     : Gauge_Source := Light;
   Go         : Boolean := True;
   --  The time of day at uptime 0, in milliseconds
   Offset     : Natural := 0;
   Last_Temp  : Natural := Natural'Last;
   Last_Past  : Natural := Natural'Last;
   Last_Count : Natural := Natural'Last;
   Counted    : Natural := 0;

   function Running return Boolean is (Go);

   function Light_Level (Value : out Per_Mille) return Boolean is
      Code, Millivolts : Natural;
      Stat             : Status;
   begin
      Board.Read_ADC (0, Code, Millivolts, Stat);
      Value := (if Stat = Ok then Natural'Min (Code, 4_095) * 1_000
                                  / 4_095 else 0);
      return Stat = Ok;
   end Light_Level;

   procedure Update (R : in out Dashboard.Readings) is
      Now    : constant Natural := Board.Uptime_Ms;
      Target : Per_Mille;
      Stat   : Status;
   begin
      R.Seconds := ((Now mod Day_Ms + Offset) mod Day_Ms) / 1_000;
      R.Source := Source;
      if Source = Sweep or else not Light_Level (Target) then
         Target := Sweep_At (Now);
         R.Source := Sweep;
      end if;
      R.Needle := Ease (R.Needle, Target);
      if Now / 500 /= Last_Past then
         Last_Past := Now / 500;
         Record_Reading (R, Target);
      else
         R.Reading := Target;
      end if;
      if Now / 1_000 /= Last_Temp then
         Last_Temp := Now / 1_000;
         Board.Read_Temperature (R.Centi_C, Stat);
         R.Has_Temp := Stat = Ok;
         --  Frames shown in the second that just ended
         if Last_Count /= Natural'Last then
            R.FPS_Tenths := (Display.Last.Frames - Counted) * 10;
         end if;
         Last_Count := Now / 1_000;
         Counted := Display.Last.Frames;
      end if;
   end Update;

   --  screen [light|sweep|pause|run]
   procedure Screen (Args : Arguments) is
      T : constant Display.Timing := Display.Last;
   begin
      if Count (Args) = 2 then
         declare
            W : constant String := Word (Args, 2);
         begin
            if W = "light" then
               Source := Light;
            elsif W = "sweep" then
               Source := Sweep;
            elsif W = "pause" then
               Go := False;
            elsif W = "run" then
               Go := True;
            else
               Show_Usage ("screen");
               return;
            end if;
         end;
      elsif Count (Args) /= 1 then
         Show_Usage ("screen");
         return;
      end if;
      Put_Line (Display.Name);
      Put_Line ("frames " & Image (T.Frames) & ", last: draw "
                & Image (T.Draw_Us) & " us, wait " & Image (T.Wait_Us)
                & " us, period " & Image (T.Period_Us) & " us");
      Put_Line ("gauge: "
                & (if Source = Light then "light" else "sweep")
                & (if Go then "" else ", paused")
                & ", bus set up " & Image (Display.Reconfigurations)
                & " times");
   end Screen;

   --  time hh:mm[:ss]
   procedure Time (Args : Arguments) is
      function Field (S : String) return Integer is
        (if S'Length = 2 and then (for all C of S => C in '0' .. '9')
         then Integer'Value (S) else -1);
   begin
      if Count (Args) /= 2 then
         Show_Usage ("time");
         return;
      end if;
      declare
         S  : constant String := Word (Args, 2);
         F  : constant Positive := S'First;
         HH : constant Integer :=
           (if S'Length in 5 | 8 then Field (S (F .. F + 1)) else -1);
         MM : constant Integer :=
           (if S'Length in 5 | 8 then Field (S (F + 3 .. F + 4))
            else -1);
         SS : constant Integer :=
           (if S'Length = 8 then Field (S (F + 6 .. F + 7)) else 0);
      begin
         if HH not in 0 .. 23 or else MM not in 0 .. 59
           or else SS not in 0 .. 59
         then
            Show_Usage ("time");
            return;
         end if;
         Offset := ((HH * 3_600 + MM * 60 + SS) * 1_000
                    + Day_Ms - Board.Uptime_Ms mod Day_Ms) mod Day_Ms;
         Put_Line
           ("time set: " & Clock_Image (HH * 3_600 + MM * 60 + SS));
      end;
   end Time;

   procedure Register is
      procedure Add (Name, Usage : String; Run : not null Handler) is
         Stat : Status;
      begin
         Console_Shell.Register (Name, Usage, Run, Stat);
         pragma Assert (Stat = Ok);
      end Add;
   begin
      Add ("screen", "screen [light|sweep|pause|run]", Screen'Access);
      Add ("time", "time hh:mm[:ss]", Time'Access);
   end Register;
end Screen_Commands;
