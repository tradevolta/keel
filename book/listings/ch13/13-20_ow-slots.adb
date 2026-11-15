procedure Reset
  (Wire : in out Bus; Present : out Boolean; Stat : out Status)
is
   W      : Keel.PIO.Word;
   Result : Keel.Status;
begin
   --  Stop the machine, wherever it waits, empty its FIFOs and
   --  start it again at the program's Reset
   Stop (Wire.B, Wire.M);
   Restart (Wire.B, Wire.M);
   Execute (Wire.B, Wire.M,
            Asm.Jmp (Wire.Offset + Code.Reset));
   Start (Wire.B, Wire.M);
   Get (Wire.B, Wire.M, W,
        Keel.Time.Bare.Clock + Reset_Wait, Result);
   --  The bus low at the sample: a device is there
   Present := Result = Keel.Ok and then W mod 2 = 0;
   Stat := (if Result = Keel.Ok then Ok else Timeout);
end Reset;

procedure Touch
  (Wire : in out Bus; Bit : Boolean; Got : out Boolean;
   Stat : out Status)
is
   W      : Keel.PIO.Word;
   Result : Keel.Status;
begin
   Put (Wire.B, Wire.M, (if Bit then 1 else 0));
   Get (Wire.B, Wire.M, W,
        Keel.Time.Bare.Clock + Slot_Wait, Result);
   Got := Result = Keel.Ok and then W mod 2 = 1;
   Stat := (if Result = Keel.Ok then Ok else Timeout);
end Touch;
