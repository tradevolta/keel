--  SPDX-License-Identifier: Apache-2.0
--  The rings Keel's UART drivers use, instantiated for the proof
with Keel.Ring_Buffers;
package Char_Rings
  with SPARK_Mode
is
   package Bytes is new Keel.Ring_Buffers
     (Element => Character, Initial => ' ', Size_Bits => 8);
   package Words is new Keel.Ring_Buffers
     (Element => Integer, Initial => 0, Size_Bits => 2);
end Char_Rings;
