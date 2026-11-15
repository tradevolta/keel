--  Everything but CTRL: the addresses, the count and its mode,
--  and whether Ch's rounds reach DMA_IRQ_0
procedure Set_Up (Ch : Channel; T : Transfer; Stat : out Status) is
   R : Regs.Channel_Registers renames Regs.Channels (Regs_Of (Ch));
   Mask : UInt16 := DMA_Periph.INTE0.INTE0;
begin
   if not Valid (T) or else (T.Chain and then T.Chain_To = Ch) then
      Stat := Not_Supported;
      return;
   end if;
   Current (Ch) := T;
   Done_N (Ch) := 0;
   --  An event left from an earlier transfer: clear it
   if Is_Set (Ended (Ch)) then
      Wait (Ended (Ch));
   end if;
   Mask := (if T.Notify then Mask or Bit (Ch)
            else Mask and not Bit (Ch));
   DMA_Periph.INTE0 := (INTE0 => Mask, others => <>);
   R.READ_ADDR := UInt32 (Start (T.From));
   R.WRITE_ADDR := UInt32 (Start (T.To));
   R.TRANS_COUNT :=
     (COUNT => CH0_TRANS_COUNT_COUNT_Field (T.Count),
      MODE  => (case T.Mode is
                  when Once    => NORMAL,
                  when Repeat  => TRIGGER_SELF,
                  when Endless => ENDLESS));
   Stat := Ok;
end Set_Up;

--  CTRL_TRIG is alias 0's trigger: writing it starts the channel
procedure Start (Ch : Channel; T : Transfer; Stat : out Status) is
begin
   Set_Up (Ch, T, Stat);
   if Stat = Ok then
      Regs.Channels (Regs_Of (Ch)).CTRL_TRIG := Control (Ch, T);
   end if;
end Start;
