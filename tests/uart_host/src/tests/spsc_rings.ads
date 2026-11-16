--  SPDX-License-Identifier: Apache-2.0
--  A ring for the two-task test. The contracts are proved, and here
--  they would read both counters while the other task changes one,
--  so they aren't checked at run time in this instance.
pragma Assertion_Policy (Ignore);
with Keel.Ring_Buffers;

package SPSC_Rings is new Keel.Ring_Buffers
  (Element => Integer, Initial => 0, Size_Bits => 4);
