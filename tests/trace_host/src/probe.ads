--  SPDX-License-Identifier: Apache-2.0
--  What a debug probe does with RTT, done from inside the process:
--  find the control block by its ID and drain up channel 0.
package Probe is

   --  The control block's ID and channel counts, as one line
   function Describe return String;

   --  Everything written since the last Drain, oldest first
   function Drain return String;
end Probe;
