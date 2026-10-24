--  Output pads: no pull-down, not isolated, the rest at reset
Output_Pad : constant GPIO_Register :=
  (PDE => False, ISO => False, others => <>);

procedure Initialize is
begin
   Unreset;

   --  One tick per microsecond for TIMER0
   TICKS_Periph.TIMER0_CYCLES.TIMER0_CYCLES :=
     TIMER0_CYCLES_TIMER0_CYCLES_Field (Ref_Clock / Tick_Rate);
   TICKS_Periph.TIMER0_CTRL.ENABLE := True;

   --  Each pin's function select has its own type: sio_15 is a
   --  GPIO15_CTRL_FUNCSEL_Field and fits no other pin.
   IO_BANK0_Periph.GPIO15_CTRL := (FUNCSEL => sio_15, others => <>);
   IO_BANK0_Periph.GPIO14_CTRL := (FUNCSEL => sio_14, others => <>);
   IO_BANK0_Periph.GPIO13_CTRL := (FUNCSEL => sio_13, others => <>);

   PADS_BANK0_Periph.GPIO15 := Output_Pad;
   PADS_BANK0_Periph.GPIO14 := Output_Pad;
   PADS_BANK0_Periph.GPIO13 := Output_Pad;

   Output_Clear (All_Lamps);
   Enable_Output (All_Lamps);
end Initialize;

procedure Show (Lamps : Lamp_Set) is
begin
   Output_Clear (All_Lamps and not Pins (Lamps));
   Output_Set (Pins (Lamps));
end Show;

--  TIMERAWL is a count, not a mask: it gets a count type of its own
type Count is mod 2**32;

function Now return Count is (Count (TIMER0_Periph.TIMERAWL));

procedure Wait (D : Micro_Seconds) is
   Start : constant Count := Now;
begin
   --  Modular subtraction: correct across the 2**32 us wrap
   while Now - Start < Count (D) loop
      null;
   end loop;
end Wait;
