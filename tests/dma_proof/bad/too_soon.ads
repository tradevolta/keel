--  SPDX-License-Identifier: Apache-2.0
with Interfaces; use Interfaces;
with Keel.DMA;   use Keel.DMA;
with Keel.DMA.Buffers;

package Too_Soon
  with SPARK_Mode
is
   package Words is new Keel.DMA.Buffers (Unsigned_32, 256);
   use Words;

   Copy    : Buffer;
   Pending : Region;

   --  Reads the copy while the DMA still holds it
   procedure Read_Early (First : out Unsigned_32)
     with Global => (In_Out => Copy, Output => Pending),
          Pre    => Owner (Copy) = Program;

   --  Takes the copy back with a receipt it made up
   procedure Forge (First : out Unsigned_32)
     with Global => (In_Out => Copy, Output => Pending),
          Pre    => Owner (Copy) = Program;
end Too_Soon;
