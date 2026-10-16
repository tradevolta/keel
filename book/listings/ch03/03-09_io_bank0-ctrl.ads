   type GPIO_Ctrl is record  --  defaults = reset values
      Funcsel : Function_Select := None;
      Reserved_5_11 : UInt7 := 0;
      Outover : Override := Normal;
      Oeover : OE_Override := Normal;
      Inover : Override := Normal;
      Reserved_18_27 : UInt10 := 0;
      Irqover : Override := Normal;
      Reserved_30_31 : UInt2 := 0;
   end record
     with Size => 32,
          Bit_Order => System.Low_Order_First,
          Volatile_Full_Access;

   for GPIO_Ctrl use record
      Funcsel        at 0 range  0 ..  4;
      Reserved_5_11  at 0 range  5 .. 11;
      Outover        at 0 range 12 .. 13;
      Oeover         at 0 range 14 .. 15;
      Inover         at 0 range 16 .. 17;
      Reserved_18_27 at 0 range 18 .. 27;
      Irqover        at 0 range 28 .. 29;
      Reserved_30_31 at 0 range 30 .. 31;
   end record;

   --  STATUS is read-only and left raw in this chapter.
   type GPIO_Pair is record
      Status : Register;
      Ctrl   : GPIO_Ctrl;
   end record
     with Size => 64;

   for GPIO_Pair use record
      Status at 0 range 0 .. 31;
      Ctrl   at 4 range 0 .. 31;
   end record;

   type GPIO_Array is array (Pin_Id) of GPIO_Pair
     with Component_Size => 64;

   --  Offsets 0x000 .. 0x17C only.
   type Peripheral is record
      GPIO : GPIO_Array;
   end record;
end RP2350.IO_Bank0;
