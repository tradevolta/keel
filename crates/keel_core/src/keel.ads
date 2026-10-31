--  SPDX-License-Identifier: Apache-2.0
--  Root of the Keel framework: the version and the status type that
--  every HAL operation reports through.
package Keel
  with Pure, SPARK_Mode, No_Elaboration_Code_All
is
   Version : constant String := "0.1.0";

   --  The result of a HAL operation. HAL code raises no exceptions:
   --  a call that can fail has a Stat : out Status parameter.
   --  Ok: it worked.
   --  In_Use: the resource already has an owner.
   --  Not_Supported: this chip cannot do what was asked.
   --  Later chapters add the bus and timeout results.
   type Status is (Ok, In_Use, Not_Supported);
end Keel;
