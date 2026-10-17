procedure Put (Text : String) is
   Write : Unsigned_32 := CB.Up.Write_Offset;
   Read : constant Unsigned_32 := CB.Up.Read_Offset;
   Free : constant Unsigned_32 :=
     (if Read > Write then Read - Write - 1
      else Buffer_Size - (Write - Read) - 1);
begin
   if Text'Length > Free then
      Drops := Drops + 1;
      return;
   end if;
   for C of Text loop
      Up_Data (Natural (Write) + 1) := C;
      Write := (Write + 1) mod Buffer_Size;
   end loop;
   Barrier;
   CB.Up.Write_Offset := Write;
end Put;
