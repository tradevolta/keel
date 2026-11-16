--  SPDX-License-Identifier: Apache-2.0
package body Keel.AT_Replies
  with SPARK_Mode
is
   function Classify (Line : String; Command : String) return Kind is
   begin
      if Line'Length = 0 then
         return Blank;
      elsif Line = "OK" then
         return Ok;
      elsif Line = "ERROR" then
         return Error;
      elsif Has_Error_Code (Line) then
         return Error_Code;
      elsif Answers (Line, Command) then
         return Information;
      elsif Line (Line'First) = '+' then
         return Unsolicited;
      elsif Line (Line'First) = '>' then
         return Prompt;
      elsif Starts_With (Line, "AT") or else Starts_With (Line, "at")
      then
         return Echo;
      else
         return Text;
      end if;
   end Classify;

   procedure Error_Number
     (Line : String; N : out Natural; Found : out Boolean)
   is
      --  K counts characters from the start: skip the 11 of
      --  "+CME ERROR:", then spaces, then take up to six digits
      K     : Natural := 11;
      Count : Natural := 0;
   begin
      N := 0;
      Found := False;
      while K < Line'Length and then Line (Line'First + K) = ' ' loop
         pragma Loop_Invariant (K in 11 .. Line'Length - 1);
         pragma Loop_Variant (Increases => K);
         K := K + 1;
      end loop;
      while K < Line'Length
        and then Line (Line'First + K) in '0' .. '9'
      loop
         pragma Loop_Invariant (Count <= 6 and then N < 10**Count);
         pragma Loop_Invariant (K < Line'Length);
         pragma Loop_Variant (Increases => K);
         if Count = 6 then
            return;
         end if;
         N := N * 10 + (Character'Pos (Line (Line'First + K)) - 48);
         Count := Count + 1;
         K := K + 1;
      end loop;
      Found := Count > 0 and then K = Line'Length;
   end Error_Number;
end Keel.AT_Replies;
