--  5. Paint the stack below this frame, for Stack_Never_Used.
declare
   Free : constant Storage_Count :=
     (Stack_Pointer - Stack_Start'Address) / 4;
   Below : Word_Array (1 .. Free)
     with Import, Volatile, Address => Stack_Start'Address;
begin
   for I in Below'Range loop
      Below (I) := Stack_Pattern;
   end loop;
end;
