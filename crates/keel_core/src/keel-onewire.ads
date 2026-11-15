--  SPDX-License-Identifier: Apache-2.0
--  Keel.OneWire: the 1-Wire bus (Analog Devices, formerly Maxim and
--  Dallas). One data line, pulled up, that the controller and the
--  devices pull low; every device has a 64-bit ROM code. This package
--  has the bus's types, its CRC-8, proved against its definition, and
--  the signature a bus driver provides: a reset, and a time slot.
--  Keel.OneWire.Protocol builds bytes, addressing and the ROM search
--  on top; Keel.OneWire.RP2350 runs the slots in a PIO state machine.
package Keel.OneWire
  with Pure, SPARK_Mode
is
   type Byte is mod 2**8;
   type Byte_Array is array (Positive range <>) of Byte;

   --  What can go wrong on the bus: no device answered the reset,
   --  data failed its CRC, or the bus driver did not finish in time
   type Status is (Ok, No_Device, CRC_Error, Timeout);

   ------------------------------------------------------------------
   --  CRC-8 as 1-Wire devices compute it: x**8 + x**5 + x**4 + 1,
   --  each byte least significant bit first, from 0 (AN27). Sent
   --  after the data, the CRC makes the CRC of the whole 0.
   ------------------------------------------------------------------

   --  The definition: one bit at a time, N bits of B into CRC
   function Shift (CRC, B : Byte; N : Natural) return Byte is
     (if N = 0 then CRC
      else Shift ((if (CRC xor B) mod 2 = 1
                   then (CRC / 2) xor 16#8C#
                   else CRC / 2),
                  B / 2, N - 1))
     with Pre                => N <= 8,
          Subprogram_Variant => (Decreases => N);

   function Update (CRC, B : Byte) return Byte is
     (Shift (CRC, B, 8));

   --  The CRC of Data, byte by byte from the left
   function CRC8_Of (Data : Byte_Array) return Byte is
     (if Data'Length = 0 then 0
      else Update (CRC8_Of (Data (Data'First .. Data'Last - 1)),
                   Data (Data'Last)))
     with Ghost,
          Subprogram_Variant => (Decreases => Data'Length);

   --  The CRC as a loop: what a driver runs, proved to match
   function CRC8 (Data : Byte_Array) return Byte
     with Post => CRC8'Result = CRC8_Of (Data);

   ------------------------------------------------------------------
   --  ROM codes: family code, 48-bit serial, CRC, in the order they
   --  cross the bus (least significant byte first)
   ------------------------------------------------------------------
   subtype ROM_Code is Byte_Array (1 .. 8);

   function Family (R : ROM_Code) return Byte is (R (1));

   function Valid (R : ROM_Code) return Boolean is
     (CRC8 (R (1 .. 7)) = R (8));

   --  ROM commands
   Search_ROM : constant Byte := 16#F0#;
   Read_ROM   : constant Byte := 16#33#;
   Match_ROM  : constant Byte := 16#55#;
   Skip_ROM   : constant Byte := 16#CC#;

   ------------------------------------------------------------------
   --  What a bus driver provides
   ------------------------------------------------------------------
   generic
      type Bus (<>) is limited private;
      --  The reset pulse; Present: a device answered it
      with procedure Reset
        (B : in out Bus; Present : out Boolean; Stat : out Status);
      --  One time slot. Writing a 1 lets the line go, so a device may
      --  pull it low: Got is the level sampled, which is a read. A 0
      --  holds it low, and Got is False.
      with procedure Touch
        (B : in out Bus; Bit : Boolean; Got : out Boolean;
         Stat : out Status);
   package Bus_Signature is
      pragma Warnings (Off, Reset);
      pragma Warnings (Off, Touch);
   end Bus_Signature;
end Keel.OneWire;
