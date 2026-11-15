--  SPDX-License-Identifier: Apache-2.0
--  Keel.DMA.Buffers: a buffer that the program and the DMA take
--  turns to own. The program reads and writes it while it holds it;
--  Lend hands it to the DMA as a region for a transfer, and Reclaim
--  takes it back, but only with the receipt for a transfer that
--  used it. The contracts say who holds it. GNATprove checks them
--  in SPARK code, and the Assertion_Policy below keeps them checked
--  at run time everywhere else: one comparison per call.
generic
   --  8, 16 or 32 bits: the size of one transfer
   type Element is mod <>;
   Elements : Positive;
package Keel.DMA.Buffers
  with SPARK_Mode
is
   --  Inside the generic, so that every instance has it: a pragma
   --  before "generic" covers only this file, not the instances
   pragma Assertion_Policy (Pre => Check);

   pragma Compile_Time_Error
     (Element'Size /= 8 and then Element'Size /= 16
      and then Element'Size /= 32,
      "a DMA element has 8, 16 or 32 bits");

   subtype Index is Natural range 0 .. Elements - 1;

   type Holder is (Program, Engine);

   type Buffer is limited private
     with Default_Initial_Condition => Owner (Buffer) = Program;

   function Owner (B : Buffer) return Holder;

   function Size return Element_Size is
     (if Element'Size = 8 then Byte
      elsif Element'Size = 16 then Half_Word else Word);

   --  The region B is lent as, while the DMA holds it
   function Lent (B : Buffer) return Region;

   function Get (B : Buffer; I : Index) return Element
     with Pre => Owner (B) = Program;

   procedure Put (B : in out Buffer; I : Index; E : Element)
     with Pre  => Owner (B) = Program,
          Post => Owner (B) = Program and then Get (B, I) = E;

   procedure Fill (B : in out Buffer; E : Element)
     with Pre  => Owner (B) = Program,
          Post => Owner (B) = Program
                  and then (for all I in Index => Get (B, I) = E);

   --  To := From, element for element, by the processor
   procedure Copy (From : Buffer; To : in out Buffer)
     with Pre  => Owner (From) = Program and then Owner (To) = Program,
          Post => Owner (To) = Program
                  and then (for all I in Index =>
                              Get (To, I) = Get (From, I));

   --  Hand B to the DMA. R is all of it, for a transfer's end.
   procedure Lend (B : in out Buffer; R : out Region)
     with Pre  => Owner (B) = Program,
          Post => Owner (B) = Engine and then Lent (B) = R
                  and then not Is_Register (R)
                  and then Aligned (R, Size)
                  and then Length (R) = Elements * Bytes (Size);

   --  Take B back. Done is the receipt of a transfer that used it:
   --  from a driver's Wait or Stop. What B holds now is whatever the
   --  DMA left in it.
   procedure Reclaim (B : in out Buffer; Done : Receipt)
     with Pre  => Owner (B) = Engine and then Covers (Done, Lent (B)),
          Post => Owner (B) = Program;

   --  Read slot I while the DMA holds B. Only for a slot that the
   --  transfer has finished with and won't come back to before the
   --  value is used: a ring's settled half. Timing is the caller's
   --  to get right; the driver can tell it when it fell behind.
   function Peek (B : Buffer; I : Index) return Element
     with Pre => Owner (B) = Engine;
private
   type Element_Array is array (Index) of Element;

   --  Data first, so that an object's Alignment is the data's
   type Buffer is limited record
      Data  : Element_Array := [others => 0];
      Who   : Holder := Program;
      Where : Region := No_Region;
      Loans : Loan_Number := 0;
   end record;

   function Owner (B : Buffer) return Holder is (B.Who);
   function Lent (B : Buffer) return Region is (B.Where);
   function Get (B : Buffer; I : Index) return Element is (B.Data (I));
end Keel.DMA.Buffers;
