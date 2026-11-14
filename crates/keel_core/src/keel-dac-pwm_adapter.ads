--  SPDX-License-Identifier: Apache-2.0
--  A DAC made from a PWM output and an RC filter: Set picks the
--  level whose average is V, and Signature makes it a Keel.DAC
--  output. Supply is the pin's high level: 3.3 V on both boards.
with Keel.PWM;

generic
   type PWM_Output (<>) is limited private;
   with function Setting_Of (O : PWM_Output) return Keel.PWM.Setting
     is <>;
   with procedure Set_Level (O : in out PWM_Output;
                             Level : Keel.PWM.Count) is <>;
   Supply : Volts;
package Keel.DAC.PWM_Adapter
  with Preelaborate
is
   --  V below 0 gives 0 V, and above Supply gives Supply
   procedure Set (O : in out PWM_Output; V : Volts)
     with Pre => Supply in 0.5 .. 5.0;

   package Signature is new Output_Signature (PWM_Output, Set, Supply);
end Keel.DAC.PWM_Adapter;
