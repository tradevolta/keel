--  SPDX-License-Identifier: Apache-2.0
--  Keel.OneWire.Protocol: bytes, addressing and the ROM search, on
--  any bus that provides Keel.OneWire.Bus_Signature. Bytes cross the
--  bus least significant bit first. The search is the one in Analog
--  Devices' application note 187: it walks the tree of ROM codes,
--  one bit a level, and each call finds the next device.
generic
   with package Wire is new Bus_Signature (<>);
package Keel.OneWire.Protocol
  with SPARK_Mode
is
   subtype Bus is Wire.Bus;

   procedure Write_Byte
     (B : in out Bus; Value : Byte; Stat : out Status);

   --  Eight read slots
   procedure Read_Byte
     (B : in out Bus; Value : out Byte; Stat : out Status);

   procedure Write
     (B : in out Bus; Data : Byte_Array; Stat : out Status);
   procedure Read
     (B : in out Bus; Data : out Byte_Array; Stat : out Status);

   --  Reset, then address one device (Match ROM) or every device
   --  (Skip ROM). No_Device: nothing answered the reset.
   procedure Select_Device
     (B : in out Bus; ROM : ROM_Code; Stat : out Status);
   procedure Select_All (B : in out Bus; Stat : out Status);

   --  The ROM search. Start with a fresh Search_State and call Next
   --  until Found is False: each call finds one more ROM code, in
   --  order of their bits, least significant first.
   type Search_State is private;
   Fresh_Search : constant Search_State;

   --  Found: ROM is the next device's code, and its CRC is good.
   --  CRC_Error: a code arrived damaged; start again. No_Device:
   --  nothing answered, or the devices stopped answering.
   procedure Next
     (B     : in out Bus;
      S     : in out Search_State;
      ROM   : out ROM_Code;
      Found : out Boolean;
      Stat  : out Status)
     with Post => (if Found then Stat = Ok and then Valid (ROM));

private
   --  The search's place in the tree: the last ROM code found, the
   --  deepest bit where it took the 0 branch with a 1 branch still to
   --  try (0: none), and whether the last code was the last
   subtype Bit_Number is Natural range 0 .. 64;

   type Search_State is record
      Last_ROM         : ROM_Code := [others => 0];
      Last_Discrepancy : Bit_Number := 0;
      Done             : Boolean := False;
   end record;

   Fresh_Search : constant Search_State := (others => <>);
end Keel.OneWire.Protocol;
