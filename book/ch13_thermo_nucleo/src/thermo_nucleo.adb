--  SPDX-License-Identifier: Apache-2.0
--  The NUCLEO-G474RE's half of Chapter 13. The G474 has no PIO, so
--  the processor runs the 1-Wire bus itself, on PA8 (Arduino D7) as
--  an open-drain output, timing each slot with the DWT cycle
--  counter and interrupts held off. Above the bus, everything is the
--  Pico's: the same search, the same DS18B20 driver. It prints both
--  temperatures over RTT once a second; the LEDs are an exercise.
with Interfaces;         use Interfaces;
with Keel;               use type Keel.Status;
with Keel.Clock;        use type Keel.Clock.Frequency;
with Keel.Clock.STM32G4; use Keel.Clock.STM32G4;
with Keel.Cortex_M;
with Keel.GPIO;          use Keel.GPIO;
with Keel.GPIO.STM32G4;  use Keel.GPIO.STM32G4;
with Keel.OneWire;       use Keel.OneWire;
with Keel.OneWire.Bit_Bang;
with Keel.OneWire.Protocol;
with Keel.Drivers.DS18B20;
with Keel.Time;          use Keel.Time;
with Keel.Time.Bare;
with Keel.Trace;

procedure Thermo_Nucleo is
   Target : constant Keel.Clock.Frequency := 150_000_000;

   --  PA8, Arduino D7: CN9 pin 8 (UM2505, Table 15)
   Line : Output_Pin (Port => A, Pin => 8);

   --  Spin N microseconds on the cycle counter, which wraps safely
   procedure Wait_Us (N : Positive) is
      Start : constant Unsigned_32 := Keel.Cortex_M.DWT_CYCCNT;
      Ticks : constant Unsigned_32 :=
        Unsigned_32 (N) * Unsigned_32 (Sys_Frequency / 1_000_000);
   begin
      loop
         exit when Keel.Cortex_M.DWT_CYCCNT - Start >= Ticks;
      end loop;
   end Wait_Us;

   package Wire_Bus is new Keel.OneWire.Bit_Bang
     (Line => Output_Pin, Set => Set, Sense => Sense,
      Wait_Us => Wait_Us,
      Hold => Keel.Cortex_M.Disable_Interrupts,
      Let_Go => Keel.Cortex_M.Enable_Interrupts);
   package Wire is new Bus_Signature
     (Output_Pin, Wire_Bus.Reset, Wire_Bus.Touch);
   package Protocol is new Keel.OneWire.Protocol (Wire);
   package Sensor is new Keel.Drivers.DS18B20 (Wire);

   type Probe is (A, B);
   ROMs  : array (Probe) of ROM_Code := [others => [others => 0]];
   Count : Natural := 0;

   PLL_Setting : Keel.Clock.PLL_Config;
   Found  : Boolean;
   Stat   : Keel.Status;
   Bus    : Status;
   State  : Protocol.Search_State := Protocol.Fresh_Search;
   ROM    : ROM_Code;
   Raw    : Sensor.Raw_Temperature;
   Next   : Time;

   procedure Check (What : String) is
   begin
      if Stat /= Keel.Ok then
         Keel.Trace.Put_Line ("thermo: " & What & ": " & Stat'Image);
         loop
            null;
         end loop;
      end if;
   end Check;
begin
   Keel.Trace.Initialize;
   Keel.Clock.Solve (PLL, HSI16, Target, False, PLL_Setting, Found);
   if Found then
      Run_From_PLL (PLL_Setting, Stat);
      Check ("PLL");
   end if;
   Keel.Time.Bare.Start (Sys_Frequency);
   Keel.Cortex_M.DEMCR := (TRCENA => True);
   Keel.Cortex_M.DWT_Ctrl := (CYCCNTENA => True);
   --  High lets the line go: the 4.7 kohm pull-up holds it high
   Claim_Open_Drain (Line, (Initial => High, Slew => Slow), Stat);
   Check ("PA8");

   loop
      Protocol.Next (Line, State, ROM, Found, Bus);
      exit when not Found;
      if Family (ROM) = Sensor.Family_Code and then Count < 2 then
         ROMs (Probe'Val (Count)) := ROM;
         Count := Count + 1;
      end if;
   end loop;
   Keel.Trace.Put_Line ("thermo: probes:" & Count'Image);
   if Count = 1 then
      ROMs (B) := ROMs (A);
   end if;

   Next := Keel.Time.Bare.Clock;
   loop
      if Count > 0 then
         Sensor.Start_Conversion (Line, Bus);
         Keel.Time.Bare.Wait_Until
           (Keel.Time.Bare.Clock + Sensor.Conversion_Time);
         for P in Probe loop
            Sensor.Read (Line, ROMs (P), Raw, Bus);
            if Bus = Ok and then Raw in Sensor.Rated then
               Keel.Trace.Put_Line
                 ("thermo: " & P'Image
                  & Sensor.To_Celsius (Raw)'Image & " C");
            else
               Keel.Trace.Put_Line
                 ("thermo: " & P'Image & ": " & Bus'Image);
            end if;
         end loop;
      end if;
      Next := Next + Milliseconds (1_000);
      Keel.Time.Bare.Wait_Until (Next);
   end loop;
end Thermo_Nucleo;
