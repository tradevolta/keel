--  Reset, then address one device (Match ROM) or every device
--  (Skip ROM). No_Device: nothing answered the reset.
procedure Select_Device
  (B : in out Bus; ROM : ROM_Code; Stat : out Status);
procedure Select_All (B : in out Bus; Stat : out Status);

--  The ROM search. Start with a fresh Search_State and call Next
--  until Found is False: each call finds one more ROM code, in
--  order of their bits, least significant first.
type Search_State is private;
Fresh_Search : constant Search_State;

--  Found: ROM is the next device's code, and its CRC is good.
--  CRC_Error: a code arrived damaged; start again. No_Device:
--  nothing answered, or the devices stopped answering. Bus_Low:
--  the code read as all zeros, which no device has.
procedure Next
  (B     : in out Bus;
   S     : in out Search_State;
   ROM   : out ROM_Code;
   Found : out Boolean;
   Stat  : out Status)
  with Post => (if Found
                then Stat = Ok and then Valid (ROM)
                     and then not All_Zero (ROM));
