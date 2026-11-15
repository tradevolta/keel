--  SPDX-License-Identifier: Apache-2.0
with System.Storage_Elements; use System.Storage_Elements;

package body Keel.DMA.Fake
  with SPARK_Mode => Off
is
   procedure Run
     (From, To : Region; Size : Element_Size; N : Count;
      Wrap : Ring_Bits; Done : out Receipt)
   is
      Step     : constant Integer_Address :=
        Integer_Address (Bytes (Size));
      Ring_End : constant Integer_Address :=
        To.Base + Integer_Address (To.Bytes);
      Read     : Integer_Address := From.Base;
      Write    : Integer_Address := To.Base;
   begin
      for I in 1 .. N loop
         declare
            Src : Storage_Array (1 .. Storage_Offset (Step))
              with Import, Address => To_Address (Read);
            Dst : Storage_Array (1 .. Storage_Offset (Step))
              with Import, Address => To_Address (Write);
         begin
            Dst := Src;
         end;
         if not From.Device then
            Read := Read + Step;
         end if;
         if not To.Device then
            Write := Write + Step;
            if Wrap > 0 and then Write = Ring_End then
               Write := To.Base;
            end if;
         end if;
      end loop;
      Done := (From => From, To => To, Done => N);
   end Run;
end Keel.DMA.Fake;
