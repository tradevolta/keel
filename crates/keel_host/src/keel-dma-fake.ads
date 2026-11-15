--  SPDX-License-Identifier: Apache-2.0
--  Keel.DMA.Fake: a DMA engine for tests on the host. Run does the
--  whole transfer at once, with the processor, and hands back the
--  receipt a real driver gives at the end. No pacing, no interrupts:
--  it is for the ownership rules and the arithmetic, not timing.
package Keel.DMA.Fake
  with SPARK_Mode
is
   --  Copy N elements of Size from From to To. A register end stays
   --  put; a RAM end moves on, round a ring of 2**Wrap bytes if Wrap
   --  is not 0. Done covers both ends.
   procedure Run
     (From, To : Region; Size : Element_Size; N : Count;
      Wrap : Ring_Bits; Done : out Receipt)
     with Global => null, Always_Terminates,
          Pre  => (Is_Register (From) or else Fits (From, Size, N, 0))
                  and then (Is_Register (To)
                            or else Fits (To, Size, N, Wrap)),
          Post => Covers (Done, From) and then Covers (Done, To)
                  and then Moved (Done) = N;
end Keel.DMA.Fake;
