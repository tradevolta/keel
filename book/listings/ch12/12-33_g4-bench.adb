--  2. DMA1 channel 1, memory to memory
Fill (B, 0);
Lend (A, RA);
Lend (B, RB);
T0 := Keel.Cortex_M.DWT_CYCCNT;
Start (Bench, Copy_All (RA, RB), Stat);
Wait (Bench, Done);
T1 := Keel.Cortex_M.DWT_CYCCNT;
Reclaim (A, Done);
Reclaim (B, Done);
Report ("4096 bytes, one DMA channel:", T1 - T0,
        Stat = Keel.Ok and then Same (A, B));
