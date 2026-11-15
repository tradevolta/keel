--  SPDX-License-Identifier: Apache-2.0
with Keel.DMA;      use Keel.DMA;
with Keel.DMA.Fake;

package body Lending
  with SPARK_Mode
is
   procedure Run (First : out Unsigned_32) is
      From, To : Region;
      Done     : Receipt;
   begin
      Fill (Source, 16#C0DE_0000#);
      Lend (Source, From);
      Lend (Copy, To);
      Keel.DMA.Fake.Run (From, To, Word, 256, 0, Done);
      Reclaim (Source, Done);
      Reclaim (Copy, Done);
      First := Get (Copy, 0);
   end Run;
end Lending;
