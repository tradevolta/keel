--  SPDX-License-Identifier: Apache-2.0
--  Two bytes from a sensor, most significant byte first, read on a
--  little-endian CPU. GNAT swaps the bytes on every access.
with Interfaces; use Interfaces;
with System;

package BE_Frame
  with Pure
is
   type Raw_Reading is record
      Value : Unsigned_16;
   end record
     with Bit_Order            => System.High_Order_First,
          Scalar_Storage_Order => System.High_Order_First,
          Size                 => 16;

   for Raw_Reading use record
      Value at 0 range 0 .. 15;
   end record;

   type Wire_Bytes is array (1 .. 2) of Unsigned_8
     with Size => 16;               --  in the order they arrive
end BE_Frame;
