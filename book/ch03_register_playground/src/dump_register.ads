--  SPDX-License-Identifier: Apache-2.0
--  A generic: one body, instantiated once per register type.
generic
   type Register is private;        --  formal type: any record ...
   Name : String;                   --  formal object
procedure Dump_Register (Value : Register; Offset : Natural)
  with Pre => Register'Size = 32;   --  ... that is 32 bits wide
