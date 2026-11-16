--  SPDX-License-Identifier: Apache-2.0
package body Idle_Model
  with SPARK_Mode
is
   procedure Enter (M : Mode; Deadline : Time) is
      pragma Unreferenced (M);
   begin
      Now_Model := Time'Max (Now_Model, Deadline);
   end Enter;
end Idle_Model;
