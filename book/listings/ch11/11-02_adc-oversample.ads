--  2**N, from a table: the prover reads a table more easily
--  than a power with a variable exponent
subtype Power is Positive range 1 .. 2**20;
function Two_To (N : Natural) return Power
  with Pre => N <= 20;

--  The largest raw code
function Top (S : Scale) return Code is (Two_To (S.Bits) - 1);

--  The samples to add up for K extra bits: 4**K
subtype Sample_Count is Positive range 1 .. 256;
function Samples_For (K : Extra_Bits) return Sample_Count is
  (Two_To (2 * K));

--  The largest code with K extra bits
function Top (S : Scale; K : Extra_Bits) return Code is
  (Two_To (S.Bits + K) - 1);

--  A sum of Samples_For (K) raw codes as one code with K extra
--  bits: the sum divided by 2**K, rounded down, and never above
--  Top (S, K)
function Oversample (S : Scale; Total : Natural; K : Extra_Bits)
  return Code
  with Post => Oversample'Result <= Top (S, K);
