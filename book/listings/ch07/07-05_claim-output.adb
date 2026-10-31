procedure Claim
  (P      : in out Output_Pin;
   Config : Output_Config;
   Stat   : out Status;
   Drive  : Drive_Current := Drive_4mA)
is
   Bit : constant Pin_Set := Only (P.Id);
begin
   if Taken (Pin (P.Id)) then
      Stat := In_Use;
      return;
   end if;

   --  Level, then output enable, then function, then pad: the
   --  pin never drives anything but Config.Initial.
   if Config.Initial = High then
      Output_Set (Bit);
   else
      Output_Clear (Bit);
   end if;
   Enable_Output (Bit);
   IO (P.Id).Control := SIO_Function;
   Pads (P.Id) :=
     (SLEWFAST => Config.Slew = Fast,
      PDE      => False,
      DRIVE    => GPIO0_DRIVE_Field'Val (Drive_Current'Pos (Drive)),
      ISO      => False,
      others   => <>);

   Taken := Taken or Bit;
   P.Claimed := True;
   Stat := Ok;
end Claim;
