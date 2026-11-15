--  SPDX-License-Identifier: Apache-2.0
--  Keel.DMA on the host: ring arithmetic, where a transfer fits,
--  buffers lent to the fake engine and taken back, the misuses the
--  contracts catch at run time, and the logic sampler's whole path
--  (ring, trigger, capture text) on a simulated input. It writes the
--  capture to capture-sim.txt for the viewer.
with Ada.Text_IO;      use Ada.Text_IO;
with Ada.Command_Line;
with Ada.Assertions;
with Interfaces;       use Interfaces;
with Keel.DMA;         use Keel.DMA;
with Keel.DMA.Buffers;
with Keel.DMA.Fake;
with Capture_Format;
with Sampler_Logic;
with Sim;              use Sim;
with Trigger;          use Trigger;

procedure DMA_Host is
   Failures : Natural := 0;

   procedure Check (Name : String; OK : Boolean) is
   begin
      Put_Line ((if OK then "ok:   " else "FAIL: ") & Name);
      if not OK then
         Failures := Failures + 1;
      end if;
   end Check;

   function Img (N : Integer) return String is
      S : constant String := N'Image;
   begin
      return S (S'First + 1 .. S'Last);
   end Img;

   --  Small buffers for the engine: 12 half-words, and a ring of 4
   package Halves is new Keel.DMA.Buffers (Unsigned_16, 12);
   package Little is new Keel.DMA.Buffers (Unsigned_16, 4);
   package Words is new Keel.DMA.Buffers (Unsigned_32, 64);

   type Aligned_Little is limited record
      B : Little.Buffer;
   end record
     with Alignment => 16;

   Src      : Halves.Buffer;
   Ring_Box : Aligned_Little;
   Small    : Little.Buffer renames Ring_Box.B;
   W1, W2   : Words.Buffer;
   Done     : Receipt;
   Done_2   : Receipt;
   R1, R2   : Region;
   Caught   : Boolean;
   Same     : Boolean;
