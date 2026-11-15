--  The CTRL word that runs T on Ch
function Control (Ch : Channel; T : Transfer)
  return Regs.CTRL_Register is
  (EN         => True,
   DATA_SIZE  => (case T.Size is
                    when Byte      => SIZE_BYTE,
                    when Half_Word => SIZE_HALFWORD,
                    when Word      => SIZE_WORD),
   INCR_READ  => not Is_Register (T.From),
   INCR_WRITE => not Is_Register (T.To),
   RING_SIZE  => UInt4 (T.Wrap),
   RING_SEL   => Ring_On_To (T),
   --  A channel that chains to itself doesn't chain
   CHAIN_TO   => UInt4 (if T.Chain then T.Chain_To else Ch),
   TREQ_SEL   => UInt6 (T.Paced_By),
   others     => <>);
