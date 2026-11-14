--  SPDX-License-Identifier: Apache-2.0
package body Readings is

   procedure Split
     (Inputs : Channel_Set; Samples : Sample_Array;
      Total : out Sums; Each : out Natural)
   is
      Order : array (1 .. 5) of Channel := [others => 0];
      N     : Natural := 0;
   begin
      for Ch in Channel loop
         if Inputs (Ch) then
            N := N + 1;
            Order (N) := Ch;
         end if;
      end loop;
      Total := [others => 0];
      Each := (if N = 0 then 0 else Samples'Length / N);
      for I in 1 .. Each * N loop
         Total (Order ((I - 1) mod N + 1)) :=
           Total (Order ((I - 1) mod N + 1)) + Samples (I);
      end loop;
   end Split;

   function Measure (Samples : Sample_Array; Rate : Hertz) return Wave
   is
      W     : Wave;
      Sum   : Long_Long_Integer := 0;
      Mid, Band : Integer;
      Below : Boolean := False;
      First, Last : Natural := 0;
   begin
      W.Low := Code'Last;
      for S of Samples loop
         W.Low := Code'Min (W.Low, S);
         W.High := Code'Max (W.High, S);
         Sum := Sum + Long_Long_Integer (S);
      end loop;
      W.Mean := Code (Sum / Long_Long_Integer (Samples'Length));

      --  A rise: below the middle by an eighth of the range, then
      --  above it by as much, so noise near the middle doesn't count
      Mid := (W.Low + W.High) / 2;
      Band := (W.High - W.Low) / 8;
      for I in Samples'Range loop
         if Samples (I) < Mid - Band then
            Below := True;
         elsif Below and then Samples (I) > Mid + Band then
            Below := False;
            W.Rises := W.Rises + 1;
            if First = 0 then
               First := I;
            end if;
            Last := I;
         end if;
      end loop;

      if W.Rises >= 2 and then Last > First then
         W.Frequency :=
           Hertz (Long_Long_Integer (W.Rises - 1)
                  * Long_Long_Integer (Rate)
                  / Long_Long_Integer (Last - First));
      end if;
      return W;
   end Measure;
end Readings;
