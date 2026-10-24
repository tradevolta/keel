--  SPDX-License-Identifier: Apache-2.0
--  Hand-written (not generated): a typed view of the SIO GPIO
--  registers. svd2ada declares GPIO_OUT_SET and its siblings as plain
--  UInt32, because the SVD gives them one 32-bit field. Here a pin
--  set is an array of Booleans indexed by pin, and nothing else
--  converts to it.
package RP2350_SVD.SIO_Pins
  with Preelaborate
is
   --  GPIO0 .. GPIO31, the pins the low SIO registers control
   type Pin is range 0 .. 31;

   type Pin_Set is array (Pin) of Boolean
     with Component_Size => 1, Size => 32;

   No_Pins : constant Pin_Set := [others => False];

   --  Each procedure is one store to the SIO register of the same
   --  name: only the pins in Pins change.
   procedure Output_Set (Pins : Pin_Set)
     with Inline;  --  GPIO_OUT_SET
   procedure Output_Clear (Pins : Pin_Set)
     with Inline;  --  GPIO_OUT_CLR
   procedure Output_Toggle (Pins : Pin_Set)
     with Inline;  --  GPIO_OUT_XOR
   procedure Enable_Output (Pins : Pin_Set)
     with Inline;  --  GPIO_OE_SET
   procedure Disable_Output (Pins : Pin_Set)
     with Inline;  --  GPIO_OE_CLR

   function Output return Pin_Set
     with Inline;  --  GPIO_OUT
   function Input return Pin_Set
     with Inline;  --  GPIO_IN
end RP2350_SVD.SIO_Pins;
