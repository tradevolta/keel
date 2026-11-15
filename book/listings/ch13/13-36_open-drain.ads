--  Claim P as an open-drain output (RM0440, GPIOx_OTYPER): Low
--  pulls the line low, High lets it go, and a pull-up or another
--  device sets the level, which Sense reads. For buses such as
--  1-Wire.
procedure Claim_Open_Drain
  (P : in out Output_Pin; Config : Output_Config; Stat : out Status)
  with Pre  => not Is_Claimed (P),
       Post => Is_Claimed (P) = (Stat = Ok)
               and then (if Stat = Ok
                         then Driven (P) = Config.Initial);

--  The level on the pin (GPIOx_IDR), whoever sets it
function Sense (P : Output_Pin) return Level
  with Pre => Is_Claimed (P);
