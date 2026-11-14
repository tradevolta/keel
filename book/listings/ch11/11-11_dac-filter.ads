--  A filter: a resistor in ohms and a capacitor in nanofarads
subtype Ohms is Positive range 1 .. 10_000_000;
subtype Nanofarads is Positive range 1 .. 1_000_000;

--  The corner frequency, 1 / (2 pi R C), to the nearest hertz
function Corner (R : Ohms; C : Nanofarads) return Hertz;

--  The worst ripple, peak to peak, at 50 % duty, when the PWM
--  period is much shorter than R C: Supply / (4 F R C)
function Ripple (Supply : Volts; F : Hertz; R : Ohms;
                 C : Nanofarads) return Volts
  with Pre => Supply in 0.5 .. 5.0 and then F in 1.0 .. 1.0E7
              and then Long_Long_Integer (R) * Long_Long_Integer (C)
                         <= 10**10;

--  The level whose average is V on a pin that swings from 0 to
--  Supply: V / Supply * (Top + 1), to the nearest count. V above
--  Supply gives Top + 1, always high.
function PWM_Level (S : Keel.PWM.Setting; Supply, V : Volts)
  return Keel.PWM.Count
  with Pre  => Supply in 0.5 .. 5.0 and then V >= 0.0,
       Post => PWM_Level'Result <= Keel.PWM.Top (S) + 1;
