--  SPDX-License-Identifier: Apache-2.0
package body Keel.NMEA
  with SPARK_Mode
is
   function Checksum (S : String) return Byte is
      Sum : Byte := 0;
   begin
      for I in S'Range loop
         Sum := Sum xor Byte (Character'Pos (S (I)));
         pragma Loop_Invariant (Sum = XOR_Of (S (S'First .. I)));
      end loop;
      return Sum;
   end Checksum;

   function Check (Line : String) return Verdict is
   begin
      if Line'Length > Max_Length - 2 then
         return Too_Long;
      elsif Line'Length = 0 or else Line (Line'First) /= '$' then
         return No_Dollar;
      elsif Line'Length < 4 or else Line (Line'Last - 2) /= '*' then
         return No_Star;
      elsif not Is_Hex (Line (Line'Last - 1))
        or else not Is_Hex (Line (Line'Last))
      then
         return Bad_Hex;
      elsif Hex_Value (Line (Line'Last - 1)) * 16
              + Hex_Value (Line (Line'Last))
            /= Checksum (Line (Line'First + 1 .. Line'Last - 3))
      then
         return Mismatch;
      else
         return Valid;
      end if;
   end Check;

   procedure Field
     (Line : String; N : Natural; First, Last : out Natural;
      Found : out Boolean)
   is
      --  The fields lie between "$" and "*"
      Stop  : constant Positive := Line'Last - 2;
      Count : Natural := 0;
      I     : Positive := Line'First + 1;
   begin
      First := I;
      Last := I - 1;
      Found := False;
      while I <= Stop loop
         pragma Loop_Invariant (I in Line'First + 1 .. Stop);
         pragma Loop_Invariant (First in Line'First + 1 .. I);
         pragma Loop_Invariant (Count <= N);
         pragma Loop_Invariant
           (for all J in First .. I - 1 => Line (J) not in ',' | '*');
         pragma Loop_Variant (Increases => I);
         if Line (I) in ',' | '*' then
            if Count = N then
               Last := I - 1;
               Found := True;
               return;
            end if;
            Count := Count + 1;
            First := I + 1;
         end if;
         I := I + 1;
      end loop;
   end Field;
end Keel.NMEA;
