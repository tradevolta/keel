--  N / K to the nearest whole number, halves rounded up
function Nearest (N, K : Wide) return Wide is
  ((2 * N + K) / (2 * K))
  with Pre => N in 0 .. 2**40 and then K in 1 .. 2**60;

--  Top + 1 is the whole number of counts nearest to the exact
--  period, 16 * Clock / (Div * Factor * Want): the period is
--  within half a count of 1 / Want
function Close (S : Setting; Want : Hertz) return Boolean is
  (Want >= 1.0
   and then Wide (Top (S)) + 1
              = Nearest (16 * Wide (Clock (S)),
                         Wide (Div (S)) * Factor (Mode (S))
                         * Wide (Want)));

--  Find the setting with the largest Top, so the finest duty
--  steps, that makes Want from Clock. Not_Supported: Want is
--  out of reach, or Phase_Correct on a counter without it.
procedure Solve
  (L : Counter_Limits; Clock : Hertz;
   Want : Hertz; Mode : Shape; S : out Setting;
   Stat : out Status)
  with
    Pre  => Valid (L),
    Post =>
      (if Stat = Ok then
         Limits (S) = L
         and then PWM.Clock (S) = Clock
         and then PWM.Mode (S) = Mode
         and then Close (S, Want));
