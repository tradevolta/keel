--  SPDX-License-Identifier: Apache-2.0
--  The current meter: a second Pico 2 W reads an INA219 whose shunt
--  carries the sentinel's supply, and every 10 s prints the mean,
--  the least and the most current it saw. The INA219 averages 128
--  samples into each reading, 68.10 ms of them, and runs without a
--  break, so the 10 s mean covers the whole window.
with Keel;                use type Keel.Status;
with Keel.Clock;          use Keel.Clock;
with Keel.Clock.RP2350;   use Keel.Clock.RP2350;
with Keel.Drivers.INA219;
with Keel.Time;           use Keel.Time;
with Keel.Time.Bare;
with Keel.Trace;
with Polled_I2C;

procedure Current_Meter is
   package Meter is new Keel.Drivers.INA219
     (Polled_I2C.Bus, Polled_I2C.Read_Register,
      Polled_I2C.Write_Register);
   use Meter;

   --  The Adafruit breakout's shunt: 0.1 ohm, so 100 uA per count
   Shunt : constant Shunt_Milliohms := 100;

   --  One reading per conversion; the window is 10 s
   Step   : constant Time_Span := Microseconds (68_100);
   Window : constant Time_Span := Milliseconds (10_000);

   Bus   : Polled_I2C.Bus;
   Stat  : Keel.Status;
   Next  : Time;
   Ends  : Time;
   uV    : Integer;
   uA    : Integer;
   Sum   : Long_Long_Integer;
   N     : Natural;
   Least : Integer;
   Most  : Integer;

   procedure Check (What : String) is
   begin
      if Stat /= Keel.Ok then
         Keel.Trace.Put_Line ("meter: " & What & ": " & Stat'Image);
         loop
            null;
         end loop;
      end if;
   end Check;
begin
   Keel.Trace.Initialize;
   Start_Crystal (Stat);
   Check ("crystal");
   Keel.Time.Bare.Start (Crystal);
   Polled_I2C.Start (Bus, Crystal, Stat);
   Check ("I2C0 on GP4, GP5");

   --  Shunt only, 40 mV range (400 mA through 0.1 ohm), 128 samples
   Configure
     (Bus,
      (Gain   => Div_1_40mV,
       Sh_ADC => Average_128,
       Mode   => Continuous_Shunt,
       others => <>),
      Stat);
   Check ("INA219 at 0x40");
   Keel.Trace.Put_Line ("meter: window 10 s, uA mean min max n");

   Next := Keel.Time.Bare.Clock;
   loop
      Ends := Next + Window;
      Sum := 0;
      N := 0;
      Least := Integer'Last;
      Most := Integer'First;
      while Next < Ends loop
         Next := Next + Step;
         Keel.Time.Bare.Wait_Until (Next);
         Read_Shunt (Bus, uV, Stat);
         if Stat = Keel.Ok then
            uA := Current_uA (uV, Shunt);
            Sum := Sum + Long_Long_Integer (uA);
            N := N + 1;
            Least := Integer'Min (Least, uA);
            Most := Integer'Max (Most, uA);
         end if;
      end loop;
      if N = 0 then
         Keel.Trace.Put_Line ("meter: no readings: " & Stat'Image);
      else
         Keel.Trace.Put_Line
           ("meter:"
            & Long_Long_Integer'Image (Sum / Long_Long_Integer (N))
            & Least'Image & Most'Image & N'Image);
      end if;
   end loop;
end Current_Meter;
