--  What a driver hands back when a transfer is over: finished,
--  stopped or failed. Only a driver makes one with anything in
--  it; a receipt declared by a program covers nothing.
type Receipt is private;

--  The receipt's transfer had R, or part of it, as one of its ends
function Covers (Done : Receipt; R : Region) return Boolean;

--  Elements that the transfer moved before it ended
function Moved (Done : Receipt) return Count;

--  Ring positions: slots 0 .. Slots - 1 of a ring of Slots
--  elements. Advance moves on By slots and wraps; Distance is how
--  far To is ahead of From, going forward.
subtype Ring_Length is Positive range 1 .. 2**15;
subtype Ring_Slot is Natural range 0 .. 2**15 - 1;

function Advance
  (From : Ring_Slot; By : Natural; Slots : Ring_Length)
   return Ring_Slot
  with Pre  => From < Slots and then By <= Slots,
       Post => Advance'Result < Slots
               and then Advance'Result =
                 (if From + By < Slots then From + By
                  else From + By - Slots);

function Distance (From, To : Ring_Slot; Slots : Ring_Length)
  return Ring_Slot
  with Pre  => From < Slots and then To < Slots,
       Post => Distance'Result < Slots
               and then Advance (From, Distance'Result, Slots) = To;

--  The slot By places before From
function Back
  (From : Ring_Slot; By : Natural; Slots : Ring_Length)
   return Ring_Slot
  with Pre  => From < Slots and then By <= Slots,
       Post => Back'Result < Slots
               and then Advance (Back'Result, By, Slots) = From;
