--  How many characters the DMA has written since Open. Rounds
--  counts the ring's laps, but the interrupt that counts one comes
--  a moment after the write address wraps: a count that would put
--  the DMA behind the program is one lap short.
function DMA_Head (P : Port_Id) return DMA_Count is
   Ch     : constant Keel.DMA.RP2350.Channel := State (P).Channel;
   R1, R2 : Natural;
   Pos    : Natural;
   H      : DMA_Count;
begin
   loop
      R1 := Keel.DMA.RP2350.Rounds (Ch);
      Pos := Keel.DMA.RP2350.Position (Ch);
      R2 := Keel.DMA.RP2350.Rounds (Ch);
      exit when R1 = R2;
   end loop;
   H := DMA_Count (R1 mod 2**24) * Ring_Size
     + DMA_Count (Pos mod Ring_Size);
   if H - DMA_Tail (P) > 2**31 then
      H := H + Ring_Size;
   end if;
   return H;
end DMA_Head;
