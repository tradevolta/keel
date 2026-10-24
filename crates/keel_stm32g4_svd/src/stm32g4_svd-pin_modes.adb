--  SPDX-License-Identifier: Apache-2.0
with Ada.Unchecked_Conversion;

package body STM32G4_SVD.Pin_Modes is

   function To_Mode is new Ada.Unchecked_Conversion (UInt2, Mode);
   function To_Bits is new Ada.Unchecked_Conversion (Mode, UInt2);

   procedure Set_Mode
     (Port : in out GPIO_Peripheral; P : Pin; To : Mode)
   is
      R : MODER_Register := Port.MODER;
   begin
      R.Arr (Integer (P)) := To_Bits (To);
      Port.MODER := R;
   end Set_Mode;

   function Mode_Of (Port : GPIO_Peripheral; P : Pin) return Mode is
     (To_Mode (Port.MODER.Arr (Integer (P))));
end STM32G4_SVD.Pin_Modes;
