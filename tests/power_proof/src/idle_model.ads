--  SPDX-License-Identifier: Apache-2.0
--  A model clock and mode table, so GNATprove sees Keel.Power.Idle
--  instantiated
with Keel.Power; use Keel.Power;
with Keel.Time;  use Keel.Time;

package Idle_Model
  with SPARK_Mode
is
   Now_Model : Time := 0;

   function Clock return Time is (Time'Min (Now_Model, Max_Clock))
     with Global => Now_Model;
   procedure Enter (M : Mode; Deadline : Time)
     with Global => (In_Out => Now_Model);
   function Current return Policy is
     ((Deepest => Dormant, Wake => [Run => 0, Sleep => 10,
                                    Dormant => 5_000,
                                    Power_Down => 1_000_000]));

   package Waits is new Idle (Clock, Enter, Current);
end Idle_Model;
