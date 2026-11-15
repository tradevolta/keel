procedure Lend (B : in out Buffer; R : out Region)
  with SPARK_Mode => Off
is
begin
   --  A new loan number: no earlier receipt covers this loan
   B.Loans := B.Loans + 1;
   R := (Base   => To_Integer (B.Data'Address),
         Bytes  => Elements * Bytes (Size),
         Device => False,
         Loan   => B.Loans);
   B.Where := R;
   B.Who := Engine;
end Lend;

procedure Reclaim (B : in out Buffer; Done : Receipt) is
begin
   pragma Unreferenced (Done);
   B.Where := No_Region;
   B.Who := Program;
end Reclaim;
