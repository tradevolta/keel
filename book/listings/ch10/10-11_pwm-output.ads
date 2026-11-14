type Output (Pin : Pin_Id) is limited private;

function Is_Claimed (O : Output) return Boolean;
function Setting_Of (O : Output) return Setting
  with Pre => Is_Claimed (O);

--  Drive Pin from its slice at S, from level 0 (low). Inverted
--  swaps high and low (CSR's A_INV or B_INV). In_Use: the pin has
--  an owner, or its slice already runs another setting or counts.
procedure Claim
  (O : in out Output; S : Setting; Stat : out Status;
   Inverted : Boolean := False)
  with Pre  => Keel.GPIO.RP2350.Is_Enabled and then Is_Enabled
               and then not Is_Claimed (O)
               and then Limits (S) = Slice_Limits,
       Post => Is_Claimed (O) = (Stat = Ok)
               and then (if Stat = Ok then Setting_Of (O) = S);

--  The output is high for Level counts of each period (of each
--  half, in phase-correct mode). Takes effect at the next wrap.
procedure Set_Level (O : in out Output; Level : Count)
  with Pre => Is_Claimed (O)
              and then Level <= Top (Setting_Of (O)) + 1;
