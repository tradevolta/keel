--  SPDX-License-Identifier: Apache-2.0
--  The fault report, written through any Put_Line: Keel.Trace on
--  the chip, Ada.Text_IO on the host.
generic
   with procedure Put_Line (Text : String);
procedure Keel.Faults.Report
  (CFSR, HFSR, MMFAR, BFAR : Word; Frame : Stacked_Frame)
  with Preelaborate;
