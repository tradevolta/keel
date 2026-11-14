--  AINSEL: 0 to 3 are GPIO26 to GPIO29, 4 is the sensor
--  (datasheet 12.4.2.1, Table 1171)
type Channel is range 0 .. 4;
Temperature_Sensor : constant Channel := 4;
subtype Pin_Channel is Channel range 0 .. 3;

function Pin_Of (Ch : Pin_Channel) return Keel.GPIO.RP2350.Pin_Id is
  (Keel.GPIO.RP2350.Pin_Id (26 + Natural (Ch)));

--  Take the ADC out of reset and power it up. Timeout: it never
--  reported READY (is clk_adc running?).
procedure Enable (Stat : out Status)
  with Post => Is_Enabled = (Stat = Ok);
function Is_Enabled return Boolean;

--  Make Ch an input: a pin goes to the ADC, with its digital
--  pad off, or the sensor's bias current turns on. In_Use: the
--  pin has another owner.
procedure Claim (Ch : Channel; Stat : out Status)
  with Pre  => Is_Enabled and then Keel.GPIO.RP2350.Is_Enabled
               and then not Is_Claimed (Ch),
       Post => Is_Claimed (Ch) = (Stat = Ok);
function Is_Claimed (Ch : Channel) return Boolean;

--  Convert Ch once: 96 cycles of clk_adc, 2 us. A conversion
--  that didn't converge (CS.ERR) is tried again, up to three
--  times. Timeout: no good result.
procedure Read (Ch : Channel; Value : out Code; Stat : out Status)
  with Pre  => Is_Enabled and then Is_Claimed (Ch),
       Post => Value <= Top (Converter);
