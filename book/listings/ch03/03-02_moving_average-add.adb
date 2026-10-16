procedure Add (W : in out Window; Sample : Milli_Volts) is
begin
   W.Samples (W.Next) := Sample;
   W.Next := W.Next + 1;  --  mod 4: 3 + 1 wraps to 0
   if W.Filled < Window_Length then
      W.Filled := W.Filled + 1;
   end if;
end Add;
