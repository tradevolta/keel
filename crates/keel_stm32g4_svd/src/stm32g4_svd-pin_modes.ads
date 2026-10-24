--  SPDX-License-Identifier: Apache-2.0
--  Hand-written (not generated): a typed MODER. The STM32G474 SVD
--  gives the GPIO mode field no enumerated values, so svd2ada makes
--  each pin's mode a bare UInt2. RM0440 (GPIOx_MODER) gives the
--  encoding used here.
with STM32G4_SVD.GPIO; use STM32G4_SVD.GPIO;

package STM32G4_SVD.Pin_Modes
  with Preelaborate
is
   type Pin is range 0 .. 15;

   type Mode is (Input, Output, Alternate, Analog)
     with Size => 2;
   for Mode use (Input => 2#00#, Output => 2#01#,
                 Alternate => 2#10#, Analog => 2#11#);

   --  Change the mode of one pin of Port, in one read and one write
   --  of MODER. Analog is the reset mode of most pins.
   procedure Set_Mode
     (Port : in out GPIO_Peripheral; P : Pin; To : Mode)
     with Inline;

   function Mode_Of (Port : GPIO_Peripheral; P : Pin) return Mode
     with Inline;
end STM32G4_SVD.Pin_Modes;
