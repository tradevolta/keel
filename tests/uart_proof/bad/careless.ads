--  SPDX-License-Identifier: Apache-2.0
with Keel.Ring_Buffers;

package Careless
  with SPARK_Mode
is
   package Bytes is new Keel.Ring_Buffers (Character, ' ', 8);

   --  Takes the next three characters, without asking if they came
   procedure Take_Three (R : in out Bytes.Ring; S : out String)
     with Pre => S'Length = 3;
end Careless;
