--  SPDX-License-Identifier: Apache-2.0
--  The pin operations again, as limited interfaces: for code that
--  holds pins of different types in one place, chosen at run time.
--  Every call dispatches. Keel's drivers take the signatures; wrap a
--  signature instance in an adapter to get a line.
package Keel.GPIO.Lines
  with Pure, SPARK_Mode
is
   type Output_Line is limited interface;
   procedure Set (L : in out Output_Line; To : Level) is abstract;

   type Input_Line is limited interface;
   function Get (L : Input_Line) return Level is abstract;
end Keel.GPIO.Lines;
