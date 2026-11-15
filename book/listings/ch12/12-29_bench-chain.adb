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
