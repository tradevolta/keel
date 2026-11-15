--  SPDX-License-Identifier: Apache-2.0
--  A program that keeps the rules: it fills a buffer, lends it and
--  its copy to the DMA, takes both back with the receipt, and only
--  then reads the copy.
with Interfaces; use Interfaces;
with Keel.DMA.Buffers;

package Lending
  with SPARK_Mode
is
   package Words is new Keel.DMA.Buffers (Unsigned_32, 256);
   use Words;

   Source, Copy : Buffer;

   procedure Run (First : out Unsigned_32)
     with Global => (In_Out => (Source, Copy)),
          Pre    => Owner (Source) = Program
                    and then Owner (Copy) = Program,
          Post   => Owner (Source) = Program
                    and then Owner (Copy) = Program;
end Lending;
