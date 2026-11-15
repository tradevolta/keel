--  The test signal: 500 Hz, half the time high
Solve (Slice_Limits, Keel.Units.Hertz (Sys_Frequency), "500 Hz",
       Trailing_Edge, Square, Stat);
Check (Stat, "test signal setting");
Claim (Signal_Pin, Square, Stat);
Check (Stat, "GP16");
Set_Level (Signal_Pin, Level_For (Square, 0.5));
