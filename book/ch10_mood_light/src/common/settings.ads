--  SPDX-License-Identifier: Apache-2.0
--  A PWM setting as one console line
with Keel.PWM;

package Settings is
   --  "div 19/16, top 63157, phase correct, 999.998 Hz"
   function Image (S : Keel.PWM.Setting) return String;
end Settings;
