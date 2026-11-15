--  SPDX-License-Identifier: Apache-2.0
--  The NUCLEO-G474RE's half of Chapter 12: the benchmark. It copies
--  4 KB from one buffer in SRAM to another with the processor
--  (memcpy), then with DMA1 channel 1 while the processor sleeps in
--  Wait, then with both at once on different buffers, and prints
--  the cycles each took over RTT. The G474 has no chaining, so
--  there is no third test.
with Interfaces;         use Interfaces;
with Keel;               use type Keel.Status;
with Keel.Clock;
with Keel.Clock.STM32G4; use Keel.Clock.STM32G4;
with Keel.Cortex_M;
with Keel.DMA;           use Keel.DMA;
with Keel.DMA.STM32G4;   use Keel.DMA.STM32G4;
with Keel.Time.Bare;
with Keel.Trace;
with Bench_Buffers;      use Bench_Buffers;

procedure DMA_Bench is
   use Words;

   Bench  : constant Channel := 1;
   Target : constant Keel.Clock.Frequency := 150_000_000;

   PLL_Setting : Keel.Clock.PLL_Config;
   Found  : Boolean;
   Stat   : Keel.Status;
   RA, RB : Region;
   Done   : Receipt;
   T0, T1 : Unsigned_32;

   procedure Check (What : String) is
   begin
      if Stat /= Keel.Ok then
         Keel.Trace.Put_Line ("dma_bench: " & What & ": "
                              & Stat'Image);
         loop
            null;
         end loop;
      end if;
   end Check;

   procedure Fill_Pattern (X : in out Buffer; Seed : Unsigned_32) is
   begin
      for I in Index loop
         Put (X, I, Seed + Unsigned_32 (I) * 16#9E37_79B9#);
      end loop;
   end Fill_Pattern;

   function Same (X, Y : Buffer) return Boolean is
     (for all I in Index => Get (X, I) = Get (Y, I));

   procedure Report (What : String; Took : Unsigned_32; Ok : Boolean)
   is
   begin
      Keel.Trace.Put_Line
        ("bench: " & What & Took'Image & " cycles"
         & (if Ok then "" else ", WRONG DATA"));
   end Report;

   function Copy_All (From, To : Region) return Transfer is
     ((From => From, To => To, Size => Word, Count => Block_Words,
       others => <>));
begin
   Keel.Trace.Initialize;
   Keel.Clock.Solve (PLL, HSI16, Target, False, PLL_Setting, Found);
   if Found then
      Run_From_PLL (PLL_Setting, Stat);
      Check ("PLL");
   end if;
   Keel.Time.Bare.Start (Sys_Frequency);
   Keel.Cortex_M.DEMCR := (TRCENA => True);
   Keel.Cortex_M.DWT_Ctrl := (CYCCNTENA => True);
   Keel.DMA.STM32G4.Enable;
   Claim (Bench, Stat);
   Check ("DMA1 channel 1");

   Fill_Pattern (A, 1);
   Fill_Pattern (C, 2);

   --  1. The processor, warm: the first copy fills the flash
   --  accelerator's caches with memcpy
   Copy (A, B);
   Fill (B, 0);
   T0 := Keel.Cortex_M.DWT_CYCCNT;
   Copy (A, B);
   T1 := Keel.Cortex_M.DWT_CYCCNT;
   Report ("4096 bytes, processor:", T1 - T0, Same (A, B));

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

   --  3. Both at once: the processor copies C to D meanwhile
   Fill (B, 0);
   Fill (D, 0);
   Lend (A, RA);
   Lend (B, RB);
   Start (Bench, Copy_All (RA, RB), Stat);
   T0 := Keel.Cortex_M.DWT_CYCCNT;
   Copy (C, D);
   T1 := Keel.Cortex_M.DWT_CYCCNT;
   Wait (Bench, Done);
   Reclaim (A, Done);
   Reclaim (B, Done);
   Report ("processor, DMA copying too:", T1 - T0,
           Stat = Keel.Ok and then Same (A, B) and then Same (C, D));

   loop
      null;
   end loop;
end DMA_Bench;
