--  SPDX-License-Identifier: Apache-2.0
--  State you inspect and change from GDB while the board runs.
--  Volatile: every loop iteration re-reads memory, so a value that
--  GDB writes takes effect on the next blink.
package Blink_Control is

   Half_Period_Ms : Positive := 250
     with Volatile;

   Toggles : Natural := 0
     with Volatile;

end Blink_Control;
