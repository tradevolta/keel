type PLL_Config is record
   L : PLL_Limits :=
     (PFD_Min | PFD_Max | VCO_Min | VCO_Max | Rated_Max => 0,
      others => 1);
   Ref : Frequency := 0;
   R : Divider := 1;
   F : Divider := 1;
   P1 : Post_Divider := 1;
   P2 : Post_Divider := 1;
end record
  with Type_Invariant => Within (L, Ref, R, F, P1, P2);
