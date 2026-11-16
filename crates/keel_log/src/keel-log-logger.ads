--  SPDX-License-Identifier: Apache-2.0
--  A logger: lines at or above the threshold go to Write, stamped
--  with Clock_Ms. A message longer than Max_Message is cut there.
generic
   with procedure Write (Text : String);
   with function Clock_Ms return Natural;
package Keel.Log.Logger is
   procedure Set_Threshold (L : Level);
   function Threshold return Level;

   procedure Put (L : Level; Message : String);

   procedure Debug (Message : String);
   procedure Info (Message : String);
   procedure Warn (Message : String);
   procedure Error (Message : String);
end Keel.Log.Logger;
