--  SPDX-License-Identifier: Apache-2.0
--  The Pico 2 W board. The button goes to ground from GP16, with
--  the pad's pull-up. GP21 carries clk_sys / 1000 (GPOUT0). An
--  INA219 on I2C0 (SDA GP4, SCL GP5) measures the supply current.
--  TIMER0 counts microseconds from clk_ref; the console is RTT.
with Keel.Clock.RP2350;  use Keel.Clock.RP2350;
with Keel.GPIO;          use Keel.GPIO;
with Keel.GPIO.Debounce; use Keel.GPIO.Debounce;
with Keel.GPIO.RP2350;   use Keel.GPIO.RP2350;
with Keel.Trace;
with Power_Monitor;
with RP2350_SVD;         use type RP2350_SVD.Byte;
with RP2350_SVD.Atomic;
with RP2350_SVD.CLOCKS;  use RP2350_SVD.CLOCKS;
with RP2350_SVD.QMI;     use RP2350_SVD.QMI;
with RP2350_SVD.RESETS;  use RP2350_SVD.RESETS;
with RP2350_SVD.TICKS;   use RP2350_SVD.TICKS;
with RP2350_SVD.TIMER0;  use RP2350_SVD.TIMER0;

package body Board is

   Button : Input_Pin (16);
   Contact : Debouncer (5);

   Steps : constant array (Step) of Frequency :=
     [12_000_000, 48_000_000, 150_000_000, 200_000_000];

   --  GP21 shows clk_sys / 1000: 12 kHz to 200 kHz
   Clock_Out_Divisor : constant := 1_000;

   --  The Pico 2 W's flash, a Winbond W25Q32RV, is rated to a
   --  133 MHz SCK, and SCK is clk_sys / QMI M0_TIMING.CLKDIV
   Flash_Max : constant Frequency := 133_000_000;

   function Limits return PLL_Limits is (PLL_SYS);
   function Reference return Frequency is (Crystal);
   function Target (S : Step) return Frequency is (Steps (S));

   type Count is mod 2**32;
   function Now return Count is (Count (TIMER0_Periph.TIMERAWL));
   Last_Tick : Count := 0;

   package Reset_Bits is new RP2350_SVD.Atomic (RESET_Register);

   --  TIMER0 ticks once per microsecond: clk_ref / 12
   procedure Start_Timer is
      Timer0_Only : constant RESET_TIMER_Field :=
        (As_Array => True, Arr => [0 => True, 1 => False]);
   begin
      Reset_Bits.Clear
        (RESETS_Periph.RESET,
         (Reset_Bits.No_Bits with delta TIMER => Timer0_Only));
      loop
         exit when RESETS_Periph.RESET_DONE.TIMER.Arr (0);
      end loop;
      TICKS_Periph.TIMER0_CYCLES.TIMER0_CYCLES :=
        TIMER0_CYCLES_TIMER0_CYCLES_Field (Crystal / 1_000_000);
      TICKS_Periph.TIMER0_CTRL.ENABLE := True;
   end Start_Timer;

   --  The flash divisor; a CLKDIV of 0 means 256
   function Flash_Divisor return Frequency is
     (if QMI_Periph.M0_TIMING.CLKDIV = 0 then 256
      else Frequency (QMI_Periph.M0_TIMING.CLKDIV));

   procedure Check (Stat : Status; What : String) is
   begin
      if Stat /= Ok then
         Keel.Trace.Put_Line
           ("frequency_explorer: " & What & ": " & Stat'Image);
         loop
            null;
         end loop;
      end if;
   end Check;

   procedure Initialize is
      Stat : Status;
   begin
      Keel.Trace.Initialize;
      Start_Crystal (Stat);
      Check (Stat, "crystal");
      --  clk_peri (I2C) from the crystal too: it stays at 12 MHz
      --  whatever clk_sys does
      CLOCKS_Periph.CLK_PERI_CTRL :=
        (AUXSRC => xosc_clksrc, ENABLE => True, others => <>);
      Start_Timer;
      Enable;
      Claim (Button, (Bias => Pull_Up), Stat);
      Check (Stat, "GP16");
      Reset (Contact, High);
      Start_Clock_Out (Clock_Out_Divisor, Stat);
      Check (Stat, "GP21");
      Power_Monitor.Start (Stat);
      Check (Stat, "GP4/GP5");
      Keel.Trace.Put_Line
        ("frequency_explorer: flash CLKDIV"
         & Frequency'Image (Flash_Divisor));
      Last_Tick := Now;
   end Initialize;

   procedure Next_Tick is
   begin
      while Now - Last_Tick < 1_000 loop
         null;
      end loop;
      Last_Tick := Last_Tick + 1_000;
   end Next_Tick;

   function Pressed return Boolean is
      Changed : Boolean;
   begin
      Sample (Contact, Get (Button), Changed);
      return Changed and then Stable (Contact) = Low;
   end Pressed;

   procedure Switch (P : Plan; Stat : out Status) is
   begin
      case P.Kind is
         when From_Reference =>
            Run_From_Crystal;
            Stat := Ok;
         when From_PLL =>
            if Output (P.Setting) / Flash_Divisor > Flash_Max then
               Run_From_Crystal;
               Stat := Not_Supported;
            else
               Run_From_PLL (P.Setting, Stat);
            end if;
         when Refused =>
            Run_From_Crystal;
            Stat := Not_Supported;
      end case;
   end Switch;

   function Measured_Image return String is
     (MHz_Image (Measure_Sys_kHz));

   function Supply_Image return String is
      Tenths : Integer;
      Stat   : Keel.Status;
   begin
      Power_Monitor.Read (Tenths, Stat);
      if Stat /= Ok then
         return "no reading (" & Stat'Image & ")";
      end if;
      declare
         Whole : constant String := Integer'Image (abs Tenths / 10);
      begin
         return (if Tenths < 0 then "-" else "")
           & Whole (Whole'First + 1 .. Whole'Last) & "."
           & Integer'Image (abs Tenths mod 10) (2) & " mA";
      end;
   end Supply_Image;

   procedure Put_Line (Text : String) is
   begin
      Keel.Trace.Put_Line (Text);
   end Put_Line;
end Board;
