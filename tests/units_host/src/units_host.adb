--  SPDX-License-Identifier: Apache-2.0
--  Keel.Units on the host: good literals give exact values, bad ones
--  are rejected by Is_* and raise Constraint_Error when evaluated.
with Ada.Text_IO; use Ada.Text_IO;
with Ada.Command_Line;
with Ada.Exceptions;
with Keel.Units;  use Keel.Units;

procedure Units_Host is
   Failures : Natural := 0;

   procedure Check (Name : String; OK : Boolean) is
   begin
      Put_Line ((if OK then "ok:   " else "FAIL: ") & Name);
      if not OK then
         Failures := Failures + 1;
      end if;
   end Check;

   XOSC  : constant Hertz := "12 MHz";
   Tick  : constant Hertz := "1 MHz";
   Red   : constant Micro_Seconds := "3 s";
   Amber : constant Micro_Seconds := "1_500 ms";
   Core  : constant Volts := "1.1 V";
   Cold  : constant Celsius := "-40 C";
begin
   Check ("""12 MHz"" = 12_000_000.0", XOSC = 12_000_000.0);
   Check ("""12 MHz"" / ""1 MHz"" = 12", Integer (XOSC / Tick) = 12);
   Check ("""3 s"" = 3_000_000.0", Red = 3_000_000.0);
   Check ("""1_500 ms"" = 1_500_000.0", Amber = 1_500_000.0);
   Check ("""1.1 V"" = 1.1", Core = 1.1);
   Check ("""-40 C"" = -40.0", Cold = -40.0);
   Check ("""2.000 us"" is 2 us", Is_Micro_Seconds ("2.000 us"));
   Check ("""1.5 us"" is rejected", not Is_Micro_Seconds ("1.5 us"));
   Check ("""12 ms"" is not Hertz", not Is_Hertz ("12 ms"));
   Check ("""12MHz"" is rejected", not Is_Hertz ("12MHz"));
   Check ("""2 GHz"" is out of range", not Is_Hertz ("2 GHz"));
   Check ("""1__0 Hz"" is rejected", not Is_Hertz ("1__0 Hz"));

   --  A bad literal compiles: it is a call, checked when it runs. The
   --  handler is outside the block whose declaration raises.
   begin
      declare
         Wrong : constant Hertz := "12 ms";
      begin
         Check ("""12 ms"" as Hertz raised", Wrong < 0.0);
      end;
   exception
      when E : Constraint_Error =>
         Put_Line ("ok:   ""12 ms"" as Hertz raised "
                   & Ada.Exceptions.Exception_Name (E));
   end;

   Put_Line (if Failures = 0 then "units_host: all passed"
             else "units_host:" & Failures'Image & " failed");
   if Failures > 0 then
      Ada.Command_Line.Set_Exit_Status (Ada.Command_Line.Failure);
   end if;
end Units_Host;
