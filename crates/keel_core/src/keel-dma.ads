--  SPDX-License-Identifier: Apache-2.0
--  Keel.DMA: what a DMA transfer is, on any chip. A transfer moves
--  Count elements of one size from a source to a destination. Each
--  end is a peripheral's data register, which stays put, or a
--  region of RAM, which the transfer walks through and, in a ring,
--  goes round. A program can't make a region of RAM itself: it lends
--  a buffer (Keel.DMA.Buffers) and gets one back, and it gets the
--  buffer back only with the receipt a driver gives when the
--  transfer is over.
with System;
with System.Storage_Elements; use System.Storage_Elements;

package Keel.DMA
  with Pure, SPARK_Mode
is
   type Element_Size is (Byte, Half_Word, Word);

   function Bytes (S : Element_Size) return Positive is
     (case S is when Byte => 1, when Half_Word => 2, when Word => 4);

   --  Elements in one transfer: the RP2350's TRANS_COUNT has 28 bits
   subtype Count is Natural range 0 .. 2**28 - 1;

   --  A ring of 2**Bits bytes, from 2 bytes to 32 KB; 0: no ring
   subtype Ring_Bits is Natural range 0 .. 15;

   function Ring_Bytes (Bits : Ring_Bits) return Positive
     with Post => Ring_Bytes'Result <= 2**15;

   --  One end of a transfer
   type Region is private;
   No_Region : constant Region;

   function Start (R : Region) return Integer_Address;
   function Address_Of (R : Region) return System.Address;
   --  In bytes. A register has none: the transfer doesn't move on.
   function Length (R : Region) return Natural;
   function Is_Register (R : Region) return Boolean;

   --  A peripheral's data register, such as the ADC's FIFO
   function Register (A : System.Address) return Region
     with Post => Is_Register (Register'Result)
                  and then Length (Register'Result) = 0;

   --  The start is a whole number of elements of Size
   function Aligned (R : Region; Size : Element_Size) return Boolean is
     (Start (R) mod Integer_Address (Bytes (Size)) = 0);

   --  Bytes First .. First + Bytes - 1 of a region of RAM
   function Slice (R : Region; First, Bytes : Natural) return Region
     with Pre  => not Is_Register (R)
                  and then First <= Length (R)
                  and then Bytes <= Length (R) - First,
          Post => not Is_Register (Slice'Result)
                  and then Length (Slice'Result) = Bytes;

   --  A transfer's end in RAM can take Count elements of Size: they
   --  fit in R from its start, or, with a ring of 2**Wrap bytes, R is
   --  that ring exactly and starts on a multiple of its size
   function Fits
     (R : Region; Size : Element_Size; N : Count; Wrap : Ring_Bits)
      return Boolean
   is
     (not Is_Register (R)
      and then Aligned (R, Size)
      and then
        (if Wrap = 0 then N <= Length (R) / Bytes (Size)
         else Length (R) = Ring_Bytes (Wrap)
              and then Ring_Bytes (Wrap) >= Bytes (Size)
              and then Start (R) mod Integer_Address (Length (R)) = 0));

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
private
   --  Loan: which lending of a buffer this is. A receipt for an
   --  earlier loan of the same buffer doesn't cover a later one.
   type Loan_Number is mod 2**32;

   type Region is record
      Base   : Integer_Address := 0;
      Bytes  : Natural := 0;
      Device : Boolean := False;
      Loan   : Loan_Number := 0;
   end record;

   No_Region : constant Region := (others => <>);

   function Start (R : Region) return Integer_Address is (R.Base);
   function Address_Of (R : Region) return System.Address is
     (To_Address (R.Base));
   function Length (R : Region) return Natural is (R.Bytes);
   function Is_Register (R : Region) return Boolean is (R.Device);

   function Register (A : System.Address) return Region is
     ((Base => To_Integer (A), Bytes => 0, Device => True, Loan => 0));

   type Receipt is record
      From, To : Region := No_Region;
      Done     : Count := 0;
   end record;

   function Moved (Done : Receipt) return Count is (Done.Done);
end Keel.DMA;
