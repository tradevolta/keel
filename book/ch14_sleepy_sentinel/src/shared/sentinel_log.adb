--  SPDX-License-Identifier: Apache-2.0
package body Sentinel_Log
  with SPARK_Mode
is
   procedure Push (L : in out Log; C : Centi) is
      S : constant Slot := L.Next;
   begin
      if S mod 2 = 1 then
         L.Readings ((S + 1) / 2).Low := C;
      else
         L.Readings (S / 2).High := C;
      end if;
      L.Next := (if S = Capacity then 1 else S + 1);
      L.Held := Natural'Min (L.Held + 1, Capacity);
      L.Taken := Natural'Min (L.Taken + 1, 65_535);
   end Push;

   function Nth (L : Log; I : Positive) return Centi is
      --  The oldest is Held slots back from Next
      First : constant Natural := (L.Next - 1 - L.Held) mod Capacity;
   begin
      return Get (L, (First + I - 1) mod Capacity + 1);
   end Nth;

   function Pack (P : Pair) return Word is
      Low  : constant Word := To_16 (P.Low);
      High : constant Word := To_16 (P.High);
   begin
      pragma Assert ((Low + High * 65_536) mod 65_536 = Low);
      pragma Assert ((Low + High * 65_536) / 65_536 mod 65_536 = High);
      return Low + High * 65_536;
   end Pack;

   function Encode (L : Log) return Words is
      W : Words :=
        [0      => Mark * 65_536 + Word (L.Next - 1) * 256
                     + Word (L.Held),
         7      => Word (L.Taken) * 65_536 + Word (L.Recoveries) * 256
                     + Word (L.Last_Cause),
         others => 0];
   begin
      for J in Pair_Index loop
         W (J) := Pack (L.Readings (J));
         pragma Loop_Invariant
           (for all K in 1 .. J => Unpack (W (K)) = L.Readings (K));
         pragma Loop_Invariant (W (0) = W'Loop_Entry (0)
                                and then W (7) = W'Loop_Entry (7));
      end loop;
      --  The header fields come back out of their bytes
      pragma Assert (W (0) mod 256 = Word (L.Held)
                     and then W (0) / 256 mod 256 = Word (L.Next - 1)
                     and then W (0) / 65_536 = Mark);
      pragma Assert (W (7) mod 256 = Word (L.Last_Cause)
                     and then W (7) / 256 mod 256 = Word (L.Recoveries)
                     and then W (7) / 65_536 = Word (L.Taken));
      pragma Assert (Valid (W));
      pragma Assert (Decode (W).Readings = L.Readings);
      return W;
   end Encode;
end Sentinel_Log;
