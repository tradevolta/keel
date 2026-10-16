--  SPDX-License-Identifier: Apache-2.0
--  Three ways to write one field. Compiled, never called: read the
--  machine code with arm-eabi-objdump (Section 3.8).
with RP2350.IO_Bank0; use RP2350.IO_Bank0;

package Access_Widths is

   --  Like GPIO_Ctrl, but only Volatile: no Volatile_Full_Access.
   type Loose_Ctrl is record
      Funcsel : Function_Select;
      Outover : Override;
   end record
     with Size => 32, Volatile;

   for Loose_Ctrl use record
      Funcsel at 0 range  0 ..  4;
      Outover at 0 range 12 .. 13;
   end record;

   procedure Field_Loose (R : in out Loose_Ctrl);  --  Funcsel := SIO
   procedure Field_Full  (R : in out GPIO_Ctrl);   --  Funcsel := SIO
   procedure Whole_Write (R : out GPIO_Ctrl);      --  R := (SIO, ...)

end Access_Widths;
