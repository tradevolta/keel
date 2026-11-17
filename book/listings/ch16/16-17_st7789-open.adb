--  The first and last address, big-endian, as CASET and RASET
--  take them
function Bounds (First, Last : RAM_Address) return Byte_Array is
  (Byte_Array'[Byte (First / 256), Byte (First mod 256),
               Byte (Last / 256), Byte (Last mod 256)]);

--  With the bus held: set the window and start a memory write
procedure Open_Window
  (D  : in out Link.Device;
   DC : in out Pins.Pin;
   W  : Window;
   T  : Rotation)
is
begin
   Send (D, DC, CASET,
         Bounds (First_Column (W, T), Last_Column (W, T)));
   Send (D, DC, RASET, Bounds (First_Row (W, T), Last_Row (W, T)));
   --  RAMWR's data are the pixels that follow
   Send_Code (D, DC, RAMWR);
   Pins.Set (DC, Keel.GPIO.High);
end Open_Window;
