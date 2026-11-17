procedure Take_Three (R : in out Bytes.Ring; S : out String) is
begin
   for I in S'Range loop
      Bytes.Pop (R, S (I));
   end loop;
end Take_Three;
