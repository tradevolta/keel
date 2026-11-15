Configure
  (Wire.B, Wire.M, Code.Code, Wire.Offset,
   (Clock          => Clock,
    Set_Base       => Wire.Pin,
    Set_Count      => 1,
    In_Base        => Wire.Pin,
    --  A bit a word each way, in bit 0
    Out_Shift      => Shift_Right,
    In_Shift       => Shift_Left,
    Autopull       => True,
    Pull_Threshold => 1,
    Autopush       => True,
    Push_Threshold => 1,
    others         => <>));
--  Open drain: the level is always 0; the direction drives it
Set_Pins (Wire.B, Wire.M, Wire.Pin, 1, 0);
Set_Directions (Wire.B, Wire.M, Wire.Pin, 1, 0);
