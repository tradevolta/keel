--  SPDX-License-Identifier: Apache-2.0
function Hex (Value : Unsigned_32; Digits_Wanted : Positive)
  return String
is
   Map    : constant String := "0123456789ABCDEF";
   Result : String (1 .. Digits_Wanted);
   V      : Unsigned_32 := Value;
begin
   for D of reverse Result loop
      D := Map (Natural (V and 16#F#) + 1);
      V := Shift_Right (V, 4);
   end loop;
   if Digits_Wanted = 8 then
      return "0x" & Result (1 .. 4) & "_" & Result (5 .. 8);
   end if;
   return "0x" & Result;
end Hex;
