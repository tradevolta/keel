--  Take block B out of reset, with all 32 slots free
procedure Enable (B : Block)
  with Post => Is_Enabled (B);
function Is_Enabled (B : Block) return Boolean;

--  Put P in the first run of P.Last + 1 free slots of B, its JMPs
--  moved by Offset, where it starts. Not_Supported: no room.
procedure Load
  (B : Block; P : Program; Offset : out Address; Stat : out Status)
  with Pre  => Is_Enabled (B) and then Well_Formed (P),
       Post => (if Stat = Ok
                then Integer (Offset) + Integer (P.Last) <= 31);

--  In_Use: M of B has another owner
procedure Claim (B : Block; M : Machine; Stat : out Status)
  with Pre  => Is_Enabled (B),
       Post => (if Stat = Ok then Is_Claimed (B, M));
function Is_Claimed (B : Block; M : Machine) return Boolean;

--  Reserve pin Id and connect it to block B (function PIO0, PIO1
--  or PIO2). In_Use: the pin has an owner.
procedure Use_Pin (B : Block; Id : Pin_Id; Stat : out Status)
  with Pre => Is_Enabled (B)
              and then Keel.GPIO.RP2350.Is_Enabled;
