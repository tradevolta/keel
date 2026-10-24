--  RESET_TIMER array
type RESET_TIMER_Field_Array is array (0 .. 1) of Boolean
  with Component_Size => 1, Size => 2;

--  Type definition for RESET_TIMER
type RESET_TIMER_Field
  (As_Array : Boolean := False)
is record
   case As_Array is
      when False =>
         --  TIMER as a value
         Val : RP2350_SVD.UInt2;
      when True =>
         --  TIMER as an array
         Arr : RESET_TIMER_Field_Array;
   end case;
end record
  with Unchecked_Union, Size => 2;

for RESET_TIMER_Field use record
   Val at 0 range 0 .. 1;
   Arr at 0 range 0 .. 1;
end record;
