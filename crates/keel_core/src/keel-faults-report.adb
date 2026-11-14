--  SPDX-License-Identifier: Apache-2.0
procedure Keel.Faults.Report
  (CFSR, HFSR, MMFAR, BFAR : Word; Frame : Stacked_Frame)
is
   --  16#E000_ED28#, the way Keel writes addresses
   function Hex (W : Word) return String is
      Digits_Of : constant String := "0123456789ABCDEF";
      S : String (1 .. 13) := "16#0000_0000#";
      V : Word := W;
      P : Positive := 12;
   begin
      for I in 1 .. 8 loop
         if S (P) = '_' then
            P := P - 1;
         end if;
         S (P) := Digits_Of (Natural (V and 16#F#) + 1);
         V := Shift_Right (V, 4);
         P := P - 1;
      end loop;
      return S;
   end Hex;
begin
   Put_Line ("*** HardFault ***");
   Put_Line ("CFSR  " & Hex (CFSR));
   Put_Line ("HFSR  " & Hex (HFSR));
   for C in Cause loop
      if Present (CFSR, HFSR, C) then
         Put_Line ("  " & C'Image & ": " & Meaning (C));
      end if;
   end loop;
   if Present (CFSR, HFSR, MMARVALID) then
      Put_Line ("MMFAR " & Hex (MMFAR));
   end if;
   if Present (CFSR, HFSR, BFARVALID) then
      Put_Line ("BFAR  " & Hex (BFAR));
   end if;
   Put_Line ("PC    " & Hex (Frame.PC));
   Put_Line ("LR    " & Hex (Frame.LR));
   Put_Line ("xPSR  " & Hex (Frame.xPSR));
end Keel.Faults.Report;
