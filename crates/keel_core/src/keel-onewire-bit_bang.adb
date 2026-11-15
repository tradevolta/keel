--  SPDX-License-Identifier: Apache-2.0
package body Keel.OneWire.Bit_Bang is
   use type Keel.GPIO.Level;

   --  AN126, Table 2: standard speed, in microseconds
   A : constant := 6;
   C : constant := 60;
   D : constant := 10;
   E : constant := 9;
   F : constant := 55;
   H : constant := 480;
   I : constant := 70;
   J : constant := 410;

   procedure Reset
     (L : in out Line; Present : out Boolean; Stat : out Status) is
   begin
      Set (L, Keel.GPIO.Low);
      Wait_Us (H);
      Hold;
      Set (L, Keel.GPIO.High);
      Wait_Us (I);
      Present := Sense (L) = Keel.GPIO.Low;
      Let_Go;
      Wait_Us (J);
      Stat := Ok;
   end Reset;

   procedure Touch
     (L : in out Line; Bit : Boolean; Got : out Boolean;
      Stat : out Status) is
   begin
      Hold;
      Set (L, Keel.GPIO.Low);
      if Bit then
         Wait_Us (A);
         Set (L, Keel.GPIO.High);
         Wait_Us (E);
         Got := Sense (L) = Keel.GPIO.High;
         Let_Go;
         Wait_Us (F);
      else
         Wait_Us (C);
         Set (L, Keel.GPIO.High);
         Let_Go;
         Got := False;
         Wait_Us (D);
      end if;
      Stat := Ok;
   end Touch;
end Keel.OneWire.Bit_Bang;
