function Stack_Size return Storage_Count is
  (Stack_End'Address - Stack_Start'Address);

function Stack_Never_Used return Storage_Count is
   Stack : Word_Array (1 .. Stack_Size / 4)
     with Import, Volatile, Address => Stack_Start'Address;
begin
   for I in Stack'Range loop
      if Stack (I) /= Stack_Pattern then
         return (I - 1) * 4;
      end if;
   end loop;
   return Stack_Size;
end Stack_Never_Used;
