procedure Check (B : Board) is
   function Has (Name : String) return Boolean is
     (for some R of B.Regions => R.Name = Name);
   Stack : Region renames B.Regions (B.Stack_Region);
begin
   if not (Has ("flash") and then Has ("sram")) then
      raise Map_Error with "needs regions named flash and sram";
   end if;

   for I in B.Regions'Range loop
      if B.Regions (I).Origin mod 4 /= 0
        or else B.Regions (I).Size mod 4 /= 0
      then
         raise Map_Error with To_String (B.Regions (I).Name)
           & " is not word-aligned";
      end if;
      for J in I + 1 .. B.Regions'Last loop
         if Overlap (B.Regions (I), B.Regions (J)) then
            raise Map_Error with To_String (B.Regions (I).Name)
              & " overlaps " & To_String (B.Regions (J).Name);
         end if;
      end loop;
   end loop;

   if B.Stack_Size mod 8 /= 0 then
      raise Map_Error with "the stack size is not a multiple of 8";
   elsif B.Stack_Size > Stack.Size then
      raise Map_Error with "a stack of " & Image (B.Stack_Size)
        & " does not fit in " & To_String (Stack.Name)
        & " (" & Image (Stack.Size) & ")";
   end if;
end Check;
