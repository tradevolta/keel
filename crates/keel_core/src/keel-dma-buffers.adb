--  SPDX-License-Identifier: Apache-2.0
package body Keel.DMA.Buffers
  with SPARK_Mode
is
   procedure Put (B : in out Buffer; I : Index; E : Element) is
   begin
      B.Data (I) := E;
   end Put;

   procedure Fill (B : in out Buffer; E : Element) is
   begin
      B.Data := [others => E];
   end Fill;

   procedure Copy (From : Buffer; To : in out Buffer) is
   begin
      To.Data := From.Data;
   end Copy;

   procedure Lend (B : in out Buffer; R : out Region)
     with SPARK_Mode => Off
   is
   begin
      --  A new loan number: no earlier receipt covers this loan
      B.Loans := B.Loans + 1;
      R := (Base   => To_Integer (B.Data'Address),
            Bytes  => Elements * Bytes (Size),
            Device => False,
            Loan   => B.Loans);
      B.Where := R;
      B.Who := Engine;
   end Lend;

   procedure Reclaim (B : in out Buffer; Done : Receipt) is
   begin
      pragma Unreferenced (Done);
      B.Where := No_Region;
      B.Who := Program;
   end Reclaim;

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
end Keel.DMA.Buffers;
