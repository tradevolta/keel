pragma Style_Checks (Off);

--  Copyright (c) 2024 Raspberry Pi Ltd.        SPDX-License-Identifier: BSD-3-Clause

--  This spec has been automatically generated from RP2350.svd

pragma Restrictions (No_Elaboration_Code);

with System;

package RP2350_SVD.VIRTUAL is
   pragma Preelaborate;

   ---------------
   -- Registers --
   ---------------

   -----------------
   -- Peripherals --
   -----------------

   type VIRTUAL_Peripheral is record
      --  Dummy register for schema compliance
      DUMMY : aliased RP2350_SVD.UInt32;
   end record
     with Volatile;

   for VIRTUAL_Peripheral use record
      DUMMY at 0 range 0 .. 31;
   end record;

   VIRTUAL_Periph : aliased VIRTUAL_Peripheral
     with Import, Address => VIRTUAL_Base;

end RP2350_SVD.VIRTUAL;
