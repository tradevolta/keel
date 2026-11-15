--  SPDX-License-Identifier: Apache-2.0
package body Keel.OneWire
  with SPARK_Mode
is
   function CRC8 (Data : Byte_Array) return Byte is
      CRC : Byte := 0;
   begin
      for I in Data'Range loop
         --  Eight steps of the definition, without the recursion
         declare
            B : Byte := Data (I);
         begin
            for N in reverse 1 .. 8 loop
               pragma Loop_Invariant
                 (Shift (CRC, B, N)
                  = Update (CRC'Loop_Entry, Data (I)));
               CRC := (if (CRC xor B) mod 2 = 1
                       then (CRC / 2) xor 16#8C#
                       else CRC / 2);
               B := B / 2;
            end loop;
         end;
         pragma Loop_Invariant
           (CRC = CRC8_Of (Data (Data'First .. I)));
      end loop;
      return CRC;
   end CRC8;
end Keel.OneWire;
