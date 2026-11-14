--  SPDX-License-Identifier: Apache-2.0
package body Keel.DAC.PWM_Adapter is
   procedure Set (O : in out PWM_Output; V : Volts) is
   begin
      Set_Level
        (O, PWM_Level (Setting_Of (O), Supply, Volts'Max (V, 0.0)));
   end Set;
end Keel.DAC.PWM_Adapter;
