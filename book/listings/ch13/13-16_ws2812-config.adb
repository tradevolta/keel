Configure
  (S.B, S.M, Code.Code, Offset,
   (Clock          =>
      Divider_For (Clock_Hz, Bit_Rate * Code.Cycles_Per_Bit),
    Side_Base      => S.Pin,
    --  The first bit is the top one: put pixels in bits 31..8
    Out_Shift      => Shift_Left,
    Autopull       => True,
    Pull_Threshold => 24,
    FIFO           => Join_TX,
    others         => <>));
