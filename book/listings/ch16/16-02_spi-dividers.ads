--  RP2350 PL022: Rate = Clock / (Prescale * (1 + Serial_Rate)),
--  Prescale (CPSDVSR) even from 2 to 254, Serial_Rate (SCR) from
--  0 to 255 (datasheet 12.3.4.6.1)
type Prescaled is record
   Prescale    : Positive range 2 .. 254 := 2;
   Serial_Rate : Natural range 0 .. 255  := 0;
end record
  with Predicate => Prescale mod 2 = 0;

function Divisor (D : Prescaled) return Positive is
  (D.Prescale * (D.Serial_Rate + 1));

--  The PL022 divider for at most Max from Clock. Up to a needed
--  divisor of 254, every even divisor is there, so the one found
--  is the fastest; above, it is within one prescale step of it.
--  Found is False if even 254 * 256 is too fast.
procedure Solve_Prescaled
  (Clock : Clock_Hz; Max : Bit_Rate; D : out Prescaled;
   Found : out Boolean)
  with Post =>
    (if Found
     then Slow_Enough (Clock, Max, Divisor (D))
          and then (if Needed (Clock, Max) <= 254
                    then Divisor (D) <= Needed (Clock, Max) + 1)
     else Needed (Clock, Max) > 254 * 256);

--  STM32G4 SPI: Rate = PCLK / 2**(BR + 1), BR from 0 to 7
--  (RM0440 Rev 9, 42.9.1)
subtype Baud_Shift is Natural range 0 .. 7;

function Divisor (BR : Baud_Shift) return Positive is
  (2**(BR + 1));

--  The fastest power-of-two divider for at most Max from Clock.
--  Found is False if even 256 is too fast.
procedure Solve_Power_Of_Two
  (Clock : Clock_Hz; Max : Bit_Rate; BR : out Baud_Shift;
   Found : out Boolean)
  with Post =>
    (if Found
     then Slow_Enough (Clock, Max, Divisor (BR))
          and then (BR = 0 or else 2**BR < Needed (Clock, Max))
     else Needed (Clock, Max) > 256);
