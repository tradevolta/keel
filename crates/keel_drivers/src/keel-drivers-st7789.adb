--  SPDX-License-Identifier: Apache-2.0
package body Keel.Drivers.ST7789
  with SPARK_Mode
is
   use Keel.Bus.SPI;
   use type Keel.Time.Time;
   use type Interfaces.Unsigned_16;

   procedure Pause (Milliseconds : Natural) is
      Now : constant Keel.Time.Time :=
        Keel.Time.Time'Min (Timer.Clock, Keel.Time.Max_Clock);
   begin
      Timer.Wait_Until
        (Now + Keel.Time.Milliseconds (Milliseconds));
   end Pause;

   procedure Reset (RST : in out Pins.Pin) is
   begin
      Pins.Set (RST, Keel.GPIO.Low);
      Pause (1);
      Pins.Set (RST, Keel.GPIO.High);
      Pause (120);
   end Reset;

   None : constant Byte_Array (1 .. 0) := [others => 0];

   --  With the bus held: Cmd with D/CX low, then its parameters with
   --  D/CX high
   procedure Send
     (D      : in out Link.Device;
      DC     : in out Pins.Pin;
      Cmd    : Byte;
      Params : Byte_Array := None)
   is
      Code : constant Byte_Array (1 .. 1) := [1 => Cmd];
   begin
      Pins.Set (DC, Keel.GPIO.Low);
      Link.Write (D, Code);
      if Params'Length > 0 then
         Pins.Set (DC, Keel.GPIO.High);
         Link.Write (D, Params);
      end if;
   end Send;

   --  One command on its own: take the bus, send, give it back
   procedure Command
     (D      : in out Link.Device;
      DC     : in out Pins.Pin;
      Cmd    : Byte;
      Params : Byte_Array;
      Stat   : out Status)
   is
   begin
      Link.Acquire (D, Stat);
      if Stat = Ok then
         Send (D, DC, Cmd, Params);
         Link.Release (D);
      end if;
   end Command;

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
         Param : Integer range -1 .. 255;  --  -1: none
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
         if S.Param < 0 then
            Command (D, DC, S.Cmd, None, Stat);
         else
            Command
              (D, DC, S.Cmd, Byte_Array'[1 => Byte (S.Param)], Stat);
         end if;
         if Stat /= Ok then
            return;
         end if;
         Pause (S.Wait);
      end loop;
      P.Rotated := T;
      P.Is_Ready := True;
      Stat := Ok;
   end Initialize;

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
      Send (D, DC, RAMWR);
      Pins.Set (DC, Keel.GPIO.High);
   end Open_Window;

   procedure Fill
     (P    : in out Panel;
      D    : in out Link.Device;
      DC   : in out Pins.Pin;
      W    : Window;
      Ink  : Pixel;
      Stat : out Status)
   is
      Run   : constant := 32;
      Chunk : constant Byte_Array (1 .. 2 * Run) :=
        [for I in 1 .. 2 * Run =>
           (if I mod 2 = 1 then Byte (Ink / 256) else Byte (Ink mod 256))];
      Left  : Natural := Pixels (W);
   begin
      Link.Acquire (D, Stat);
      if Stat /= Ok then
         return;
      end if;
      Open_Window (D, DC, W, P.Rotated);
      while Left > 0 loop
         pragma Loop_Variant (Decreases => Left);
         if Left >= Run then
            Link.Write (D, Chunk);
            Left := Left - Run;
         else
            Link.Write (D, Chunk (1 .. 2 * Left));
            Left := 0;
         end if;
      end loop;
      Link.Release (D);
   end Fill;

   procedure Start_Window
     (P    : in out Panel;
      D    : in out Link.Device;
      DC   : in out Pins.Pin;
      W    : Window;
      From : Keel.DMA.Region;
      Stat : out Status)
   is
   begin
      Link.Acquire (D, Stat);
      if Stat /= Ok then
         return;
      end if;
      Open_Window (D, DC, W, P.Rotated);
      Link.Start_Stream (D, From, Pixels (W), Stat);
      if Stat = Ok then
         P.Busy := True;
      else
         Link.Release (D);
      end if;
   end Start_Window;

   procedure Finish_Window
     (P    : in out Panel;
      D    : in out Link.Device;
      Done : out Keel.DMA.Receipt)
   is
   begin
      Link.Finish_Stream (D, Done);
      Link.Release (D);
      P.Busy := False;
   end Finish_Window;
end Keel.Drivers.ST7789;
