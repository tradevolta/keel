--  SPDX-License-Identifier: Apache-2.0
--  The thermo-strip. At start it searches the 1-Wire bus and keeps
--  the first two DS18B20s it finds, probe A and probe B. Then, once a
--  second, it starts a conversion in both, waits for it, reads each,
--  prints the two temperatures, and shows them on the eight LEDs:
--  probe A's colour at LED 1, probe B's at LED 8, a blend between.
with Board;               use Board;
with Keel;                use type Keel.Status;
with Keel.OneWire;        use Keel.OneWire;
with Keel.OneWire.Protocol;
with Keel.Drivers.DS18B20;
with Keel.Drivers.WS2812; use Keel.Drivers.WS2812;
with Keel.Time;           use Keel.Time;
with Keel.Units;          use Keel.Units;
with Thermo;

procedure Thermo_Strip is
   package Wire is new Bus_Signature (Board.Bus, Reset, Touch);
   package Protocol is new Keel.OneWire.Protocol (Wire);
   package Sensor is new Keel.Drivers.DS18B20 (Wire);
   package Transport is new Strip_Signature (Board.Strip, Put, Latch);
   procedure Show is new Keel.Drivers.WS2812.Show (Transport);

   --  An eighth of full brightness: enough indoors, and 8 LEDs at
   --  most 8 * 3 * 18 mA / 8 = 54 mA
   Level : constant Intensity := 32;

   type Probe is (A, B);
   ROMs  : array (Probe) of ROM_Code := [others => [others => 0]];
   Temps : array (Probe) of Celsius := [others => 20.0];
   Count : Natural := 0;

   Hex_Digits : constant String := "0123456789ABCDEF";

   function Image (R : ROM_Code) return String is
      S : String (1 .. 16);
   begin
      --  Family code last, as datasheets print a ROM code
      for I in R'Range loop
         S (17 - 2 * I) := Hex_Digits (Natural (R (I)) / 16 + 1);
         S (18 - 2 * I) := Hex_Digits (Natural (R (I)) mod 16 + 1);
      end loop;
      return S;
   end Image;

   procedure Find_Probes is
      State : Protocol.Search_State := Protocol.Fresh_Search;
      ROM   : ROM_Code;
      Found : Boolean;
      Stat  : Status;
   begin
      loop
         Protocol.Next (Probes, State, ROM, Found, Stat);
         exit when not Found;
         if Family (ROM) = Sensor.Family_Code and then Count < 2 then
            ROMs (Probe'Val (Count)) := ROM;
            Count := Count + 1;
            Put_Line ("thermo: probe " & Probe'Val (Count - 1)'Image
                      & " is " & Image (ROM));
         else
            Put_Line ("thermo: also on the bus: " & Image (ROM));
         end if;
      end loop;
      if Stat /= Ok then
         Put_Line ("thermo: search: " & Stat'Image);
      end if;
      --  One probe: it is both ends of the strip
      if Count = 1 then
         ROMs (B) := ROMs (A);
      end if;
   end Find_Probes;

   Next  : Time;
   Raw   : Sensor.Raw_Temperature;
   Stat  : Status;
   Shown : Keel.Status;
begin
   Board.Initialize;
   Find_Probes;
   if Count = 0 then
      Put_Line ("thermo: no DS18B20 found");
   end if;

   Next := Now;
   loop
      if Count > 0 then
         Sensor.Start_Conversion (Probes, Stat);
         if Stat = Ok then
            Wait_Until (Now + Sensor.Conversion_Time);
         end if;
         for P in Probe loop
            if Stat = Ok then
               Sensor.Read (Probes, ROMs (P), Raw, Stat);
            end if;
            if Stat = Ok and then Raw in Sensor.Rated then
               Temps (P) := Sensor.To_Celsius (Raw);
            end if;
         end loop;
         if Stat = Ok then
            Put_Line ("thermo: A" & Temps (A)'Image & " C, B"
                      & Temps (B)'Image & " C");
         else
            Put_Line ("thermo: read: " & Stat'Image);
         end if;
      end if;

      Show (LEDs, Thermo.Strip_For (Temps (A), Temps (B)), Level,
            Shown);
      if Shown /= Keel.Ok then
         Put_Line ("thermo: strip: " & Shown'Image);
      end if;

      Next := Next + Milliseconds (1_000);
      Wait_Until (Next);
   end loop;
end Thermo_Strip;
