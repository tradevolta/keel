--  Sharing a bus. Each device on a bus has a number; the bus has
--  at most one holder, and remembers the settings it was last set
--  up for, so that a device that takes the bus after itself, or
--  after a device with the same settings, costs no reconfiguring.
type Device_Number is range 1 .. 8;
type Holder is range 0 .. 8;
Nobody : constant Holder := 0;

type Bus_State is record
   Owner      : Holder   := Nobody;
   Configured : Boolean  := False;
   Current    : Settings := (others => <>);
end record;

--  Who takes a free bus for Want. Reconfigure says whether the
--  hardware must be set up again first. In_Use: another device
--  holds the bus, and nothing changes.
procedure Acquire
  (B           : in out Bus_State;
   Who         : Device_Number;
   Want        : Settings;
   Reconfigure : out Boolean;
   Stat        : out Status)
  with Pre  => B.Owner /= Holder (Who),
       Post =>
         (if B.Owner'Old = Nobody
          then Stat = Ok and then B.Owner = Holder (Who)
               and then B.Configured and then B.Current = Want
               and then Reconfigure =
                 (not B.Configured'Old or else B.Current'Old /= Want)
          else Stat = In_Use and then B = B'Old
               and then not Reconfigure);

--  Who gives the bus back; its settings stay in the hardware
procedure Release (B : in out Bus_State; Who : Device_Number)
  with Pre  => B.Owner = Holder (Who),
       Post => B.Owner = Nobody
               and then B.Configured = B.Configured'Old
               and then B.Current = B.Current'Old;
