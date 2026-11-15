--  4. The processor copies C to D while the DMA copies A to B,
--  all in the same striped SRAM: who waits for the bus?
for DMA_First in Boolean loop
   Favour_DMA (DMA_First);
   Fill (B, 0);
   Fill (D, 0);
   Lend (A, RA);
   Lend (B, RB);
   Start (Bench_A, Copy_All (RA, RB), Stat);
   T0 := Cycles;
   Copy (C, D);
   T1 := Cycles;
   Wait (Bench_A, Done);
   Reclaim (A, Done);
   Reclaim (B, Done);
   Report ((if DMA_First then "processor, DMA at high priority:"
            else "processor, DMA copying too:"),
           T1 - T0,
           Stat = Keel.Ok and then Same (A, B)
           and then Same (C, D));
end loop;
Favour_DMA (False);
