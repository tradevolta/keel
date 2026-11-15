--  SPDX-License-Identifier: Apache-2.0
with Interfaces;      use Interfaces;
with Board;           use Board;
with Buffers;         use Buffers;
with Keel;            use type Keel.Status;
with Keel.DMA;        use Keel.DMA;
with Keel.DMA.RP2350; use Keel.DMA.RP2350;

package body Bench is
   use Words;

   Bytes_Each : constant := Block_Words * 4;
   Half_Bytes : constant := Bytes_Each / 2;

   --  A pattern no two words of which are the same
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
      Put_Line ("bench: " & What & Took'Image & " cycles"
                & (if Ok then "" else ", WRONG DATA"));
   end Report;

   --  One channel, From to To, as fast as the bus goes
   function Copy_All (From, To : Region) return Transfer is
     ((From => From, To => To, Size => Word, Count => Block_Words,
       others => <>));

   procedure Run is
      RA, RB : Region;
      Done   : Receipt;
      T0, T1 : Unsigned_32;
      Stat   : Keel.Status;
   begin
      Fill_Pattern (A, 1);
      Fill_Pattern (C, 2);

      --  1. The processor: an array assignment, which is memcpy. The
      --  first copy brings memcpy from flash into the XIP cache.
      Copy (A, B);
      Fill (B, 0);
      T0 := Cycles;
      Copy (A, B);
      T1 := Cycles;
      Report ("4096 bytes, processor:", T1 - T0, Same (A, B));

      --  2. One DMA channel, and the processor asleep in Wait
      Fill (B, 0);
      Lend (A, RA);
      Lend (B, RB);
      T0 := Cycles;
      Start (Bench_A, Copy_All (RA, RB), Stat);
      Wait (Bench_A, Done);
      T1 := Cycles;
      Reclaim (A, Done);
      Reclaim (B, Done);
      Report ("4096 bytes, one DMA channel:", T1 - T0,
              Stat = Keel.Ok and then Same (A, B));

      --  3. Two channels, each one half: A's end starts B
      Fill (B, 0);
      Lend (A, RA);
      Lend (B, RB);
      T0 := Cycles;
      Prepare
        (Bench_B,
         (From  => Slice (RA, Half_Bytes, Half_Bytes),
          To    => Slice (RB, Half_Bytes, Half_Bytes),
          Size  => Word, Count => Block_Words / 2, others => <>),
         Stat);
      if Stat = Keel.Ok then
         Start
           (Bench_A,
            (From   => Slice (RA, 0, Half_Bytes),
             To     => Slice (RB, 0, Half_Bytes),
             Size   => Word, Count => Block_Words / 2,
             Chain  => True, Chain_To => Bench_B, Notify => False,
             others => <>),
            Stat);
      end if;
      --  The links run in order: when B is done, so is A
      Wait (Bench_B, Done);
      T1 := Cycles;
      Reclaim (A, Done);
      Reclaim (B, Done);
      Report ("4096 bytes, two chained channels:", T1 - T0,
              Stat = Keel.Ok and then Same (A, B));

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
   end Run;
end Bench;
