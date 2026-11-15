--  SPDX-License-Identifier: Apache-2.0
--  Keel.OneWire.Fake: a 1-Wire bus for tests on the host, with
--  simulated DS18B20s on it. It works slot by slot, as the wire does:
--  in each slot every device drives its bit or lets go, and the line
--  is the AND of them all and the controller's. So the ROM search,
--  Match ROM and a scratchpad read run the same code as on a board.
--  It has no timing: a slot is a call.
package Keel.OneWire.Fake is
   Max_Devices : constant := 4;

   type Bus is limited private;

   --  Put a DS18B20 with this ROM code on the bus; its temperature,
   --  in sixteenths of a degree, is what the next conversion reads
   procedure Attach (B : in out Bus; ROM : ROM_Code; Raw : Integer)
     with Pre => Raw in -2**15 .. 2**15 - 1;

   procedure Set_Temperature
     (B : in out Bus; ROM : ROM_Code; Raw : Integer)
     with Pre => Raw in -2**15 .. 2**15 - 1;

   --  Flip one bit of the next byte a device sends
   procedure Corrupt_Next_Byte (B : in out Bus);

   --  Short the line to ground: every reset then sees a presence
   --  pulse, and every slot reads 0
   procedure Short_To_Ground (B : in out Bus);

   --  The bus driver's side: Keel.OneWire.Bus_Signature
   procedure Reset
     (B : in out Bus; Present : out Boolean; Stat : out Status);
   procedure Touch
     (B : in out Bus; Bit : Boolean; Got : out Boolean;
      Stat : out Status);

   --  Slots and resets since the bus was made: the time a real bus
   --  would take, at 70 us a slot and 962 us a reset
   function Slots (B : Bus) return Natural;
   function Resets (B : Bus) return Natural;

private
   type Phase is
     (Idle, ROM_Command, Search_Bit, Search_Complement, Search_Choice,
      Matching, Function_Command, Sending);

   type Device is record
      ROM     : ROM_Code := [others => 0];
      Raw     : Integer := 16#0550#;
      Pad     : Byte_Array (1 .. 9) := [others => 0];
      --  The scratchpad as it goes out, which a test may damage
      Sent    : Byte_Array (1 .. 9) := [others => 0];
      State   : Phase := Idle;
      Bit_No  : Natural := 0;
      Shifted : Byte := 0;
   end record;

   type Device_Array is array (1 .. Max_Devices) of Device;

   type Bus is limited record
      Devices : Device_Array;
      Count   : Natural := 0;
      Corrupt : Boolean := False;
      Shorted : Boolean := False;
      Slots   : Natural := 0;
      Resets  : Natural := 0;
   end record;
end Keel.OneWire.Fake;
