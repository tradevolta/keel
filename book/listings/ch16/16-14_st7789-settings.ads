--  Mode 0, and at most 32 MHz: Adafruit's library default. The
--  ST7789VW datasheet allows a 16 ns write cycle, the ST7789V one
--  66 ns (15 MHz); Adafruit doesn't say which its board carries.
Panel_Settings : constant Keel.Bus.SPI.Settings :=
  (Mode => 0, Max_Rate => 32_000_000);

--  Quarter turns clockwise from the way Adafruit's library calls
--  rotation 0
type Rotation is range 0 .. 3;

--  MADCTL for each turn: MY (bit 7), MX (bit 6) and MV (bit 5)
--  flip and swap the address counters (9.1.28)
type Access_Table is array (Rotation) of Keel.Bus.SPI.Byte;
Access_Control : constant Access_Table :=
  [16#C0#, 16#A0#, 16#00#, 16#60#];

--  Where the 240 x 240 window starts in the controller's RAM
type Offset_Table is array (Rotation) of Natural;
Column_Offset : constant Offset_Table := [0, 80, 0, 0];
Row_Offset    : constant Offset_Table := [80, 0, 0, 0];
