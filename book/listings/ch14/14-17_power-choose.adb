function Choose (P : Policy; Budget : Time_Span) return Mode is
begin
   for M in reverse Mode'Succ (Run) .. P.Deepest loop
      if P.Wake (M) <= Budget then
         return M;
      end if;
      pragma Loop_Invariant
        (for all N in M .. P.Deepest => P.Wake (N) > Budget);
   end loop;
   return Run;
end Choose;
