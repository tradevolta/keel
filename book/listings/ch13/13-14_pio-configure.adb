   R : Machine_Registers renames
     Regs (B).SM (PIO_Blocks.Machine (M));
begin
   Stop (B, M);
   R.CLKDIV :=
     (INT => UInt16 (Config.Clock.Int mod 65_536),
      FRAC => Byte (Config.Clock.Frac), others => <>);
   R.EXECCTRL :=
     (WRAP_BOTTOM => UInt5 (Offset + P.Wrap_Target),
      WRAP_TOP    => UInt5 (Offset + P.Wrap),
      JMP_PIN     => UInt5 (Config.Jmp_Pin),
      SIDE_EN     => P.Side_Optional,
      others      => <>);
   R.SHIFTCTRL :=
     (AUTOPUSH     => Config.Autopush,
      AUTOPULL     => Config.Autopull,
      IN_SHIFTDIR  => Config.In_Shift = Shift_Right,
      OUT_SHIFTDIR => Config.Out_Shift = Shift_Right,
      PUSH_THRESH  => Count_Field (Config.Push_Threshold),
      PULL_THRESH  => Count_Field (Config.Pull_Threshold),
      FJOIN_TX     => Config.FIFO = Join_TX,
      FJOIN_RX     => Config.FIFO = Join_RX,
      others       => <>);
   R.PINCTRL :=
     (OUT_BASE      => UInt5 (Config.Out_Base),
      OUT_COUNT     => UInt6 (Config.Out_Count),
      SET_BASE      => UInt5 (Config.Set_Base),
      SET_COUNT     => UInt3 (Config.Set_Count),
      SIDESET_BASE  => UInt5 (Config.Side_Base),
      --  The count includes the enable bit (11.7, PINCTRL)
      SIDESET_COUNT =>
        UInt3 (P.Side_Bits + Boolean'Pos (P.Side_Optional)),
      IN_BASE       => UInt5 (Config.In_Base));
   --  Changing FJOIN empties the FIFOs; set it again to be sure
   Restart (B, M);
   Ctrl_Bits.Set
     (Regs (B).CTRL,
      (Ctrl_Bits.No_Bits with delta CLKDIV_RESTART => Bit (M)));
   Execute (B, M, Asm.Jmp (Offset));
end Configure;
