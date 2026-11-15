--  A volatile read: the DMA writes the data behind the compiler's
--  back, so the value may not come from an earlier read
function Peek (B : Buffer; I : Index) return Element
  with SPARK_Mode => Off
is
   Slot : Element
     with Import, Volatile, Address => B.Data (I)'Address;
begin
   return Slot;
end Peek;
