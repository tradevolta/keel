--  SPDX-License-Identifier: Apache-2.0
--  Keel.NMEA: checking and splitting NMEA 0183 sentences, the lines a
--  GPS receiver sends over its UART. A sentence is "$", an address
--  such as GPGGA, fields after commas, "*", two hex digits and CR LF,
--  at most 82 characters in all. The two digits are the XOR of every
--  character between "$" and "*". GNATprove proves Checksum against
--  that definition, and that Check says Valid only when it holds.
package Keel.NMEA
  with Pure, SPARK_Mode
is
   --  The longest sentence, "$" to LF
   Max_Length : constant := 82;

   type Byte is mod 2**8;

   --  The definition: every character XORed in, left to right
   function XOR_Of (S : String) return Byte is
     (if S'Length = 0 then 0
      else XOR_Of (S (S'First .. S'Last - 1))
           xor Byte (Character'Pos (S (S'Last))))
     with Ghost,
          Subprogram_Variant => (Decreases => S'Length);

   --  The same as a loop: what a parser runs
   function Checksum (S : String) return Byte
     with Post => Checksum'Result = XOR_Of (S);

   --  Two hex digits, upper or lower case ('0' is 48, 'A' 65, 'a' 97)
   function Is_Hex (C : Character) return Boolean is
     (C in '0' .. '9' | 'A' .. 'F' | 'a' .. 'f');
   function Hex_Value (C : Character) return Byte is
     (case C is
         when '0' .. '9' => Character'Pos (C) - 48,
         when 'A' .. 'F' => Character'Pos (C) - 65 + 10,
         when 'a' .. 'f' => Character'Pos (C) - 97 + 10,
         when others     => 0)
     with Pre => Is_Hex (C);

   type Verdict is
     (Valid, Too_Long, No_Dollar, No_Star, Bad_Hex, Mismatch);

   --  The line as received, with its CR LF already removed. Valid:
   --  it starts with "$", ends with "*" and two hex digits, and they
   --  are the checksum of what lies between.
   function Check (Line : String) return Verdict
     with Post =>
       (if Check'Result = Valid
        then Line'Length in 4 .. Max_Length - 2
             and then Line (Line'First) = '$'
             and then Line (Line'Last - 2) = '*'
             and then Is_Hex (Line (Line'Last - 1))
             and then Is_Hex (Line (Line'Last))
             and then Hex_Value (Line (Line'Last - 1)) * 16
                      + Hex_Value (Line (Line'Last))
                      = XOR_Of (Line (Line'First + 1
                                      .. Line'Last - 3)));

   --  Field N of a valid sentence: 0 is the address, 1 the first
   --  field after it. Found is False if there are fewer fields. An
   --  empty field gives Last = First - 1.
   procedure Field
     (Line : String; N : Natural; First, Last : out Natural;
      Found : out Boolean)
     with Pre  => Check (Line) = Valid,
          Post => (if Found
                   then First in Line'First + 1 .. Line'Last - 2
                        and then Last in First - 1 .. Line'Last - 3
                        and then (for all I in First .. Last =>
                                    Line (I) not in ',' | '*'));
end Keel.NMEA;
