--  An 8.4 divider from 1.0 to 256.0, a 16-bit counter, and
--  phase-correct mode
Slice_Limits : Counter_Limits renames Chip_Limits.RP2350_Slice;

--  GPIO0 to GPIO29 use slices 0 to 7: GPIO 2N and 2N + 1 are
--  slice N's A and B, and GPIO16 starts again at slice 0
--  (datasheet 12.5.2, Table 1183)
type Slice_Id is range 0 .. 7;

function Slice_Of (Pin : Pin_Id) return Slice_Id is
  (Slice_Id (Pin / 2 mod 8));

--  Only a B pin can be a counter's input
subtype B_Pin is Pin_Id
  with Static_Predicate =>
    B_Pin in 1 | 3 | 5 | 7 | 9 | 11 | 13 | 15 | 17 | 19 | 21 | 23
           | 25 | 27 | 29;

--  Take the PWM block out of reset. Once, before the first Claim.
procedure Enable
  with Post => Is_Enabled;
function Is_Enabled return Boolean;
