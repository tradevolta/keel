procedure Initialize
  (P    : in out Panel;
   D    : in out Link.Device;
   DC   : in out Pins.Pin;
   T    : Rotation;
   Stat : out Status)
is
   --  Each step and the pause after it (9.1.2, 9.1.12): 120 ms
   --  after SWRESET before SLPOUT may come, 5 ms after SLPOUT
   --  before the next command. Adafruit's library waits 150 and
   --  10.
   type Step is record
      Cmd   : Byte;
      Param : Parameter;
      Wait  : Natural range 0 .. 150;
   end record;
   Steps : constant array (1 .. 7) of Step :=
     [(SWRESET, -1, 150),
      (SLPOUT, -1, 10),
      (COLMOD, RGB565_Format, 10),
      (MADCTL, Integer (Access_Control (T)), 0),
      (INVON, -1, 10),
      (NORON, -1, 10),
      (DISPON, -1, 10)];
begin
   P.Is_Ready := False;
   for S of Steps loop
      pragma Loop_Invariant (not P.Busy and then not P.Is_Ready);
      Command (D, DC, S.Cmd, S.Param, Stat);
      if Stat /= Ok then
         return;
      end if;
      Pause (S.Wait);
   end loop;
   P.Rotated := T;
   P.Is_Ready := True;
   Stat := Ok;
end Initialize;
