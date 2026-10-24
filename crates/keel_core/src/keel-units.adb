--  SPDX-License-Identifier: Apache-2.0
package body Keel.Units is

   --  A unit name, padded with spaces, and the power of ten that turns
   --  one of it into a count of the type's Small.
   type Unit is record
      Name  : Wide_Wide_String (1 .. 3);
      Power : Natural;
   end record;
   type Unit_Table is array (Positive range <>) of Unit;

   Hertz_Units : constant Unit_Table :=
     [("Hz ", 0), ("kHz", 3), ("MHz", 6), ("GHz", 9)];
   Time_Units  : constant Unit_Table :=
     [("us ", 0), ("ms ", 3), ("s  ", 6)];
   Volt_Units  : constant Unit_Table := [("mV ", 0), ("V  ", 3)];
   Deg_Units   : constant Unit_Table := [1 => ("C  ", 2)];

   Max_Digits : constant := 15;
   type Count is range -10**18 .. 10**18;

   --  Read S as a count of Smalls. OK is False for a malformed
   --  literal, an unknown unit or a value finer than the Small.
   procedure Parse
     (S     : Wide_Wide_String;
      Units : Unit_Table;
      Value : out Count;
      OK    : out Boolean)
   is
      I         : Natural := S'First;
      Mantissa  : Count := 0;
      Digit_N   : Natural := 0;
      Frac_N    : Natural := 0;
      In_Frac   : Boolean := False;
      Negative  : Boolean := False;
      Last_Was  : Wide_Wide_Character := ' ';
   begin
      Value := 0;
      OK := False;
      if I <= S'Last and then S (I) = '-' then
         Negative := True;
         I := I + 1;
      end if;
      while I <= S'Last and then S (I) /= ' ' loop
         case S (I) is
            when '0' .. '9' =>
               if Digit_N = Max_Digits then
                  return;
               end if;
               Mantissa := Mantissa * 10
                 + Count (Wide_Wide_Character'Pos (S (I))
                          - Wide_Wide_Character'Pos ('0'));
               Digit_N := Digit_N + 1;
               if In_Frac then
                  Frac_N := Frac_N + 1;
               end if;
            when '_' =>
               if Last_Was not in '0' .. '9' then
                  return;
               end if;
            when '.' =>
               if In_Frac or else Last_Was not in '0' .. '9' then
                  return;
               end if;
               In_Frac := True;
            when others =>
               return;
         end case;
         Last_Was := S (I);
         I := I + 1;
      end loop;
      --  The number must end in a digit and be followed by one space.
      if Last_Was not in '0' .. '9' or else I >= S'Last then
         return;
      end if;
      declare
         Name : constant Wide_Wide_String := S (I + 1 .. S'Last);
      begin
         for U of Units loop
            if Name'Length <= 3
              and then U.Name (1 .. Name'Length) = Name
              and then (Name'Length = 3
                        or else U.Name (Name'Length + 1) = ' ')
            then
               if Frac_N > U.Power then
                  --  Finer than the Small, unless the extra digits
                  --  are zeros.
                  for K in 1 .. Frac_N - U.Power loop
                     if Mantissa mod 10 /= 0 then
                        return;
                     end if;
                     Mantissa := Mantissa / 10;
                  end loop;
               else
                  for K in 1 .. U.Power - Frac_N loop
                     Mantissa := Mantissa * 10;
                  end loop;
               end if;
               Value := (if Negative then -Mantissa else Mantissa);
               OK := True;
               return;
            end if;
         end loop;
      end;
   end Parse;

   --  Smalls of each type, as counts
   Hertz_Max   : constant Count := 10**9;
   Time_Max    : constant Count := 2**31 - 1;
   Volts_Max   : constant Count := 100_000;
   Celsius_Min : constant Count := -27_315;
   Celsius_Max : constant Count := 100_000;

   function Read (S : Wide_Wide_String; Units : Unit_Table;
                  Lo, Hi : Count) return Count
   is
      V  : Count;
      OK : Boolean;
   begin
      Parse (S, Units, V, OK);
      if not OK or else V not in Lo .. Hi then
         raise Constraint_Error with "bad unit literal";
      end if;
      return V;
   end Read;

   function Valid (S : Wide_Wide_String; Units : Unit_Table;
                   Lo, Hi : Count) return Boolean
   is
      V  : Count;
      OK : Boolean;
   begin
      Parse (S, Units, V, OK);
      return OK and then V in Lo .. Hi;
   end Valid;

   function Is_Hertz (S : Wide_Wide_String) return Boolean is
     (Valid (S, Hertz_Units, 0, Hertz_Max));
   function Is_Micro_Seconds (S : Wide_Wide_String) return Boolean is
     (Valid (S, Time_Units, 0, Time_Max));
   function Is_Volts (S : Wide_Wide_String) return Boolean is
     (Valid (S, Volt_Units, -Volts_Max, Volts_Max));
   function Is_Celsius (S : Wide_Wide_String) return Boolean is
     (Valid (S, Deg_Units, Celsius_Min, Celsius_Max));

   --  A count of Smalls times the Small: fixed-point times Integer
   --  is exact, so "12 MHz" is exactly 12_000_000.0.
   function To_Hertz (S : Wide_Wide_String) return Hertz is
     (Hertz'(1.0) * Integer (Read (S, Hertz_Units, 0, Hertz_Max)));
   function To_Micro_Seconds (S : Wide_Wide_String) return Micro_Seconds
   is (Micro_Seconds'(1.0)
       * Integer (Read (S, Time_Units, 0, Time_Max)));
   function To_Volts (S : Wide_Wide_String) return Volts is
     (Volts'(0.001)
      * Integer (Read (S, Volt_Units, -Volts_Max, Volts_Max)));
   function To_Celsius (S : Wide_Wide_String) return Celsius is
     (Celsius'(0.01)
      * Integer (Read (S, Deg_Units, Celsius_Min, Celsius_Max)));

end Keel.Units;
