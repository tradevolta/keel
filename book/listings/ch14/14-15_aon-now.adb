function Now return Epoch_Ms is
   Hi : UInt32 := Words.Read (Words.READ_TIME_UPPER);
   Lo, Hi_Again : UInt32;
   V : Unsigned_64;
begin
   loop
      Lo := Words.Read (Words.READ_TIME_LOWER);
      Hi_Again := Words.Read (Words.READ_TIME_UPPER);
      exit when Hi_Again = Hi;
      Hi := Hi_Again;
   end loop;
   V := Shift_Left (Unsigned_64 (Hi), 32) or Unsigned_64 (Lo);
   return Epoch_Ms
     (Unsigned_64'Min (V, Unsigned_64 (Epoch_Ms'Last)));
end Now;
