--  SPDX-License-Identifier: Apache-2.0
--  A capture, read back from the text the sampler prints (see
--  Capture_Format in the sampler's shared sources). Lines that are
--  not part of a capture, such as the benchmark's, are skipped, so
--  a whole console log can be read; the last complete capture wins.
with Ada.Containers.Vectors;

package Captures is
   --  A 12-bit code, or No_Code where the conversion failed
   subtype Code is Integer range -1 .. 4_095;
   No_Code : constant Code := -1;

   package Code_Vectors is new Ada.Containers.Vectors (Natural, Code);

   type Capture is record
      Rate       : Positive := 1;
      Trigger_At : Natural := 0;
      Level      : Code := 0;
      Rising     : Boolean := True;
      Errors     : Natural := 0;
      Samples    : Code_Vectors.Vector;
   end record;

   --  From a file, or standard input if Name is ""
   procedure Read (Name : String; C : out Capture; Found : out Boolean);

   --  Volts for a code, with 3.3 V full scale
   function Volts (X : Code) return Float is
     (Float (X) * 3.3 / 4_096.0)
     with Pre => X /= No_Code;
end Captures;
