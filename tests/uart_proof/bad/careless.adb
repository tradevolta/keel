--  SPDX-License-Identifier: Apache-2.0
package body Careless
  with SPARK_Mode
is
   procedure Take_Three (R : in out Bytes.Ring; S : out String) is
   begin
      for I in S'Range loop
         Bytes.Pop (R, S (I));
      end loop;
   end Take_Three;
end Careless;
