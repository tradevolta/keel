type Raw_Reading is record
   Value : Unsigned_16;
end record
  with Bit_Order => System.High_Order_First,
       Scalar_Storage_Order => System.High_Order_First,
       Size => 16;

for Raw_Reading use record
   Value at 0 range 0 .. 15;
end record;
