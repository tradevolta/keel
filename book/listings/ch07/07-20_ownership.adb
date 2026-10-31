--  Ownership
declare
   Led   : Output_Pin (15);
   Again : Output_Pin (15);
begin
   Claim (Led, (Initial => High, others => <>), Stat);
   Check ("claim GP15 -> Ok", Stat = Ok);
   Check ("GP15 starts High", Lamp (15) = High);
   Claim (Again, (others => <>), Stat);
   Check ("claim GP15 again -> In_Use", Stat = In_Use);
   Check ("second object not claimed", not Is_Claimed (Again));
   Release (Led);
   Claim (Again, (others => <>), Stat);
   Check ("claim after Release -> Ok", Stat = Ok);
   Set (Again, High);
   Check ("Set High drives High", Lamp (15) = High);
   Release (Again);
end;
