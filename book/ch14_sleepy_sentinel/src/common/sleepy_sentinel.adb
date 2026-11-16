--  SPDX-License-Identifier: Apache-2.0
--  The sleepy sentinel. Every 10 s it wakes, reads the chip's
--  temperature, adds it to a log kept in retained words, feeds the
--  watchdog and goes back to sleep in the deepest mode the build
--  allows. Hold the hang button and it stops feeding the watchdog,
--  which resets the chip 12 s later; the next start counts the
--  rescue in the log, which survived it.
with Board;         use Board;
with Keel;          use type Keel.Status;
with Keel.Time;     use Keel.Time;
with Keel.Watchdog; use Keel.Watchdog;
with Sentinel_Log;  use Sentinel_Log;

procedure Sleepy_Sentinel is
   Period  : constant Time_Span := Milliseconds (10_000);
   Timeout : constant Timeout_Ms := 12_000;

   L      : Log;
   Found  : Boolean;
   Why    : Reset_Cause;
   C      : Centi;
   Stat   : Keel.Status;
   Next   : Time;

   --  Hundredths as "23.45"
   function Degrees (X : Centi) return String is
      Whole : constant String := Integer'Image (abs X / 100);
      Frac  : constant Natural := abs X mod 100;
   begin
      return (if X < 0 then "-" else "") & Whole (2 .. Whole'Last)
        & "." & Character'Val (48 + Frac / 10)
        & Character'Val (48 + Frac mod 10);
   end Degrees;

   function History return String is
      S : String (1 .. 7 * Capacity) := [others => ' '];
      Last : Natural := 0;
   begin
      for I in 1 .. L.Held loop
         declare
            D : constant String := " " & Degrees (Nth (L, I));
         begin
            S (Last + 1 .. Last + D'Length) := D;
            Last := Last + D'Length;
         end;
      end loop;
      return S (1 .. Last);
   end History;
begin
   Board.Initialize;
   Why := Cause;
   Load (L, Found);
   if not Found then
      L := (others => <>);
   end if;
   if Why in Watchdog_Timeout | Watchdog_Forced then
      L.Recoveries := Natural'Min (L.Recoveries + 1, 255);
   end if;
   L.Last_Cause := Reset_Cause'Pos (Why);
   Store (L);
   Put_Line ("sentinel: " & Stamp & " start: " & Why'Image
             & (if Found then ", log kept" else ", new log")
             & ", rescues" & L.Recoveries'Image
             & ", deepest " & Deepest_Mode);

   Start_Watchdog (Timeout);
   Next := Now;
   loop
      if Hang_Requested then
         Put_Line ("sentinel: hang: no more feeding");
         loop
            null;
         end loop;
      end if;

      Read_Temperature (C, Stat);
      if Stat = Keel.Ok then
         Push (L, C);
         Store (L);
         Put_Line ("sentinel: " & Stamp & " " & Degrees (C)
                   & " C, taken" & L.Taken'Image & ", log"
                   & History);
      else
         Put_Line ("sentinel: temperature: " & Stat'Image);
      end if;

      Feed;
      Next := Next + Period;
      Wait_Until (Next);
   end loop;
end Sleepy_Sentinel;
