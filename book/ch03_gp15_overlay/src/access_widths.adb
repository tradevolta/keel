--  SPDX-License-Identifier: Apache-2.0
package body Access_Widths is

   procedure Field_Loose (R : in out Loose_Ctrl) is
   begin
      R.Funcsel := SIO;
   end Field_Loose;

   procedure Field_Full (R : in out GPIO_Ctrl) is
   begin
      R.Funcsel := SIO;
   end Field_Full;

   procedure Whole_Write (R : out GPIO_Ctrl) is
   begin
      R := (Funcsel => SIO, others => <>);
   end Whole_Write;

end Access_Widths;
