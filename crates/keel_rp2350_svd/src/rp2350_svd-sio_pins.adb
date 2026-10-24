--  SPDX-License-Identifier: Apache-2.0
with Ada.Unchecked_Conversion;
with RP2350_SVD.SIO; use RP2350_SVD.SIO;

package body RP2350_SVD.SIO_Pins is

   --  The only place a pin set becomes a number: the generated
   --  registers are UInt32.
   function To_UInt32 is new Ada.Unchecked_Conversion (Pin_Set, UInt32);
   function To_Pins is new Ada.Unchecked_Conversion (UInt32, Pin_Set);

   procedure Output_Set (Pins : Pin_Set) is
   begin
      SIO_Periph.GPIO_OUT_SET := To_UInt32 (Pins);
   end Output_Set;

   procedure Output_Clear (Pins : Pin_Set) is
   begin
      SIO_Periph.GPIO_OUT_CLR := To_UInt32 (Pins);
   end Output_Clear;

   procedure Output_Toggle (Pins : Pin_Set) is
   begin
      SIO_Periph.GPIO_OUT_XOR := To_UInt32 (Pins);
   end Output_Toggle;

   procedure Enable_Output (Pins : Pin_Set) is
   begin
      SIO_Periph.GPIO_OE_SET := To_UInt32 (Pins);
   end Enable_Output;

   procedure Disable_Output (Pins : Pin_Set) is
   begin
      SIO_Periph.GPIO_OE_CLR := To_UInt32 (Pins);
   end Disable_Output;

   function Output return Pin_Set is (To_Pins (SIO_Periph.GPIO_OUT));
   function Input return Pin_Set is (To_Pins (SIO_Periph.GPIO_IN));
end RP2350_SVD.SIO_Pins;
