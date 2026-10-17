--  SEGGER_RTT_BUFFER_UP and _DOWN from SEGGER_RTT.h. The probe
--  writes Read_Offset of an up buffer; the target writes the rest.
type Ring is record
   Name : System.Address;
   Buffer : System.Address;
   Size : Unsigned_32;
   Write_Offset : Unsigned_32;
   Read_Offset : Unsigned_32;
   Flags : Unsigned_32;
end record
  with Convention => C;

subtype ID_String is String (1 .. 16);

--  SEGGER_RTT_CB with one up and one down channel
type Control_Block is record
   ID : ID_String;
   Max_Up : Integer_32;
   Max_Down : Integer_32;
   Up : Ring;
   Down : Ring;
end record
  with Convention => C;

CB : Control_Block
  with Volatile, Export, Convention => C,
       External_Name => "_SEGGER_RTT";

--  SEGGER_RTT.h on a 32-bit target: 24 bytes per buffer and 72
--  for the block, so nothing between the components is padding
pragma Compile_Time_Error
  (System.Address'Size = 32
   and then (Ring'Size /= 24 * 8
             or else Control_Block'Size /= 72 * 8),
   "Control_Block does not match SEGGER_RTT_CB");
