--  SPDX-License-Identifier: Apache-2.0
package body Keel.CLI.Words
  with SPARK_Mode
is
   procedure Split (Line : String; A : out Arguments) is
      Copy  : String (1 .. Max_Line) := [others => ' '];
      Words : Bounds_Array := [others => <>];
      N     : Word_Count := 0;
      More  : Boolean := False;
      I     : Positive := 1;
      First : Positive;
   begin
      --  Copy the line to 1 .. Line'Length; the rest stays spaces
      for K in Line'Range loop
         Copy (K - Line'First + 1) := Line (K);
      end loop;

      while I <= Max_Line loop
         pragma Loop_Invariant
           (for all W in 1 .. N =>
              Words (W).First <= Words (W).Last
              and then Words (W).Last < I
              and then (for all J in Words (W).First .. Words (W).Last
                        => Copy (J) /= ' '));
         if Copy (I) = ' ' then
            I := I + 1;
         else
            First := I;
            while I < Max_Line and then Copy (I + 1) /= ' ' loop
               pragma Loop_Invariant
                 (I in First .. Max_Line - 1
                  and then (for all J in First .. I => Copy (J) /= ' '));
               I := I + 1;
            end loop;
            if N < Max_Words then
               N := N + 1;
               Words (N) := (First => First, Last => I);
            else
               More := True;
            end if;
            I := I + 1;
         end if;
      end loop;
      A := (Line => Copy, Count => N, Words => Words, More => More);
   end Split;

   procedure To_Number (S : String; N : out Number; OK : out Boolean) is
      Negative : constant Boolean := S'Length > 0
        and then S (S'First) = '-';
      Skip     : constant Natural := (if Negative then 1 else 0);
      Value    : Natural := 0;
      Powers   : constant array (0 .. 9) of Natural :=
        [1, 10, 100, 1_000, 10_000, 100_000, 1_000_000, 10_000_000,
         100_000_000, 1_000_000_000];
   begin
      N := 0;
      OK := S'Length > Skip and then S'Length - Skip <= 9;
      if not OK then
         return;
      end if;
      for K in Skip .. S'Length - 1 loop
         pragma Loop_Invariant (Value < Powers (K - Skip));
         if S (S'First + K) not in '0' .. '9' then
            OK := False;
            return;
         end if;
         --  '0' is 48
         Value := Value * 10 + (Character'Pos (S (S'First + K)) - 48);
      end loop;
      N := (if Negative then -Value else Value);
   end To_Number;
end Keel.CLI.Words;
