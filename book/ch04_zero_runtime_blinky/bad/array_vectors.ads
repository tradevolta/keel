--  SPDX-License-Identifier: Apache-2.0
--  Does not compile, on purpose: an array aggregate with "others"
--  needs elaboration code, which this package forbids.
with System;

package Array_Vectors
  with Preelaborate, No_Elaboration_Code_All
is
   procedure Default_Handler
     with Import, Convention => C,
          External_Name => "keel_default_handler";

   type Vector_Table is array (0 .. 15) of System.Address;

   Vectors : constant Vector_Table :=
     [others => Default_Handler'Address];
end Array_Vectors;
