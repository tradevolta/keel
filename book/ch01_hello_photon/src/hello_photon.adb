--  SPDX-License-Identifier: Apache-2.0
--  Hello, Photon: blink an external LED on GP15 at 2 Hz.
--  Raw register writes for now; Keel replaces them from Chapter 5.
with Ada.Real_Time; use Ada.Real_Time;
with System.Storage_Elements; use System.Storage_Elements;

procedure Hello_Photon is
   type Register is mod 2**32
     with Size => 32, Volatile_Full_Access;

   --  RESETS: write 1s to the atomic-clear alias (+16#3000#)
   Reset_Clear : Register
     with Import, Address => To_Address (16#4002_3000#);
   Reset_Done  : Register
     with Import, Volatile, Address => To_Address (16#4002_0008#);

   GPIO15_Ctrl : Register   --  IO_BANK0
     with Import, Address => To_Address (16#4002_807C#);
   GPIO15_Pad  : Register   --  PADS_BANK0
     with Import, Address => To_Address (16#4003_8040#);
   Out_XOR     : Register   --  SIO GPIO_OUT_XOR
     with Import, Address => To_Address (16#D000_0028#);
   OE_Set      : Register   --  SIO GPIO_OE_SET
     with Import, Address => To_Address (16#D000_0038#);

   IO_Bank0   : constant Register := 2**6;
   Pads_Bank0 : constant Register := 2**9;
   Pad_ISO    : constant Register := 2**8;
   Pad_IE     : constant Register := 2**6;
   Func_SIO   : constant Register := 5;
   LED        : constant Register := 2**15;

   Half_Period : constant Time_Span := Milliseconds (250);
   Next        : Time := Clock;
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

   loop
      Out_XOR := LED;
      Next := Next + Half_Period;
      delay until Next;
   end loop;
end Hello_Photon;
