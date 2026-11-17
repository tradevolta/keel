--  SPDX-License-Identifier: Apache-2.0
with Ada.Strings.Unbounded; use Ada.Strings.Unbounded;
with Keel.GPIO;             use Keel.GPIO;

package body Panel_Model is
   use type Keel.Bus.SPI.Device_Number;

   Panel  : Keel.Bus.SPI.Device_Number := 1;
   DC_Pin : Keel.GPIO.Fake.Pin_Id := 9;

   type Frame_Memory is array (0 .. 239, 0 .. 319) of Unsigned_16;
   RAM : Frame_Memory := [others => [others => 0]];

   Command   : Natural := 0;
   Params    : array (1 .. 4) of Natural := [others => 0];
   Got       : Natural := 0;
   Writing   : Boolean := False;
   High_Byte : Natural := 0;
   Have_High : Boolean := False;
   XS, XE    : Natural := 0;
   YS, YE    : Natural := 0;
   CX, CY    : Natural := 0;
   MADCTL    : Natural := 0;
   N_Hidden, N_Outside, N_Written : Natural := 0;
   Text      : Unbounded_String;
   Line      : Unbounded_String;

   function Hex2 (N : Natural) return String is
      D : constant String := "0123456789ABCDEF";
   begin
      return [D (N / 16 mod 16 + 1), D (N mod 16 + 1)];
   end Hex2;

   procedure Connect
     (Who : Keel.Bus.SPI.Device_Number; DC : Keel.GPIO.Fake.Pin_Id) is
   begin
      Panel := Who;
      DC_Pin := DC;
   end Connect;

   function Log return String is
     (To_String (Text) & To_String (Line)
      & (if Length (Line) > 0 then [ASCII.LF] else ""));

   procedure Clear_Log is
   begin
      Text := Null_Unbounded_String;
      Line := Null_Unbounded_String;
   end Clear_Log;

   --  The memory address of logical column C, row R (9.1.28): MV
   --  swaps them; MX mirrors the 240 columns, MY the 320 rows
   procedure Locate (C, R : Natural; X, Y : out Integer) is
      MY : constant Boolean := MADCTL / 16#80# mod 2 = 1;
      MX : constant Boolean := MADCTL / 16#40# mod 2 = 1;
      MV : constant Boolean := MADCTL / 16#20# mod 2 = 1;
      A  : constant Integer := (if MV then R else C);   --  column
      B  : constant Integer := (if MV then C else R);   --  row
   begin
      X := (if MX then 239 - A else A);
      Y := (if MY then 319 - B else B);
   end Locate;

   procedure Put_Pixel (V : Natural) is
      X, Y : Integer;
   begin
      Locate (CX, CY, X, Y);
      N_Written := N_Written + 1;
      if X not in 0 .. 239 or else Y not in 0 .. 319 then
         N_Outside := N_Outside + 1;
      else
         RAM (X, Y) := Unsigned_16 (V);
         if Y > 239 then
            N_Hidden := N_Hidden + 1;
         end if;
      end if;
      if CX < XE then
         CX := CX + 1;
      else
         CX := XS;
         CY := (if CY < YE then CY + 1 else YS);
      end if;
   end Put_Pixel;

   procedure End_Line is
   begin
      if Length (Line) > 0 then
         Append (Text, Line & ASCII.LF);
         Line := Null_Unbounded_String;
      end if;
   end End_Line;

   procedure Hear
     (Who : Keel.Bus.SPI.Device_Number; Frame : Natural;
      Bits : Positive) is
   begin
      if Who /= Panel then
         return;
      end if;
      if Keel.GPIO.Fake.Lamp (DC_Pin) = Low then
         --  A command
         End_Line;
         Command := Frame;
         Got := 0;
         Writing := Frame = 16#2C#;
         Have_High := False;
         if Writing then
            CX := XS;
            CY := YS;
         end if;
         Line := To_Unbounded_String (Hex2 (Frame));
         return;
      end if;

      --  Data: a parameter, or pixels after RAMWR
      Got := Got + 1;
      if Got <= 4 then
         Append (Line, " " & (if Bits = 16 then Hex2 (Frame / 256)
                               & Hex2 (Frame) else Hex2 (Frame)));
      elsif Got = 5 then
         Append (Line, " ...");
      end if;
      if Writing then
         if Bits = 16 then
            Put_Pixel (Frame);
         elsif Have_High then
            Put_Pixel (High_Byte * 256 + Frame);
            Have_High := False;
         else
            High_Byte := Frame;
            Have_High := True;
         end if;
      elsif Got <= 4 then
         Params (Got) := Frame;
         if Got = 4 and then Command = 16#2A# then
            XS := Params (1) * 256 + Params (2);
            XE := Params (3) * 256 + Params (4);
         elsif Got = 4 and then Command = 16#2B# then
            YS := Params (1) * 256 + Params (2);
            YE := Params (3) * 256 + Params (4);
         elsif Got = 1 and then Command = 16#36# then
            MADCTL := Frame;
         end if;
      end if;
   end Hear;

   function Memory (X : Natural; Y : Natural) return Unsigned_16 is
     (RAM (X, Y));
   function Hidden return Natural is (N_Hidden);
   function Outside return Natural is (N_Outside);
   function Pixels_Written return Natural is (N_Written);

   function View (X, Y, Column_Offset, Row_Offset : Natural)
     return Unsigned_16
   is
      MX, MY : Integer;
   begin
      Locate (X + Column_Offset, Y + Row_Offset, MX, MY);
      return RAM (MX, MY);
   end View;
end Panel_Model;
