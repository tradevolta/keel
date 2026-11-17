--  SPDX-License-Identifier: Apache-2.0
with Interfaces;     use Interfaces;
with Keel.DMA.Fake;
with Keel.GPIO;    use Keel.GPIO;

package body Keel.Bus.SPI.Fake is

   Heard   : Listener := null;
   Replies : Responder := null;
   Devices : Natural range 0 .. 8 := 0;
   Bus     : Bus_State;
   Stats   : Counts;

   procedure Listen (To : Listener) is
   begin
      Heard := To;
   end Listen;

   procedure Respond (From : Responder) is
   begin
      Replies := From;
   end Respond;

   function Statistics return Counts is (Stats);

   procedure Reset_Bus is
   begin
      Devices := 0;
      Bus := (others => <>);
      Stats := (others => <>);
      Keel.GPIO.Fake.Reset_All;
   end Reset_Bus;

   function Holds (D : Device) return Boolean is
     (D.Attached and then Bus.Owner = Holder (D.Number));

   function Rate_Of (D : Device) return Natural is
     (Rate (Bus_Clock, Divisor (D.Divider)));

   procedure Attach
     (D : in out Device; Want : Settings; Stat : out Status)
   is
      Found : Boolean;
   begin
      if Devices = 8 then
         Stat := Not_Supported;
         return;
      end if;
      Solve_Prescaled (Bus_Clock, Want.Max_Rate, D.Divider, Found);
      if not Found then
         Stat := Not_Supported;
         return;
      end if;
      Claim (D.Select_Pin, (Initial => High, others => <>), Stat);
      if Stat /= Ok then
         return;
      end if;
      Devices := Devices + 1;
      D.Number := Device_Number (Devices);
      D.Want := Want;
      D.Attached := True;
   end Attach;

   procedure Acquire (D : in out Device; Stat : out Status) is
      Again : Boolean;
   begin
      Acquire (Bus, D.Number, D.Want, Again, Stat);
      if Stat /= Ok then
         Stats.Refusals := Stats.Refusals + 1;
         return;
      end if;
      Stats.Acquisitions := Stats.Acquisitions + 1;
      if Again then
         Stats.Reconfigurations := Stats.Reconfigurations + 1;
      end if;
      Set (D.Select_Pin, Low);
   end Acquire;

   procedure Release (D : in out Device) is
   begin
      Set (D.Select_Pin, High);
      Release (Bus, D.Number);
   end Release;

   --  One frame on the wire
   procedure Send (D : Device; Frame : Natural; Bits : Positive) is
   begin
      Stats.Frames := Stats.Frames + 1;
      Stats.Bits := Stats.Bits + Long_Long_Integer (Bits);
      Stats.Busy_ns := Stats.Busy_ns
        + Long_Long_Integer (Bits) * 1_000_000_000
          / Long_Long_Integer (Rate_Of (D));
      if Heard /= null then
         Heard (D.Number, Frame, Bits);
      end if;
   end Send;

   procedure Write (D : in out Device; Data : Byte_Array) is
   begin
      for B of Data loop
         Send (D, Natural (B), 8);
      end loop;
   end Write;

   procedure Exchange (D : in out Device; Data : in out Byte_Array) is
   begin
      for B of Data loop
         Send (D, Natural (B), 8);
         B := (if Replies = null then 16#FF#
               else Replies (D.Number, B));
      end loop;
   end Exchange;

   procedure Start_Stream
     (D     : in out Device;
      From  : Keel.DMA.Region;
      Count : Positive;
      Stat  : out Status)
   is
      use Keel.DMA;
      Sink : Unsigned_16 := 0
        with Volatile;
   begin
      if not Fits (From, Half_Word, Count, 0) then
         Stat := Not_Supported;
         return;
      end if;
      declare
         Words : array (1 .. Count) of Unsigned_16
           with Import, Address => Address_Of (From);
      begin
         for W of Words loop
            Send (D, Natural (W), 16);
         end loop;
      end;
      Keel.DMA.Fake.Run
        (From, Register (Sink'Address), Half_Word, Count, 0,
         D.Pending);
      D.Streaming := True;
      Stat := Ok;
   end Start_Stream;

   procedure Finish_Stream
     (D : in out Device; Done : out Keel.DMA.Receipt) is
   begin
      Done := D.Pending;
      D.Streaming := False;
   end Finish_Stream;
end Keel.Bus.SPI.Fake;
