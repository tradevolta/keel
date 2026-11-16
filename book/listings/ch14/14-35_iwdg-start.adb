procedure Start
  (T : Timeout_Ms; Stat : out Status;
   Pause_On_Debug : Boolean := True)
is
   S     : Setting;
   Found : Boolean;
begin
   Solve (Limits, T, S, Found);
   if not Found then
      Stat := Not_Supported;
      return;
   end if;
   DBGMCU_Periph.APB1L_FZ.DBG_IWDG_STOP := Pause_On_Debug;

   --  Start it (which starts the LSI), open the configuration
   --  registers, then the prescaler, 2**(PR + 2), and the reload
   IWDG_Periph.KR := (KEY => Key_Enable, others => <>);
   IWDG_Periph.KR := (KEY => Key_Access, others => <>);
   IWDG_Periph.PR := (PR => PR_PR_Field (S.Shift - 2), others => <>);
   IWDG_Periph.RLR := (RL => RLR_RL_Field (S.Reload), others => <>);

   --  PVU and RVU clear once the LSI domain has the values: up to
   --  5 LSI periods times the prescaler, 40 ms at /256. The poll
   --  gives up after many times that at any clock Keel uses.
   Stat := Timeout;
   for Try in 1 .. 20_000_000 loop
      if not IWDG_Periph.SR.PVU and then not IWDG_Periph.SR.RVU then
         Stat := Ok;
         exit;
      end if;
   end loop;
   Feed;
end Start;
