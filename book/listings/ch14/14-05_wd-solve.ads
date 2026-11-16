--  The setting for T, with the smallest prescaler that reaches it.
--  Found is False if even the largest setting is too short.
procedure Solve
  (L : Counter_Limits; T : Timeout_Ms; S : out Setting;
   Found : out Boolean)
  with Post =>
    (if Found
     then Fits (L, S)
          and then Ticks (L, S) >= Ticks_For (L, T)
          and then Ticks (L, S) - Pow2 (S.Shift) < Ticks_For (L, T)
     else Ticks (L, (L.Max_Shift, L.Max_Reload))
            < Ticks_For (L, T));
