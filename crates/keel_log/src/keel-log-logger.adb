--  SPDX-License-Identifier: Apache-2.0
package body Keel.Log.Logger is
   Current : Level := Info;

   procedure Set_Threshold (L : Level) is
   begin
      Current := L;
   end Set_Threshold;

   function Threshold return Level is (Current);

   procedure Put (L : Level; Message : String) is
      Cut : constant Natural :=
        Natural'Min (Message'Length, Max_Message);
   begin
      if L >= Current then
         Write
           (Line (Clock_Ms, L,
                  Message (Message'First .. Message'First + Cut - 1)));
      end if;
   end Put;

   procedure Debug (Message : String) is
   begin
      Put (Log.Debug, Message);
   end Debug;

   procedure Info (Message : String) is
   begin
      Put (Log.Info, Message);
   end Info;

   procedure Warn (Message : String) is
   begin
      Put (Log.Warn, Message);
   end Warn;

   procedure Error (Message : String) is
   begin
      Put (Log.Error, Message);
   end Error;
end Keel.Log.Logger;
