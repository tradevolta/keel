--  SPDX-License-Identifier: Apache-2.0
package body Keel.GPIO.Debounce
  with SPARK_Mode
is
   procedure Reset (D : in out Debouncer; To : Level) is
   begin
      D.Now := To;
      D.Count := 0;
   end Reset;

   procedure Sample
     (D : in out Debouncer; Raw : Level; Changed : out Boolean)
   is
   begin
      Changed := False;
      if Raw = D.Now then
         D.Count := 0;              --  agrees: start counting again
      elsif D.Count + 1 = D.Samples then
         D.Now := Raw;              --  the last disagreeing sample
         D.Count := 0;
         Changed := True;
      else
         D.Count := D.Count + 1;
      end if;
   end Sample;
end Keel.GPIO.Debounce;
