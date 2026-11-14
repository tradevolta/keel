--  SPDX-License-Identifier: Apache-2.0
package body Keel.PWM
  with SPARK_Mode
is
   procedure Solve
     (L : Counter_Limits; Clock : Hertz;
      Want : Hertz; Mode : Shape; S : out Setting;
      Stat : out Status)
   is
      N : constant Wide := 16 * Wide (Clock);
      Room : constant Wide := Wide (L.Top_Max) + 1;
      Step : constant Wide := Wide (L.Div_Step);
      M, D, K, Counts : Wide;
   begin
      S := (others => <>);
      Stat := Not_Supported;
      if Want < 1.0
        or else (Mode = Phase_Correct and then not L.Phase_Correct)
      then
         return;
      end if;
      M := Factor (Mode) * Wide (Want);

      --  The smallest divider that leaves at most Room counts in a
      --  period, rounded up to the divider's step
      D := (N + M * Room - 1) / (M * Room);
      D := (D + Step - 1) / Step * Step;
      pragma Assert (D mod Step = 0);
      D := Wide'Max (D, Wide (L.Div_Min));
      if D > Wide (L.Div_Max) then
         return;
      end if;
      pragma Assert (D mod Step = 0 and then D in 16 .. 2**20);

      K := D * Factor (Mode) * Wide (Want);
      Counts := Nearest (N, K);
      if Counts < 2 or else Counts > Room then
         return;
      end if;
      S := (L => L, C => Clock, D => Sixteenths (D),
            T => Count (Counts - 1), M => Mode);
      Stat := Ok;
   end Solve;

   function Output (S : Setting) return Hertz is
      F : constant Wide :=
        Nearest (16 * Wide (S.C), Period_16 (S));
   begin
      return Hertz (Wide'Min (F, 1_000_000_000));
   end Output;

   --  The smallest duty, 1/65536
   Step_Of_Duty : constant Duty := Duty'Small;

   function Level_For (S : Setting; D : Duty) return Count is
      Raw : constant Wide := Wide (D / Step_Of_Duty);
   begin
      return Count (Nearest (Raw * (Wide (S.T) + 1), 2**16));
   end Level_For;

   function Width_Level (S : Setting; W : Micro_Seconds) return Count
   is
      --  Counts in W: W * Clock * 16 / (Div * Factor * 10**6)
      K : constant Wide := Wide (S.D) * Factor (S.M) * 62_500;
      Counts : constant Wide := (Wide (W) * Wide (S.C) + K / 2) / K;
   begin
      return Count (Wide'Min (Counts, Wide (S.T) + 1));
   end Width_Level;
end Keel.PWM;
