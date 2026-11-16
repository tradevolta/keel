--  SPDX-License-Identifier: Apache-2.0
--  The sentinel's log: the last twelve temperatures, how many it
--  has taken, and how many times the watchdog has had to rescue it.
--  It lives in eight 32-bit words that survive a power down, packed
--  by Encode and unpacked by Decode. GNATprove proves that Decode
--  gives back exactly what Encode packed, so the log a reboot finds
--  is the log the sentinel left.
package Sentinel_Log
  with Pure, SPARK_Mode
is
   type Word is mod 2**32;
   type Words is array (0 .. 7) of Word;

   --  A temperature in hundredths of a degree, as 16 bits hold it
   subtype Centi is Integer range -32_768 .. 32_767;

   --  Two readings share a word: slots 2J - 1 and 2J are word J
   type Pair is record
      Low, High : Centi := 0;
   end record;
   subtype Pair_Index is Positive range 1 .. 6;
   type Pair_Array is array (Pair_Index) of Pair;

   Capacity : constant := 12;
   subtype Slot is Positive range 1 .. Capacity;

   type Log is record
      Held       : Natural range 0 .. Capacity := 0;
      Next       : Slot := 1;               --  where the next goes
      Taken      : Natural range 0 .. 65_535 := 0;
      Recoveries : Natural range 0 .. 255 := 0;
      Last_Cause : Natural range 0 .. 255 := 0;
      Readings   : Pair_Array;
   end record;

   function Get (L : Log; S : Slot) return Centi is
     (if S mod 2 = 1 then L.Readings ((S + 1) / 2).Low
      else L.Readings (S / 2).High);

   function Previous (S : Slot) return Slot is
     (if S = 1 then Capacity else S - 1);

   function Latest (L : Log) return Centi is
     (Get (L, Previous (L.Next)));

   --  Add a reading, over the oldest once the log is full. Taken
   --  stops at its largest value.
   procedure Push (L : in out Log; C : Centi)
     with Post => L.Held = Natural'Min (L'Old.Held + 1, Capacity)
                  and then L.Taken
                             = Natural'Min (L'Old.Taken + 1, 65_535)
                  and then Latest (L) = C;

   --  The I-th reading held, oldest first
   function Nth (L : Log; I : Positive) return Centi
     with Pre => I <= L.Held;

   ------------------------------------------------------------------
   --  Packing. Word 0: a mark in the top 16 bits, then Next - 1 and
   --  Held. Words 1 to 6: two readings each, 16-bit two's
   --  complement. Word 7: Taken, Recoveries and Last_Cause.
   ------------------------------------------------------------------
   Mark : constant := 16#5E17#;

   function To_16 (C : Centi) return Word is
     (if C < 0 then Word (C + 65_536) else Word (C));
   function From_16 (W : Word) return Centi is
     (if W mod 65_536 >= 32_768 then Integer (W mod 65_536) - 65_536
      else Integer (W mod 65_536));

   function Unpack (W : Word) return Pair is
     ((Low => From_16 (W), High => From_16 (W / 65_536)));

   function Pack (P : Pair) return Word
     with Post => Unpack (Pack'Result) = P;

   --  Words that hold a log: the mark, and fields in range
   function Valid (W : Words) return Boolean is
     (W (0) / 65_536 = Mark
      and then W (0) / 256 mod 256 < Capacity
      and then W (0) mod 256 <= Capacity);

   function Decode (W : Words) return Log is
     ((Held       => Natural (W (0) mod 256),
       Next       => Natural (W (0) / 256 mod 256) + 1,
       Taken      => Natural (W (7) / 65_536),
       Recoveries => Natural (W (7) / 256 mod 256),
       Last_Cause => Natural (W (7) mod 256),
       Readings   => [for J in Pair_Index => Unpack (W (J))]))
     with Pre => Valid (W);

   function Encode (L : Log) return Words
     with Post => Valid (Encode'Result)
                  and then Decode (Encode'Result) = L;
end Sentinel_Log;
