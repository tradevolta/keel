--  SPDX-License-Identifier: Apache-2.0
--  Chapter 3, part 1: types, arrays, records, loops, case, contracts.
with Ada.Text_IO;    use Ada.Text_IO;
with Units;          use Units;
with Moving_Average; use Moving_Average;

procedure Basics is
   type Gain is range 1 .. 8;
   Gains : constant array (Channel) of Gain :=
     [Temp_Sensor => 1, others => 4];

   type Reading is record
      Source : Channel;
      Value  : Milli_Volts;
   end record;

   Samples : constant array (1 .. 5) of Milli_Volts :=
     [1_000, 1_100, 1_200, 1_300, 1_400];
   Last : Reading;
   W    : Window;
   B    : Byte := Byte'Last;
   T    : constant Celsius := 21.5;
begin
   for C in Channel loop
      Put_Line (C'Image & " gain" & Gains (C)'Image);
   end loop;

   B := B + 1;
   Put_Line ("Byte'Last + 1 =" & B'Image & ", T =" & T'Image);
   Put_Line ("Milli_Volts'Size =" & Milli_Volts'Size'Image
             & ", 'Object_Size =" & Milli_Volts'Object_Size'Image);
   Reset (W);
   for I in Samples'Range loop       --  1 .. 5
      Add (W, Samples (I));
   end loop;
   Last := (Source => AIN1, Value => Mean (W));

   case Last.Source is
      when AIN0 .. AIN3 =>
         Put_Line (Last.Source'Image & " mean" & Last.Value'Image);
      when Temp_Sensor  => Put_Line ("on-chip sensor");
   end case;
   Reset (W);
   Put_Line ("mean of nothing:" & Mean (W)'Image);
end Basics;
