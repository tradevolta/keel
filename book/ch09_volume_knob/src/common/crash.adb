--  SPDX-License-Identifier: Apache-2.0
package body Crash is

   type Action is access procedure;

   --  Exported and volatile: the compiler may not assume it is
   --  still null and replace the call with something cleverer
   Nothing : Action := null
     with Volatile, Export, External_Name => "crash_nothing";

   procedure Now is
      pragma Suppress (Access_Check);
   begin
      Nothing.all;
   end Now;
end Crash;
