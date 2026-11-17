--  SPDX-License-Identifier: Apache-2.0
--  Keel.Drivers.ST7789: the Sitronix ST7789 TFT controller, as on
--  Adafruit's 1.3-inch 240 x 240 display, through its 4-line serial
--  interface: SCL, SDA, CSX and a D/CX pin that says whether a byte
--  is a command (low) or data (high). The controller's RAM is 240
--  columns by 320 rows; the panel shows 240 x 240 of it, which is
--  why some rotations start 80 rows or columns in. Pixels are RGB565
--  sent most significant byte first, so one 16-bit SPI frame is one
--  pixel and the DMA sends a buffer of them as it is.
with Interfaces;
with Keel.Bus.SPI;
with Keel.DMA;
with Keel.GPIO.Output_Signature;
with Keel.Time;

generic
   with package Link is new Keel.Bus.SPI.Device_Signature (<>);
   with package Pins is new Keel.GPIO.Output_Signature (<>);
   with package Timer is new Keel.Time.Clock_Signature (<>);
package Keel.Drivers.ST7789
  with SPARK_Mode
is
   Width  : constant := 240;
   Height : constant := 240;

   subtype Pixel is Interfaces.Unsigned_16;

   --  Commands, from the datasheet's section 9.1
   SWRESET : constant := 16#01#;  --  software reset
   SLPOUT  : constant := 16#11#;  --  sleep out
   NORON   : constant := 16#13#;  --  normal display mode on
   INVON   : constant := 16#21#;  --  display inversion on
   DISPON  : constant := 16#29#;  --  display on
   CASET   : constant := 16#2A#;  --  column address set
   RASET   : constant := 16#2B#;  --  row address set
   RAMWR   : constant := 16#2C#;  --  memory write
   MADCTL  : constant := 16#36#;  --  memory data access control
   COLMOD  : constant := 16#3A#;  --  interface pixel format

   --  COLMOD 55h: 65K colors on the RGB interface, 16 bits a pixel
   --  on the serial one (9.1.32)
   RGB565_Format : constant := 16#55#;

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

   --  A rectangle of the screen, in the rotated coordinates
   subtype Column is Natural range 0 .. Width - 1;
   subtype Row is Natural range 0 .. Height - 1;
   type Window is record
      X      : Column := 0;
      Y      : Row := 0;
      Across : Positive range 1 .. Width := Width;
      Down   : Positive range 1 .. Height := Height;
   end record
     with Predicate => X + Across <= Width and then Y + Down <= Height;

   function Pixels (W : Window) return Positive is (W.Across * W.Down)
     with Post => Pixels'Result <= Width * Height;

   --  The RAM addresses CASET and RASET get for W: first and last.
   --  They stay inside the RAM: 240 columns by 320 rows, or 320 by
   --  240 when MV swaps them.
   subtype RAM_Address is Natural range 0 .. 319;
   function First_Column (W : Window; T : Rotation) return RAM_Address
   is (W.X + Column_Offset (T));
   function Last_Column (W : Window; T : Rotation) return RAM_Address
   is (W.X + W.Across - 1 + Column_Offset (T));
   function First_Row (W : Window; T : Rotation) return RAM_Address
   is (W.Y + Row_Offset (T));
   function Last_Row (W : Window; T : Rotation) return RAM_Address
   is (W.Y + W.Down - 1 + Row_Offset (T));

   type Panel is limited private
     with Default_Initial_Condition =>
       not Ready (Panel) and then not Streaming (Panel);

   --  Initialize has run
   function Ready (P : Panel) return Boolean;
   --  A window's pixels are on their way: the panel holds the bus
   function Streaming (P : Panel) return Boolean;
   function Turn (P : Panel) return Rotation;

   --  Hold RST low for 1 ms, at least the 10 us the datasheet asks
   --  (7.4.5), then let the controller come out of reset: 120 ms
   procedure Reset (RST : in out Pins.Pin);

   --  Wake the controller and set it up: SWRESET, SLPOUT, COLMOD 55h,
   --  MADCTL for T, INVON (this panel is an IPS one), NORON, DISPON.
   --  The bus is held for each command only, not across the pauses.
   procedure Initialize
     (P    : in out Panel;
      D    : in out Link.Device;
      DC   : in out Pins.Pin;
      T    : Rotation;
      Stat : out Status)
     with Pre  => not Streaming (P),
          Post => not Streaming (P)
                  and then (if Stat = Ok
                            then Ready (P) and then Turn (P) = T);

   --  W in one color, sent by the processor
   procedure Fill
     (P    : in out Panel;
      D    : in out Link.Device;
      DC   : in out Pins.Pin;
      W    : Window;
      Ink  : Pixel;
      Stat : out Status)
     with Pre  => Ready (P) and then not Streaming (P),
          Post => Turn (P) = Turn (P)'Old
                  and then Ready (P) and then not Streaming (P);

   --  Take the bus, set the window to W and start the DMA sending
   --  its pixels, row by row, from From. Returns at once; the
   --  program draws elsewhere while they go, then calls
   --  Finish_Window.
   procedure Start_Window
     (P    : in out Panel;
      D    : in out Link.Device;
      DC   : in out Pins.Pin;
      W    : Window;
      From : Keel.DMA.Region;
      Stat : out Status)
     with Pre  => Ready (P) and then not Streaming (P)
                  and then not Keel.DMA.Is_Register (From)
                  and then Keel.DMA.Length (From) >= 2 * Pixels (W),
          Post => Turn (P) = Turn (P)'Old
                  and then Ready (P) and then Streaming (P) = (Stat = Ok);

   --  Wait for the last pixel to leave and give the bus back. Done
   --  is the receipt for From, to reclaim the buffer with.
   procedure Finish_Window
     (P    : in out Panel;
      D    : in out Link.Device;
      Done : out Keel.DMA.Receipt)
     with Pre  => Ready (P) and then Streaming (P),
          Post => Turn (P) = Turn (P)'Old
                  and then Ready (P) and then not Streaming (P);
private
   type Panel is limited record
      Is_Ready : Boolean := False;
      Busy     : Boolean := False;
      Rotated  : Rotation := 0;
   end record;

   function Ready (P : Panel) return Boolean is (P.Is_Ready);
   function Streaming (P : Panel) return Boolean is (P.Busy);
   function Turn (P : Panel) return Rotation is (P.Rotated);
end Keel.Drivers.ST7789;
