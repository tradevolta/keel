--  SPDX-License-Identifier: Apache-2.0
with Interfaces; use Interfaces;

--  Hex (16#7C#, 3) = "0x07C"; Hex (16#116#, 8) = "0x0000_0116"
function Hex (Value : Unsigned_32; Digits_Wanted : Positive)
  return String;
