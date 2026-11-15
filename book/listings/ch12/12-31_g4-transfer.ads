--  DMAMUX1's request inputs (ST's LL driver,
--  stm32g4xx_ll_dmamux.h; RM0440's DMAMUX table to check)
type Request is range 0 .. 127;
Memory_To_Memory : constant Request := 0;
ADC1_Request     : constant Request := 5;

subtype Count_16 is DMA.Count range 0 .. 65_535;

type Transfer is record
   From, To : Region := No_Region;
   Size     : Element_Size := Word;
   Count    : Count_16 := 0;
   Paced_By : Request := Memory_To_Memory;
   --  Start again from the first element after the last
   Circular : Boolean := False;
   --  The interrupt and the event: at the end of each round, and
   --  with Halves at the middle too
   Notify   : Boolean := True;
   Halves   : Boolean := False;
end record;

--  T can run: from RAM to RAM, unpaced and once; or between a
--  register and RAM, paced, where the RAM end holds Count
--  elements (the ring, if Circular)
function Valid (T : Transfer) return Boolean is
  (T.Count > 0
   and then
     (if T.Paced_By = Memory_To_Memory then
        not T.Circular
        and then Fits (T.From, T.Size, T.Count, 0)
        and then Fits (T.To, T.Size, T.Count, 0)
      else
        (Is_Register (T.From) and then Aligned (T.From, T.Size)
         and then Fits (T.To, T.Size, T.Count, 0))
        or else
        (Is_Register (T.To) and then Aligned (T.To, T.Size)
         and then Fits (T.From, T.Size, T.Count, 0))));
