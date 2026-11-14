--  SPDX-License-Identifier: Apache-2.0
--  Keel.Timer: hardware alarms. An alarm raises its interrupt at a
--  Keel.Time.Time; the handler acknowledges it and may set it again,
--  which makes a periodic timer that does not drift. A driver that
--  needs an alarm is written against Alarm_Signature.
with Keel.Time;

package Keel.Timer
  with Pure, No_Elaboration_Code_All
is
   generic
      type Alarm (<>) is limited private;
      --  Raise the alarm's interrupt at At_Time, or at once if it has
      --  passed. Replaces any time set before.
      with procedure Set (A : in out Alarm; At_Time : Keel.Time.Time);
      --  Disarm it: no interrupt until the next Set
      with procedure Cancel (A : in out Alarm);
      --  Set, and not yet fired or cancelled
      with function Is_Armed (A : Alarm) return Boolean;
      --  Clear the alarm's latched interrupt; first, in the handler
      with procedure Acknowledge (A : in out Alarm);
   package Alarm_Signature is
   end Alarm_Signature;
end Keel.Timer;
