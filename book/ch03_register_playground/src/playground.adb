--  SPDX-License-Identifier: Apache-2.0
--  Chapter 3, part 2: the RP2350 overlays, exercised in host RAM.
with Ada.Text_IO;             use Ada.Text_IO;
with Ada.Unchecked_Conversion;
with Interfaces;              use Interfaces;
with System.Storage_Elements; use System.Storage_Elements;
with RP2350.IO_Bank0;         use RP2350.IO_Bank0;
with RP2350.Pads_Bank0;       use RP2350.Pads_Bank0;
with BE_Frame;                use BE_Frame;
with Dump_Register;
with Hex;

procedure Playground is
   IO   : RP2350.IO_Bank0.Peripheral;   --  host RAM, not hardware;
   Pads : RP2350.Pads_Bank0.Peripheral; --  defaults = reset values
   Ctrl : GPIO_Ctrl renames IO.GPIO (15).Ctrl;
   Pad  : Pad_Control renames Pads.GPIO (15);
   Ctrl_At : constant Natural := Natural (Ctrl'Address - IO'Address);
   Pad_At  : constant Natural := Natural (Pad'Address - Pads'Address);
   Bytes   : Storage_Array (0 .. 3)
     with Import, Address => Ctrl'Address;    --  a byte view of Ctrl

   procedure Dump is new Dump_Register (GPIO_Ctrl, "GPIO15_CTRL");
   procedure Dump is new Dump_Register (Pad_Control, "GPIO15 pad ");
   function To_Reading is
     new Ada.Unchecked_Conversion (Wire_Bytes, Raw_Reading);
begin
   Put_Line ("-- after reset");
   Dump (Ctrl, Ctrl_At);
   Dump (Pad, Pad_At);

   Put_Line ("-- GP15 as a software-controlled output");
   Ctrl := (Funcsel => SIO, others => <>);
   Pad  := (Pad with delta Isolate => False);
   Dump (Ctrl, Ctrl_At);
   Dump (Pad, Pad_At);
   Put_Line ("FUNCSEL = " & Ctrl.Funcsel'Image);
   Put ("bytes at +0x07C:");
   for B of Bytes loop
      Put (" " & Hex (Unsigned_32 (B), 2));
   end loop;
   New_Line;
   Put_Line ("-- big-endian 01 9A reads as"
             & To_Reading ([16#01#, 16#9A#]).Value'Image);
end Playground;
