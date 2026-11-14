--  SPDX-License-Identifier: Apache-2.0
--  Hand-written (not generated): the PWM slices as an array. The
--  generated code gives each slice's five registers their own types
--  (CH0_CSR ... CH11_TOP), but every slice has CH0's layout, 20
--  bytes apart from 0x400A_8000 (RP2350 datasheet, 12.5.3), so
--  CH0's types describe any slice.
with RP2350_SVD.PWM; use RP2350_SVD.PWM;

package RP2350_SVD.PWM_Slices
  with Preelaborate
is
   type Slice is range 0 .. 11;

   type Slice_Registers is record
      CSR : CH0_CSR_Register;
      DIV : CH0_DIV_Register;
      CTR : CH0_CTR_Register;
      CC  : CH0_CC_Register;
      TOP : CH0_TOP_Register;
   end record;

   for Slice_Registers use record
      CSR at 16#00# range 0 .. 31;
      DIV at 16#04# range 0 .. 31;
      CTR at 16#08# range 0 .. 31;
      CC  at 16#0C# range 0 .. 31;
      TOP at 16#10# range 0 .. 31;
   end record;

   type Slice_Array is array (Slice) of Slice_Registers;

   Slices : Slice_Array
     with Import, Address => PWM_Periph'Address;
end RP2350_SVD.PWM_Slices;
