procedure Claim
  (P : in out Input_Pin; Config : Input_Config; Stat : out Status)
is
   Bit : constant Pin_Set := Only (P.Id);
begin
   if Taken (Pin (P.Id)) then
      Stat := In_Use;
   elsif Config.Bias = Pull_Down and then Is_A2 then
      Stat := Not_Supported;
   else
      Disable_Output (Bit);
      IO (P.Id).Control := SIO_Function;
      Pads (P.Id) :=
        (PUE    => Config.Bias = Pull_Up,
         PDE    => Config.Bias = Pull_Down,
         IE     => True,
         ISO    => False,
         others => <>);

      Taken := Taken or Bit;
      P.Claimed := True;
      Stat := Ok;
   end if;
end Claim;
