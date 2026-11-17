--  With the bus held: Cmd with D/CX low
procedure Send_Code
  (D   : in out Link.Device;
   DC  : in out Pins.Pin;
   Cmd : Byte)
is
   Code : constant Byte_Array (1 .. 1) := [1 => Cmd];
begin
   Pins.Set (DC, Keel.GPIO.Low);
   Link.Write (D, Code);
end Send_Code;

--  With the bus held: Cmd with D/CX low, then its parameters with
--  D/CX high
procedure Send
  (D      : in out Link.Device;
   DC     : in out Pins.Pin;
   Cmd    : Byte;
   Params : Byte_Array)
is
begin
   Send_Code (D, DC, Cmd);
   Pins.Set (DC, Keel.GPIO.High);
   Link.Write (D, Params);
end Send;
