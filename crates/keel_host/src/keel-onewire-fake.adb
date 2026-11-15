--  SPDX-License-Identifier: Apache-2.0
package body Keel.OneWire.Fake is

   --  Bit N (0 to 63) of a ROM code, in bus order
   function ROM_Bit (R : ROM_Code; N : Natural) return Boolean is
     (R (N / 8 + 1) / 2**(N mod 8) mod 2 = 1);

   function Pad_Bit (D : Device; N : Natural) return Boolean is
     (D.Sent (N / 8 + 1) / 2**(N mod 8) mod 2 = 1);

   --  The power-on scratchpad: +85 degrees C, alarm limits 75 and
   --  70, 12 bits; the fake fills the reserved bytes with FF 0C 10
   procedure Init_Pad (D : in out Device) is
   begin
      D.Pad := [16#50#, 16#05#, 16#4B#, 16#46#, 16#7F#, 16#FF#,
                16#0C#, 16#10#, 0];
      D.Pad (9) := CRC8 (D.Pad (1 .. 8));
   end Init_Pad;

   procedure Attach (B : in out Bus; ROM : ROM_Code; Raw : Integer) is
   begin
      B.Count := B.Count + 1;
      B.Devices (B.Count).ROM := ROM;
      B.Devices (B.Count).Raw := Raw;
      Init_Pad (B.Devices (B.Count));
   end Attach;

   procedure Set_Temperature
     (B : in out Bus; ROM : ROM_Code; Raw : Integer)
   is
   begin
      for D of B.Devices (1 .. B.Count) loop
         if D.ROM = ROM then
            D.Raw := Raw;
         end if;
      end loop;
   end Set_Temperature;

   procedure Corrupt_Next_Byte (B : in out Bus) is
   begin
      B.Corrupt := True;
   end Corrupt_Next_Byte;

   procedure Short_To_Ground (B : in out Bus) is
   begin
      B.Shorted := True;
   end Short_To_Ground;

   procedure Reset
     (B : in out Bus; Present : out Boolean; Stat : out Status)
   is
   begin
      B.Resets := B.Resets + 1;
      for D of B.Devices (1 .. B.Count) loop
         D.State := ROM_Command;
         D.Bit_No := 0;
         D.Shifted := 0;
      end loop;
      Present := B.Count > 0 or else B.Shorted;
      Stat := Ok;
   end Reset;

   --  What device D drives in this slot: its bit, or True (let go)
   function Drives (D : Device) return Boolean is
     (case D.State is
        when Search_Bit        => ROM_Bit (D.ROM, D.Bit_No),
        when Search_Complement => not ROM_Bit (D.ROM, D.Bit_No),
        when Sending           => Pad_Bit (D, D.Bit_No),
        when others            => True);

   --  Device D has seen Line in a slot it did not drive
   procedure Receive (D : in out Device; Line : Boolean) is
   begin
      D.Shifted := D.Shifted / 2 + (if Line then 128 else 0);
      D.Bit_No := D.Bit_No + 1;
   end Receive;

   procedure Step (D : in out Device; Line : Boolean) is
   begin
      case D.State is
         when Idle =>
            null;
         when ROM_Command =>
            Receive (D, Line);
            if D.Bit_No = 8 then
               D.Bit_No := 0;
               D.State :=
                 (case D.Shifted is
                    when Search_ROM => Search_Bit,
                    when Match_ROM  => Matching,
                    when Skip_ROM   => Function_Command,
                    when others     => Idle);
               D.Shifted := 0;
            end if;
         when Search_Bit =>
            D.State := Search_Complement;
         when Search_Complement =>
            D.State := Search_Choice;
         when Search_Choice | Matching =>
            --  The controller's bit: a device whose own differs
            --  drops out until the next reset
            if Line /= ROM_Bit (D.ROM, D.Bit_No) then
               D.State := Idle;
            elsif D.Bit_No = 63 then
               D.State := Function_Command;
               D.Bit_No := 0;
            else
               D.Bit_No := D.Bit_No + 1;
               if D.State = Search_Choice then
                  D.State := Search_Bit;
               end if;
            end if;
         when Function_Command =>
            Receive (D, Line);
            if D.Bit_No = 8 then
               D.Bit_No := 0;
               case D.Shifted is
                  when 16#44# =>
                     --  Convert T: done at once in the fake
                     --  Two's complement, least significant byte
                     --  first
                     D.Pad (1) := Byte (D.Raw mod 2**16 mod 256);
                     D.Pad (2) := Byte (D.Raw mod 2**16 / 256);
                     D.Pad (9) := CRC8 (D.Pad (1 .. 8));
                     D.State := Idle;
                  when 16#BE# =>
                     D.Sent := D.Pad;
                     D.State := Sending;
                  when others =>
                     D.State := Idle;
               end case;
               D.Shifted := 0;
            end if;
         when Sending =>
            D.Bit_No := D.Bit_No + 1;
            if D.Bit_No = 72 then
               D.State := Idle;
            end if;
      end case;
   end Step;

   procedure Touch
     (B : in out Bus; Bit : Boolean; Got : out Boolean;
      Stat : out Status)
   is
      Line : Boolean := Bit and then not B.Shorted;
   begin
      B.Slots := B.Slots + 1;
      for D of B.Devices (1 .. B.Count) loop
         if D.State = Sending and then D.Bit_No mod 8 = 0
           and then B.Corrupt
         then
            D.Sent (D.Bit_No / 8 + 1) :=
              D.Sent (D.Bit_No / 8 + 1) xor 4;
            B.Corrupt := False;
         end if;
         Line := Line and Drives (D);
      end loop;
      for D of B.Devices (1 .. B.Count) loop
         Step (D, Line);
      end loop;
      Got := Line;
      Stat := Ok;
   end Touch;

   function Slots (B : Bus) return Natural is (B.Slots);
   function Resets (B : Bus) return Natural is (B.Resets);
end Keel.OneWire.Fake;
