--  SPDX-License-Identifier: Apache-2.0
package body Keel.OneWire.Protocol
  with SPARK_Mode
is
   procedure Write_Byte
     (B : in out Bus; Value : Byte; Stat : out Status)
   is
      V   : Byte := Value;
      Got : Boolean;
   begin
      for N in 1 .. 8 loop
         Wire.Touch (B, V mod 2 = 1, Got, Stat);
         exit when Stat /= Ok;
         V := V / 2;
      end loop;
   end Write_Byte;

   procedure Read_Byte
     (B : in out Bus; Value : out Byte; Stat : out Status)
   is
      Got : Boolean;
   begin
      Value := 0;
      for N in 0 .. 7 loop
         Wire.Touch (B, True, Got, Stat);
         exit when Stat /= Ok;
         if Got then
            Value := Value or 2**N;
         end if;
      end loop;
   end Read_Byte;

   procedure Write
     (B : in out Bus; Data : Byte_Array; Stat : out Status)
   is
   begin
      Stat := Ok;
      for D of Data loop
         Write_Byte (B, D, Stat);
         exit when Stat /= Ok;
      end loop;
   end Write;

   procedure Read
     (B : in out Bus; Data : out Byte_Array; Stat : out Status)
   is
   begin
      Data := [others => 0];
      Stat := Ok;
      for I in Data'Range loop
         Read_Byte (B, Data (I), Stat);
         exit when Stat /= Ok;
      end loop;
   end Read;

   --  A reset; No_Device if nothing answered
   procedure Reset (B : in out Bus; Stat : out Status) is
      Present : Boolean;
   begin
      Wire.Reset (B, Present, Stat);
      if Stat = Ok and then not Present then
         Stat := No_Device;
      end if;
   end Reset;

   procedure Select_Device
     (B : in out Bus; ROM : ROM_Code; Stat : out Status) is
   begin
      Reset (B, Stat);
      if Stat = Ok then
         Write_Byte (B, Match_ROM, Stat);
      end if;
      if Stat = Ok then
         Write (B, ROM, Stat);
      end if;
   end Select_Device;

   procedure Select_All (B : in out Bus; Stat : out Status) is
   begin
      Reset (B, Stat);
      if Stat = Ok then
         Write_Byte (B, Skip_ROM, Stat);
      end if;
   end Select_All;

   --  Bit N (1 to 64) of a ROM code, as it crosses the bus
   function Bit (R : ROM_Code; N : Positive) return Boolean is
     (R ((N - 1) / 8 + 1) / 2**((N - 1) mod 8) mod 2 = 1)
     with Pre => N <= 64;

   procedure Set_Bit (R : in out ROM_Code; N : Positive; To : Boolean)
     with Pre => N <= 64
   is
      I    : constant Positive := (N - 1) / 8 + 1;
      Mask : constant Byte := 2**((N - 1) mod 8);
   begin
      R (I) := (if To then R (I) or Mask else R (I) and not Mask);
   end Set_Bit;

   procedure Next
     (B     : in out Bus;
      S     : in out Search_State;
      ROM   : out ROM_Code;
      Found : out Boolean;
      Stat  : out Status)
   is
      Code      : ROM_Code := S.Last_ROM;
      Last_Zero : Bit_Number := 0;
      Id        : Boolean;
      Comp      : Boolean := False;
      Take      : Boolean;
   begin
      ROM := [others => 0];
      Found := False;
      if S.Done then
         Stat := Ok;
         return;
      end if;
      Reset (B, Stat);
      if Stat = Ok then
         Write_Byte (B, Search_ROM, Stat);
      end if;
      if Stat /= Ok then
         S := Fresh_Search;
         return;
      end if;

      --  Each device sends its bit, then the bit's complement, and
      --  the line is the AND of them all. Then the controller sends
      --  the branch it takes, and the devices on the other drop out.
      for N in 1 .. 64 loop
         Wire.Touch (B, True, Id, Stat);
         if Stat = Ok then
            Wire.Touch (B, True, Comp, Stat);
         end if;
         if Stat /= Ok or else (Id and Comp) then
            --  No device is left
            if Stat = Ok then
               Stat := No_Device;
            end if;
            S := Fresh_Search;
            return;
         end if;
         if Id /= Comp then
            --  Every device left has this bit
            Take := Id;
         else
            --  Both values: a branch. Below the last discrepancy,
            --  follow the last code; at it, take the 1 this time;
            --  beyond it, take the 0 first.
            Take := (if N < S.Last_Discrepancy then Bit (Code, N)
                     else N = S.Last_Discrepancy);
            if not Take then
               Last_Zero := N;
            end if;
         end if;
         Set_Bit (Code, N, Take);
         Wire.Touch (B, Take, Id, Stat);
         if Stat /= Ok then
            S := Fresh_Search;
            return;
         end if;
      end loop;

      --  A line held low answers every bit with 0 and 0, a branch
      --  each time; the zeros it gives have a good CRC
      if All_Zero (Code) then
         Stat := Bus_Low;
         S := Fresh_Search;
         return;
      elsif not Valid (Code) then
         Stat := CRC_Error;
         S := Fresh_Search;
         return;
      end if;
      S := (Last_ROM         => Code,
            Last_Discrepancy => Last_Zero,
            Done             => Last_Zero = 0);
      ROM := Code;
      Found := True;
   end Next;
end Keel.OneWire.Protocol;
