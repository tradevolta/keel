procedure Feed (Ed : in out Editor; C : Character; Act : out Action)
is
   After_CR : constant Boolean := Ed.Last_CR;
begin
   Ed.Last_CR := C = CR;
   Act := Nothing;

   --  Inside an escape sequence, nothing reaches the line
   case Ed.Escape is
      when After_ESC =>
         Ed.Escape := (if C = '[' then In_CSI else Plain);
         return;
      when In_CSI =>
         if C in '@' .. '~' then
            Ed.Escape := Plain;
         end if;
         return;
      when Plain =>
         null;
   end case;

   if C in ' ' .. '~' then
      if Ed.Last < Max_Line then
         Ed.Last := Ed.Last + 1;
         Ed.Buffer (Ed.Last) := C;
         Act := Echo;
      else
         Act := Ring;
      end if;
   elsif C = BS or else C = DEL then
      if Ed.Last > 0 then
         Ed.Last := Ed.Last - 1;
         Act := Rub_Out;
      end if;
   elsif C = CR or else (C = LF and then not After_CR) then
      Ed.Done := True;
      Act := Line_End;
   elsif C = Ctrl_C or else C = Ctrl_U then
      Ed.Last := 0;
      Act := Cancel;
   elsif C = ESC then
      Ed.Escape := After_ESC;
   end if;
end Feed;
