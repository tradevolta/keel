--  SPDX-License-Identifier: Apache-2.0
package body Keel.Log
  with SPARK_Mode
is
   function Label (L : Level) return String is
     (case L is
         when Debug => "DEBUG",
         when Info  => "INFO ",
         when Warn  => "WARN ",
         when Error => "ERROR");

   --  N's last Width digits, right-aligned in spaces, or in zeros
   function Decimal
     (N : Natural; Width : Positive; Zeros : Boolean) return String
     with Pre  => Width <= 10,
          Post => Decimal'Result'Length = Width
                  and then Decimal'Result'First = 1
   is
      Result : String (1 .. Width) := [others => (if Zeros then '0'
                                                  else ' ')];
      V      : Natural := N;
   begin
      for K in reverse 1 .. Width loop
         --  '0' is 48
         Result (K) := Character'Val (48 + V mod 10);
         V := V / 10;
         exit when V = 0 and then not Zeros;
      end loop;
      return Result;
   end Decimal;

   function Stamp (Ms : Natural) return String is
     ("[" & Decimal ((Ms / 1000) mod 10_000_000, 7, False) & "."
      & Decimal (Ms mod 1000, 3, True) & "]");

   function Line (Ms : Natural; L : Level; Message : String)
     return String
   is (Stamp (Ms) & " " & Label (L) & " " & Message
       & Character'Val (13) & Character'Val (10));
end Keel.Log;
