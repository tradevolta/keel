--  What paces a transfer: a peripheral's DREQ (datasheet 12.6.4.1,
--  Table 1254), a pacing timer (59 to 62), or nothing (63)
type Request is range 0 .. 63;
ADC_Request : constant Request := 48;
Unpaced     : constant Request := 63;

--  Once: Count elements, then stop. Repeat: Count elements, then
--  go on from where it got to; each round ends with the event and
--  the chain. Endless: the count never runs down, and no round
--  ever ends (datasheet 12.6.2.2.1).
type Count_Mode is (Once, Repeat, Endless);

type Transfer is record
   From, To : Region := No_Region;
   Size     : Element_Size := Word;
   Count    : DMA.Count := 0;
   Paced_By : Request := Unpaced;
   Mode     : Count_Mode := Once;
   --  A ring of 2**Wrap bytes on the end in RAM (To, if both are)
   Wrap     : Ring_Bits := 0;
   --  At the end, start Chain_To, which Prepare has set up
   Chain    : Boolean := False;
   Chain_To : Channel := 0;
   --  At the end of each round: the interrupt, the event
   Notify   : Boolean := True;
end record;

--  The ring is on To if To is in RAM, else on From
function Ring_On_To (T : Transfer) return Boolean is
  (not Is_Register (T.To));

--  T can run: each end fits it, a ring end is the whole ring, and
--  a transfer that goes round again has its only RAM end in a
--  ring. Count is not 0 (a chain from an empty transfer may not
--  fire: erratum RP2350-E8).
function Valid (T : Transfer) return Boolean is
  (T.Count > 0
   and then (if Is_Register (T.From) then Aligned (T.From, T.Size)
             else Fits (T.From, T.Size, T.Count,
                        (if Ring_On_To (T) then 0 else T.Wrap)))
   and then (if Is_Register (T.To) then Aligned (T.To, T.Size)
             else Fits (T.To, T.Size, T.Count, T.Wrap))
   and then (T.Mode = Once
             or else (T.Wrap > 0
                      and then (Is_Register (T.From)
                                or else Is_Register (T.To)))));
