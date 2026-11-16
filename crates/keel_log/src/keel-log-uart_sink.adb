--  SPDX-License-Identifier: Apache-2.0
package body Keel.Log.UART_Sink is
   Lost : Natural := 0;

   procedure Write (Text : String) is
   begin
      if Console.Space >= Text'Length then
         Console.Write (Text);
      elsif Lost < Natural'Last then
         Lost := Lost + 1;
      end if;
   end Write;

   function Dropped return Natural is (Lost);
end Keel.Log.UART_Sink;
