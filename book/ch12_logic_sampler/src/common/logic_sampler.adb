--  SPDX-License-Identifier: Apache-2.0
--  The logic sampler. The ADC converts GP27 500 000 times a second,
--  and a DMA channel moves every sample into an 8 KB ring, round
--  and round, with an interrupt after each half. The processor
--  sleeps until a half is full, scans it for the trigger, and sleeps
--  again. Once the trigger has fired, it lets the DMA write the rest
--  of the capture, stops it, takes the ring back, and prints the
--  capture over RTT for the host's viewer. Then it does it again.
with Board;           use Board;
with Buffers;         use Buffers;
with Bench;
with Capture_Format;
with Keel;            use type Keel.Status;
with Keel.ADC.RP2350; use Keel.ADC.RP2350;
with Keel.DMA;        use Keel.DMA;
with Keel.DMA.RP2350; use Keel.DMA.RP2350;
with Keel.Time;       use Keel.Time;
with Keel.Units;      use Keel.Units;
with Sampler_Logic;
with Trigger;         use Trigger;

procedure Logic_Sampler is
   use Samples;

   Rate : constant := 500_000;

   --  A capture: 1024 samples before the trigger and 2560 from it
   --  on, 7.2 ms in all, with 512 slots of the ring to spare
   Pre    : constant := 1_024;
   Post   : constant := 2_560;
   Length : constant := Pre + Post;

   --  1.65 V, rising, with a band of 64 codes, about 52 mV
   Set : constant Setting :=
     (Threshold => 2_048, Band => 64, Slope => Rising);

   function Settled (Slot : Ring_Slot) return Sample is
     (Peek (Ring, Slot));

   package Logic is new Sampler_Logic
     (Slots => Ring_Slots, Pre => Pre, Post => Post,
      Sample_At => Settled);
   use Logic;

   package Out_Format is new Capture_Format (Put_Line_Waiting);

   Stream : constant Transfer :=
     (From => FIFO, To => No_Region, Size => Half_Word,
      Count => Half, Paced_By => ADC_Request, Mode => Repeat,
      Wrap => Ring_Wrap, others => <>);

   R       : Region;
   Done    : Receipt;
   S       : State;
   Found   : Boolean;
   T       : Ring_Slot;
   Next    : Ring_Slot;
   Seen    : Natural;
   Lost    : Boolean;
   Behind  : Boolean;
   Stat    : Keel.Status;
   Errors  : Natural;
   Line    : Out_Format.Sample_Array (1 .. Out_Format.Per_Line);
   Filled  : Natural;
   Next_Go : Time;

   --  The DMA's next slot, from its write address
   function Write_Slot return Ring_Slot is
     (Ring_Slot (Position (Sampler) / 2 mod Ring_Slots));
begin
   Board.Initialize;
   Bench.Run;

   loop
      --  Arm: the DMA first, then the ADC (datasheet 12.4.3.5)
      Lend (Ring, R);
      Start (Sampler, (Stream with delta To => R), Stat);
      if Stat = Keel.Ok then
         Start_Stream (Probe, Hertz (Rate), Stat);
      end if;
      if Stat /= Keel.Ok then
         Put_Line ("sampler: cannot start: " & Stat'Image);
         loop
            null;
         end loop;
      end if;

      --  Sleep, half by half, until the trigger fires. The first
      --  half only arms it, so that Pre samples exist before T.
      S := (others => <>);
      Seen := 0;
      Behind := False;
      loop
         Wait_Round (Sampler);
         Seen := Seen + 1;
         Behind := Behind or else Rounds (Sampler) > Seen;
         Scan (S, Set, (if Seen mod 2 = 1 then 0 else Half), Half,
               Found, T);
         exit when Found and then Seen > 1;
      end loop;

      --  The rest of the capture, then stop
      loop
         Next := Write_Slot;
         exit when Logic.Done (T, Next);
      end loop;
      Stop (Sampler, Done);
      Stop_Stream (Lost);
      Next := Write_Slot;
      Reclaim (Ring, Done);

      --  The ring is the program's again: print the capture
      Out_Format.Header (Rate, Length, Pre, Set);
      Errors := 0;
      Filled := 0;
      for K in Natural range 0 .. Length - 1 loop
         Filled := Filled + 1;
         Line (Filled) := Get (Ring, Slot_Of (T, K));
         if Failed (Line (Filled)) then
            Errors := Errors + 1;
         end if;
         if Filled = Line'Last then
            Out_Format.Data (Line);
            Filled := 0;
         end if;
      end loop;
      if Filled > 0 then
         Out_Format.Data (Line (1 .. Filled));
      end if;
      Out_Format.Finish (Errors);
      if Behind or else Lost or else not Intact (T, Next) then
         Put_Line ("sampler: samples were lost: behind "
                   & Behind'Image & ", FIFO" & Lost'Image
                   & ", overwritten " & Boolean'Image
                     (not Intact (T, Next)));
      end if;

      Next_Go := Now + Milliseconds (2_000);
      Wait_Until (Next_Go);
   end loop;
end Logic_Sampler;
