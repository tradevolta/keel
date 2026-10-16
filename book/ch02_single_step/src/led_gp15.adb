--  SPDX-License-Identifier: Apache-2.0
with System.Storage_Elements; use System.Storage_Elements;

package body LED_GP15 is

   type Register is mod 2**32
     with Size => 32, Volatile_Full_Access;

   Reset_Clear : Register
     with Import, Address => To_Address (16#4002_3000#);
   Reset_Done  : Register
     with Import, Volatile, Address => To_Address (16#4002_0008#);
   GPIO15_Ctrl : Register
     with Import, Address => To_Address (16#4002_807C#);
   GPIO15_Pad  : Register
     with Import, Address => To_Address (16#4003_8040#);
   Out_XOR     : Register
     with Import, Address => To_Address (16#D000_0028#);
   OE_Set      : Register
     with Import, Address => To_Address (16#D000_0038#);

   IO_Bank0   : constant Register := 2**6;
   Pads_Bank0 : constant Register := 2**9;
   Pad_ISO    : constant Register := 2**8;
   Pad_IE     : constant Register := 2**6;
   Func_SIO   : constant Register := 5;
   LED        : constant Register := 2**15;

   procedure Init is
   begin
      Reset_Clear := IO_Bank0 or Pads_Bank0;
      while (Reset_Done and (IO_Bank0 or Pads_Bank0))
        /= (IO_Bank0 or Pads_Bank0)
      loop
         null;
      end loop;
      GPIO15_Ctrl := Func_SIO;
      GPIO15_Pad  := (GPIO15_Pad and not Pad_ISO) or Pad_IE;
      OE_Set      := LED;
   end Init;

   procedure Toggle is
   begin
      Out_XOR := LED;
   end Toggle;

end LED_GP15;
