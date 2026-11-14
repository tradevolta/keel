procedure Solve
  (L : PLL_Limits; Ref, Target : Frequency; Overclock : Boolean;
   Config : out PLL_Config; Found : out Boolean)
is
   Null_PLL : constant PLL_Config := (others => <>);
   --  The VCO of the best setting so far
   Best : Frequency := 0;
   F : Divider;
   Ok : Boolean;
begin
   Config := Null_PLL;
   Found := False;
   if Ref = 0 or else Target = 0
     or else (Target > L.Rated_Max and then not Overclock)
   then
      return;
   end if;
   for R in 1 .. L.Ref_Div_Max loop
      for P1 in reverse 1 .. L.Post_1_Max loop
         for P2 in reverse 1 .. Post_Divider'Min (P1, L.Post_2_Max)
         loop
            Candidate (L, Ref, Target, R, P1, P2, F, Ok);
            if Ok
              and then Product (Ref) * Product (F) / Product (R)
                         > Product (Best)
            then
               Config :=
                 (L => L, Ref => Ref, R => R, F => F,
                  P1 => P1, P2 => P2);
               Best := VCO (Config);
               Found := True;
            end if;
            pragma Loop_Invariant
              (So_Far (Config, Found, L, Ref, Target));
         end loop;
         pragma Loop_Invariant
           (So_Far (Config, Found, L, Ref, Target));
      end loop;
      pragma Loop_Invariant
        (So_Far (Config, Found, L, Ref, Target));
   end loop;
   if Found then
      Lemma_Exact
        (Product (Ref) * Product (Config.F),
         Divisor (L, Config.R, Config.P1, Config.P2),
         Product (Target));
   end if;
end Solve;
