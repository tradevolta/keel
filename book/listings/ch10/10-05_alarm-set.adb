procedure Set (A : in out Alarm; At_Time : Keel.Time.Time) is
begin
   --  Writing the alarm word arms it; it fires when the low 32
   --  bits of the counter equal it
   Alarms (Natural (A.Id)) := Unsigned_32 (At_Time mod 2**32);
   if Keel.Time.Bare.Clock >= At_Time and then Is_Armed (A) then
      --  Written too late to match: fire it by hand
      Cancel (A);
      Keel.Interrupts.Set_Pending (IRQ_Of (A.Id));
   end if;
end Set;
