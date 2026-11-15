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
