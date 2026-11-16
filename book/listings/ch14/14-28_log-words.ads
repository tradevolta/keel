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
