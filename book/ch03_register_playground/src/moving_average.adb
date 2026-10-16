--  SPDX-License-Identifier: Apache-2.0
package body Moving_Average is

   procedure Reset (W : out Window) is
   begin
      W := (others => <>);  --  every component's default
   end Reset;

   procedure Add (W : in out Window; Sample : Milli_Volts) is
   begin
      W.Samples (W.Next) := Sample;
      W.Next := W.Next + 1;  --  mod 4: 3 + 1 wraps to 0
      if W.Filled < Window_Length then
         W.Filled := W.Filled + 1;
      end if;
   end Add;

   function Count (W : Window) return Natural is (W.Filled);

   function Mean (W : Window) return Milli_Volts is
      Sum : Natural := 0;
   begin
      for I in 0 .. Index (W.Filled - 1) loop
         Sum := Sum + Natural (W.Samples (I));
      end loop;
      return Milli_Volts (Sum / W.Filled);
   end Mean;

end Moving_Average;
