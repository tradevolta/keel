--  SPDX-License-Identifier: Apache-2.0
--  sampler_view: show a logic sampler capture.
--
--     sampler_view [FILE] [--svg OUT.svg] [--note TEXT] [--no-plot]
--
--  FILE is the capture text or a whole console log (standard input
--  if absent). It prints a summary and a plot in text; with --svg,
--  it also writes the trace as an SVG. --no-plot leaves out the
--  text plot, for a log or a page that has the SVG instead.
with Ada.Command_Line;      use Ada.Command_Line;
with Ada.Strings.Unbounded; use Ada.Strings.Unbounded;
with Ada.Text_IO;      use Ada.Text_IO;
with Captures;         use Captures;
with Plots;

procedure Sampler_View is
   C     : Capture;
   Found : Boolean;
   K     : Positive := 1;
   Input : Unbounded_String;
   Out_N : Unbounded_String;
   Note  : Unbounded_String;
   Plot  : Boolean := True;
begin
   while K <= Argument_Count loop
      if Argument (K) = "--svg" and then K < Argument_Count then
         Out_N := To_Unbounded_String (Argument (K + 1));
         K := K + 2;
      elsif Argument (K) = "--note" and then K < Argument_Count then
         Note := To_Unbounded_String (Argument (K + 1));
         K := K + 2;
      elsif Argument (K) = "--no-plot" then
         Plot := False;
         K := K + 1;
      else
         Input := To_Unbounded_String (Argument (K));
         K := K + 1;
      end if;
   end loop;

   Read (To_String (Input), C, Found);
   if not Found or else C.Samples.Is_Empty then
      Put_Line (Standard_Error, "sampler_view: no complete capture");
      Set_Exit_Status (Failure);
      return;
   end if;
   Plots.Summary (C);
   if Plot then
      Plots.Text_Plot (C);
   end if;
   if Length (Out_N) > 0 then
      Plots.SVG (C, To_String (Out_N), To_String (Note));
      Put_Line ("wrote " & To_String (Out_N));
   end if;
end Sampler_View;
