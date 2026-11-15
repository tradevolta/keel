--  SPDX-License-Identifier: Apache-2.0
package body Model_Bus
  with SPARK_Mode => Off
is
   procedure Reset
     (B : in out Bus; Present : out Boolean; Stat : out Status) is
   begin
      Present := False;
      Stat := No_Device;
   end Reset;

   procedure Touch
     (B : in out Bus; Bit : Boolean; Got : out Boolean;
      Stat : out Status) is
   begin
      Got := Bit;
      Stat := Ok;
   end Touch;

   procedure Put
     (B : in out Bus; Pixel : Pixel_Bits; Stat : out Keel.Status) is
   begin
      Stat := Keel.Ok;
   end Put;

   procedure Latch (B : in out Bus; Stat : out Keel.Status) is
   begin
      Stat := Keel.Ok;
   end Latch;
end Model_Bus;
