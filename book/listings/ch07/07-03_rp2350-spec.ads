--  Bank 0 of the RP2350A (QFN-60): GPIO0 to GPIO29
type Pin_Id is range 0 .. 29;

--  Pad drive strength, an RP2350 extra (reset value: 4 mA)
type Drive_Current is (Drive_2mA, Drive_4mA, Drive_8mA, Drive_12mA);

type Output_Pin (Id : Pin_Id) is limited private;
type Input_Pin (Id : Pin_Id) is limited private;

--  Take IO_BANK0 and PADS_BANK0 out of reset. Call it once,
--  before the first Claim.
procedure Enable
  with Post => Is_Enabled;
function Is_Enabled return Boolean;

function Is_Claimed (P : Output_Pin) return Boolean;
function Is_Claimed (P : Input_Pin) return Boolean;

--  The level SIO drives on the pin (GPIO_OUT)
function Driven (P : Output_Pin) return Level
  with Pre => Is_Claimed (P);

--  Connect the pin to SIO as an output at Config.Initial.
--  In_Use: another object owns the pin.
procedure Claim
  (P      : in out Output_Pin;
   Config : Output_Config;
   Stat   : out Status;
   Drive  : Drive_Current := Drive_4mA)
  with Pre  => Is_Enabled and then not Is_Claimed (P),
       Post => Is_Claimed (P) = (Stat = Ok)
               and then (if Stat = Ok
                         then Driven (P) = Config.Initial);

--  Connect the pin to SIO as an input. In_Use: another object
--  owns the pin. Not_Supported: Pull_Down on an A2 chip, whose
--  pull-down cannot hold a pin low (erratum RP2350-E9).
procedure Claim
  (P : in out Input_Pin; Config : Input_Config; Stat : out Status)
  with Pre  => Is_Enabled and then not Is_Claimed (P),
       Post => Is_Claimed (P) = (Stat = Ok);

--  Return the pin to its reset state: isolated, no function
procedure Release (P : in out Output_Pin)
  with Pre => Is_Claimed (P), Post => not Is_Claimed (P);
procedure Release (P : in out Input_Pin)
  with Pre => Is_Claimed (P), Post => not Is_Claimed (P);

procedure Set (P : in out Output_Pin; To : Level)
  with Pre => Is_Claimed (P), Post => Driven (P) = To;

--  The level on the pad (GPIO_IN)
function Get (P : Input_Pin) return Level
  with Pre => Is_Claimed (P);
