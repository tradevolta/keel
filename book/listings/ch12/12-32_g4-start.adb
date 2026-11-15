procedure Start (Ch : Channel; T : Transfer; Stat : out Status) is
   C : Regs.Channel_Registers renames Regs.Channels (R (Ch));
   --  The peripheral side: the register, or for RAM to RAM the
   --  source (DIR = 0 reads from CPAR, as ST's HAL sets it)
   To_Register : constant Boolean :=
     T.Paced_By /= Memory_To_Memory and then Is_Register (T.To);
   Periph : constant Region :=
     (if To_Register then T.To else T.From);
   Memory : constant Region :=
     (if To_Register then T.From else T.To);
begin
   if not Valid (T) then
      Stat := Not_Supported;
      return;
   end if;
   Current (Ch) := T;
   Done_N (Ch) := 0;
   if Is_Set (Ended (Ch)) then
      Wait (Ended (Ch));
   end if;
   --  CCR, CPAR, CMAR and CNDTR are written only while EN is off
   C.CCR := (EN => False, others => <>);
   Clear (Ch);
   Regs.Requests (R (Ch)) :=
     (DMAREQ_ID => C0CR_DMAREQ_ID_Field (T.Paced_By), others => <>);
   C.CPAR := UInt32 (Start (Periph));
   C.CMAR := UInt32 (Start (Memory));
   C.CNDTR := (NDT => CNDTR_NDT_Field (T.Count), others => <>);
   C.CCR :=
     (EN      => True,
      TCIE    => T.Notify,
      HTIE    => T.Notify and then T.Halves,
      TEIE    => True,
      DIR     => To_Register,
      CIRC    => T.Circular,
      PINC    => not Is_Register (Periph),
      MINC    => True,
      PSIZE   => Size_Code (T.Size),
      MSIZE   => Size_Code (T.Size),
      PL      => 0,
      MEM2MEM => T.Paced_By = Memory_To_Memory,
      others  => <>);
   Stat := Ok;
end Start;
