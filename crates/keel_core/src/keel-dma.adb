--  SPDX-License-Identifier: Apache-2.0
package body Keel.DMA
  with SPARK_Mode
is
   Powers : constant array (Ring_Bits) of Positive :=
     [1, 2, 4, 8, 16, 32, 64, 128, 256, 512, 1_024, 2_048, 4_096,
      8_192, 16_384, 32_768];

   function Ring_Bytes (Bits : Ring_Bits) return Positive is
     (Powers (Bits));

   function Slice (R : Region; First, Bytes : Natural) return Region is
     ((Base   => R.Base + Integer_Address (First),
       Bytes  => Bytes,
       Device => False,
       Loan   => R.Loan));

   --  The bytes a region spans: a register, one
   function Extent (R : Region) return Integer_Address is
     (Integer_Address (Natural'Max (R.Bytes, 1)));

   --  The byte ranges of A and B meet, in the same loan. No_Region
   --  meets nothing.
   function Overlap (A, B : Region) return Boolean is
     (A /= No_Region and then B /= No_Region
      and then A.Loan = B.Loan
      and then A.Base < B.Base + Extent (B)
      and then B.Base < A.Base + Extent (A));

   function Covers (Done : Receipt; R : Region) return Boolean is
     (Overlap (Done.From, R) or else Overlap (Done.To, R));

   function Advance
     (From : Ring_Slot; By : Natural; Slots : Ring_Length)
      return Ring_Slot is
     (if From + By < Slots then From + By else From + By - Slots);

   function Distance (From, To : Ring_Slot; Slots : Ring_Length)
     return Ring_Slot is
     (if To >= From then To - From else To + Slots - From);

   function Back
     (From : Ring_Slot; By : Natural; Slots : Ring_Length)
      return Ring_Slot is
     (if From >= By then From - By else From + Slots - By);
end Keel.DMA;
