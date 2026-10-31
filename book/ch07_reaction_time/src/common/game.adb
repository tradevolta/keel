--  SPDX-License-Identifier: Apache-2.0
package body Game is

   function Any (P : Players) return Boolean is (P (A) or else P (B));

   procedure Finish (S : in out State; Winners : Players) is
   begin
      S := (Now   => Done,
            Left  => Show_Time,
            Taken => 0,
            Shown => (Go => False, Winner => Winners));
   end Finish;

   procedure Step
     (S       : in out State;
      Pressed : Players;
      Seed    : Natural;
      E       : out Event)
   is
      Spread : constant Natural :=
        Natural (Longest_Delay - Shortest_Delay) + 1;
   begin
      E := (others => <>);
      case S.Now is
         when Idle =>
            if Any (Pressed) then
               S.Now := Waiting;
               S.Left := Shortest_Delay
                 + Milliseconds (Seed mod Spread);
               S.Shown := (others => <>);
               E := (Kind => Started, others => <>);
            end if;

         when Waiting =>
            if Any (Pressed) then
               --  Too early: the other player wins (nobody, if both)
               E := (Kind => False_Start, Who => Pressed, Time => 0);
               Finish (S, [A => Pressed (B) and then not Pressed (A),
                           B => Pressed (A) and then not Pressed (B)]);
            elsif S.Left = 0 then
               S.Now := Go;
               S.Taken := 0;
               S.Shown := (Go => True, Winner => Nobody);
            else
               S.Left := S.Left - 1;
            end if;

         when Go =>
            if Any (Pressed) then
               E := (Kind => Winner, Who => Pressed, Time => S.Taken);
               Finish (S, Pressed);
            elsif S.Taken = Time_Limit then
               E := (Kind => No_Press, others => <>);
               Finish (S, Nobody);
            else
               S.Taken := S.Taken + 1;
            end if;

         when Done =>
            --  Presses are ignored while the result is shown
            if S.Left = 0 then
               S.Now := Idle;
               S.Shown := (others => <>);
            else
               S.Left := S.Left - 1;
            end if;
      end case;
   end Step;

   function Names (P : Players) return String is
     (if P (A) and then P (B) then "A and B"
      elsif P (A) then "A"
      else "B");

   function Message (E : Event) return String is
      Time : constant String := E.Time'Image;  --  leading space
   begin
      case E.Kind is
         when None        => return "";
         when Started     => return "wait for the Go lamp...";
         when False_Start => return "false start: " & Names (E.Who);
         when Winner      =>
            if E.Who (A) and then E.Who (B) then
               return "tie:" & Time & " ms";
            end if;
            return Names (E.Who) & " wins:" & Time & " ms";
         when No_Press    =>
            return "no press in" & Time_Limit'Image & " ms";
      end case;
   end Message;
end Game;
