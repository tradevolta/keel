--  SPDX-License-Identifier: Apache-2.0
--  A model of the ST7789 on the fake bus: it reads D/CX from the
--  fake GPIO, keeps the column and row windows that CASET and RASET
--  set, MADCTL, and a frame memory of 240 columns by 320 rows that
--  RAMWR fills, with MV, MX and MY applied as the datasheet's
--  section 9.1.28 describes. Only what the driver uses is modelled.
with Interfaces; use Interfaces;
with Keel.Bus.SPI;
with Keel.GPIO.Fake;

package Panel_Model is
   --  The panel's device number on the bus, and its D/CX pin
   procedure Connect
     (Who : Keel.Bus.SPI.Device_Number; DC : Keel.GPIO.Fake.Pin_Id);

   --  For Keel.Bus.SPI.Fake.Listen
   procedure Hear
     (Who : Keel.Bus.SPI.Device_Number; Frame : Natural;
      Bits : Positive);

   --  The commands heard since Clear_Log, one line each: the command
   --  and up to four parameters in hex, then how many more followed
   function Log return String;
   procedure Clear_Log;

   --  What the controller holds at column X, row Y of its memory
   function Memory (X : Natural; Y : Natural) return Unsigned_16;

   --  Pixels written to rows 240 to 319, which the panel doesn't
   --  show, and outside the memory altogether
   function Hidden return Natural;
   function Outside return Natural;
   function Pixels_Written return Natural;

   --  The pixel at screen position (X, Y), read back through the
   --  window offsets the driver used and the MADCTL it sent
   function View (X, Y, Column_Offset, Row_Offset : Natural)
     return Unsigned_16;
end Panel_Model;
