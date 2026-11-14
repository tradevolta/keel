--  SPDX-License-Identifier: Apache-2.0
--  The frequency explorer: each press of the button moves clk_sys
--  to the next step. The clock out pin carries clk_sys / 1000; the
--  console reports the plan, the measured clock and the current.
with Board;      use Board;
with Explorer;   use Explorer;
with Keel;       use Keel;
with Keel.Clock; use Keel.Clock;

procedure Frequency_Explorer is
   Now  : Step := Step'First;
   Stat : Status;

   procedure Go_To (S : Step) is
      P : constant Plan :=
        Plan_For (Limits, Reference, Target (S), Overclock => True);
   begin
      Put_Line ("step" & S'Image & ": "
                & MHz_Image (Natural (Target (S) / 1_000)));
      case P.Kind is
         when From_Reference =>
            Put_Line ("  plan: the reference, no PLL");
         when From_PLL =>
            Put_Line ("  plan: " & Setting_Image (P.Setting));
         when Refused =>
            Put_Line ("  plan: none");
      end case;
      Switch (P, Stat);
      if Stat /= Ok then
         Put_Line ("  refused: " & Stat'Image);
      end if;
      Put_Line ("  measured clk_sys: " & Measured_Image);
      Put_Line ("  supply: " & Supply_Image);
   end Go_To;
begin
   Initialize;
   Go_To (Now);
   loop
      Next_Tick;
      if Pressed then
         Now := (if Now = Step'Last then Step'First else Now + 1);
         Go_To (Now);
      end if;
   end loop;
end Frequency_Explorer;