begin
   --  Ring arithmetic
   Check ("Advance (4090, 10, 4096) = 4",
          Advance (4_090, 10, 4_096) = 4);
   Check ("Distance (4000, 100, 4096) = 196",
          Distance (4_000, 100, 4_096) = 196);
   Check ("Back (100, 1024, 4096) = 3172",
          Back (100, 1_024, 4_096) = 3_172);
   Check ("Ring_Bytes: 1 .. 15 give 2 .. 32768",
          Ring_Bytes (1) = 2 and then Ring_Bytes (13) = 8_192
          and then Ring_Bytes (15) = 32_768);

   --  Where a transfer fits
   Little.Lend (Small, R1);
   Check ("a 4-slot ring on a multiple of 8 fits, Wrap 3",
          Fits (R1, Half_Word, 1_000, 3));
   Check ("12 half-words don't fit in it without a ring",
          not Fits (R1, Half_Word, 12, 0));
   Check ("4 do", Fits (R1, Half_Word, 4, 0));
   Check ("Wrap 4 is 16 bytes: not this ring",
          not Fits (R1, Half_Word, 4, 4));
   Check ("a ring that starts off its multiple doesn't fit",
          not Fits (Slice (R1, 2, 4), Half_Word, 4, 2));
   Check ("a register is not RAM",
          not Fits (Register (R1'Address), Word, 1, 0));

   --  The fake engine: 12 half-words round a ring of 4
   for I in Halves.Index loop
      Halves.Put (Src, I, Unsigned_16 (100 + I));
   end loop;
   Halves.Lend (Src, R2);
   Keel.DMA.Fake.Run (R2, R1, Half_Word, 12, 3, Done);
   Halves.Reclaim (Src, Done);
   Little.Reclaim (Small, Done);
   Check ("the ring holds the last 4: 108 109 110 111",
          Little.Get (Small, 0) = 108
          and then Little.Get (Small, 3) = 111);
   Check ("the receipt says 12 moved", Moved (Done) = 12);

   --  Memory to memory, words, then Copy by the processor
   for I in Words.Index loop
      Words.Put (W1, I, 16#DEAD_0000# + Unsigned_32 (I));
   end loop;
   Words.Fill (W2, 0);
   Words.Lend (W1, R1);
   Words.Lend (W2, R2);
   Keel.DMA.Fake.Run (R1, R2, Word, 64, 0, Done);
   Words.Reclaim (W1, Done);
   Words.Reclaim (W2, Done);
   Same := True;
   for I in Words.Index loop
      Same := Same and then Words.Get (W2, I) = Words.Get (W1, I);
   end loop;
   Check ("64 words copied by the engine", Same);

   --  What the contracts catch at run time
   Words.Lend (W1, R1);
   Caught := False;
   begin
      if Words.Get (W1, 0) = 0 then
         null;
      end if;
   exception
      when Ada.Assertions.Assertion_Error => Caught := True;
   end;
   Check ("Get while the DMA holds the buffer: Assertion_Error",
          Caught);
   Caught := False;
   begin
      Words.Reclaim (W1, Done_2);
   exception
      when Ada.Assertions.Assertion_Error => Caught := True;
   end;
   Check ("Reclaim with a blank receipt: Assertion_Error", Caught);
   Caught := False;
   begin
      Words.Reclaim (W1, Done);
   exception
      when Ada.Assertions.Assertion_Error => Caught := True;
   end;
   Check ("Reclaim with the last loan's receipt: Assertion_Error",
          Caught);
   Keel.DMA.Fake.Run (R1, R1, Word, 0, 0, Done);
   Words.Reclaim (W1, Done);
   Check ("Reclaim with this loan's receipt: the program's again",
          Words."=" (Words.Owner (W1), Words.Program));

   --  The logic sampler on the simulated input
   declare
      use Samples;

      Pre    : constant := 1_024;
      Post   : constant := 2_560;
      Length : constant := Pre + Post;
      Chunk  : constant := 256;  --  the engine's step, in samples

      Set : constant Setting :=
        (Threshold => 2_048, Band => 64, Slope => Rising);

      function Settled (Slot : Ring_Slot) return Sample is
        (Peek (Ring, Slot));

      package Logic is new Sampler_Logic
        (Slots => Ring_Slots, Pre => Pre, Post => Post,
         Sample_At => Settled);
      use Logic;

      package Feed is new Keel.DMA.Buffers (Sample, Chunk);

      File : File_Type;
      procedure To_File (Text : String) is
      begin
         Put_Line (File, Text);
      end To_File;
      package Out_Format is new Capture_Format (To_File);

      --  Start partway through a cycle, as the board does
      N      : Natural := 337;
      Fed    : Feed.Buffer;
      F      : Region;
      R      : Region;
      Next   : Ring_Slot := 0;
      S      : State;
      Found  : Boolean := False;
      T      : Ring_Slot := 0;
      T_N    : Natural := 0;
      Seen   : Natural := 0;
      Line   : Out_Format.Sample_Array (1 .. Out_Format.Per_Line);
      Filled : Natural := 0;
      Lo, Hi : Level;
      X      : Sample;
   begin
      Lend (Ring, R);
      loop
         --  The engine writes one chunk where the DMA would
         for I in Feed.Index loop
            Feed.Put (Fed, I, Code (N + I));
         end loop;
         Feed.Lend (Fed, F);
         Keel.DMA.Fake.Run
           (F, Slice (R, 2 * Next, 2 * Chunk), Half_Word, Chunk, 0,
            Done);
         Feed.Reclaim (Fed, Done);
         N := N + Chunk;
         Next := Advance (Next, Chunk, Ring_Slots);

         --  A half is full: scan it, as after the half interrupt
         if not Found and then Next mod Half = 0 then
            Seen := Seen + 1;
            Scan (S, Set, (if Next = 0 then Half else 0), Half,
                  Found, T);
            Found := Found and then Seen > 1;
            if Found then
               T_N := N - Distance (T, Next, Ring_Slots);
            end if;
         end if;
         exit when Found and then Logic.Done (T, Next);
      end loop;
      Reclaim (Ring, Done);

      Check ("the trigger fired in half" & Seen'Image
             & ", slot" & T'Image, Seen > 1);
      Check ("it fired " & Img (T_N mod Period)
             & " samples after a rising edge (expected 190)",
             T_N mod Period in 185 .. 195);
      Check ("the DMA wrote the capture without overwriting it",
             Logic.Done (T, Next) and then Intact (T, Next));
      Check ("the sample before T is below the level, T's at it",
             Value (Get (Ring, Back (T, 1, Ring_Slots))) < 2_048
             and then Value (Get (Ring, T)) >= 2_048);

      Create (File, Out_File, "capture-sim.txt");
      Out_Format.Header (Rate, Length, Pre, Set);
      Lo := Level'Last;
      Hi := Level'First;
      for K in Natural range 0 .. Length - 1 loop
         X := Get (Ring, Slot_Of (T, K));
         Lo := Level'Min (Lo, Value (X));
         Hi := Level'Max (Hi, Value (X));
         Filled := Filled + 1;
         Line (Filled) := X;
         if Filled = Line'Last then
            Out_Format.Data (Line);
            Filled := 0;
         end if;
      end loop;
      if Filled > 0 then
         Out_Format.Data (Line (1 .. Filled));
      end if;
      Out_Format.Finish (0);
      Close (File);
      Check ("swing " & Img (Lo) & " .. " & Img (Hi)
             & " codes (expected about 1101 .. 2995)",
             Lo in 1_090 .. 1_115 and then Hi in 2_980 .. 3_010);
      Put_Line ("wrote capture-sim.txt:" & Length'Image & " samples");
   end;

   if Failures = 0 then
      Put_Line ("all DMA host tests passed");
   else
      Put_Line (Failures'Image & " DMA host test(s) failed");
      Ada.Command_Line.Set_Exit_Status (Ada.Command_Line.Failure);
   end if;
end DMA_Host;
