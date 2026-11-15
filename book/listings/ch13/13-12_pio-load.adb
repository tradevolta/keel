procedure Load
  (B : Block; P : Program; Offset : out Address; Stat : out Status)
is
   Length : constant Natural := Natural (P.Last) + 1;
begin
   Offset := 0;
   Stat := Not_Supported;
   --  The first run of Length free slots
   for First in 0 .. 32 - Length loop
      if (for all S in First .. First + Length - 1 =>
            not Used (B) (Address (S)))
      then
         Offset := Address (First);
         Stat := Ok;
         exit;
      end if;
   end loop;
   if Stat = Ok then
      for I in P.Code'Range loop
         Regs (B).INSTR_MEM (Slot (Offset + I)) :=
           (INSTR_MEM0 => UInt16 (Relocated (P.Code (I), Offset)),
            others     => <>);
         Used (B) (Offset + I) := True;
      end loop;
   end if;
end Load;
