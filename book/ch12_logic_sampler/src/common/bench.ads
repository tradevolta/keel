--  SPDX-License-Identifier: Apache-2.0
--  The benchmark: 4 KB copied from SRAM to SRAM by the processor,
--  by one DMA channel, by two chained channels, and by the
--  processor while the DMA copies another 4 KB, with the DMA at
--  normal and then high bus priority. Each line gives core cycles.
package Bench is
   procedure Run;
end Bench;
