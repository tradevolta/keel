type Verdict is
  (Valid, Too_Long, No_Dollar, No_Star, Bad_Hex, Mismatch);

--  The line as received, with its CR LF already removed. Valid:
--  it starts with "$", ends with "*" and two hex digits, and they
--  are the checksum of what lies between.
function Check (Line : String) return Verdict
  with Post =>
    (if Check'Result = Valid
     then Line'Length in 4 .. Max_Length - 2
          and then Line (Line'First) = '$'
          and then Line (Line'Last - 2) = '*'
          and then Is_Hex (Line (Line'Last - 1))
          and then Is_Hex (Line (Line'Last))
          and then Hex_Value (Line (Line'Last - 1)) * 16
                   + Hex_Value (Line (Line'Last))
                   = XOR_Of (Line (Line'First + 1
                                   .. Line'Last - 3)));
