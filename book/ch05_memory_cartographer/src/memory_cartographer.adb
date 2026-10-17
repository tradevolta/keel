--  SPDX-License-Identifier: Apache-2.0
--  Reports over RTT where the linker put each section, how much of
--  the stack has been used, and what running the same loop from
--  flash and from SRAM costs. GP15 shows the two loops' speeds.
with Interfaces; use Interfaces;
with System.Storage_Elements; use System.Storage_Elements;
with Keel.Cortex_M; use Keel.Cortex_M;
with Keel.Startup;
with Keel.Trace; use Keel.Trace;
with Cartographer_Regs; use Cartographer_Regs;
with Hot_Loops; use Hot_Loops;
with Scratch; use Scratch;
with Sections;

procedure Memory_Cartographer is
   Toggles : constant := 1_000;

   type Place is (Flash, SRAM);

   procedure Measure (Where : Place) is
      Start, Cycles : Unsigned_32;
   begin
      XIP_Hits := 0;
      XIP_Accesses := 0;
      Start := DWT_CYCCNT;
      case Where is
         when Flash => Burst_In_Flash (Toggles);
         when SRAM => Burst_In_SRAM (Toggles);
      end case;
      Cycles := DWT_CYCCNT - Start;
      case Where is
         when Flash => Put ("flash: ");
         when SRAM => Put ("sram: ");
      end case;
      Put_Decimal (Cycles);
      Put (" cycles, XIP ");
      Put_Decimal (XIP_Hits);
      Put (" hits of ");
      Put_Decimal (XIP_Accesses);
      Put_Line (" accesses");
   end Measure;

   procedure Spin (Count : Natural) is
   begin
      for I in 1 .. Count loop
         NOP;
      end loop;
   end Spin;
begin
   Initialize;
   Put_Line ("Memory cartographer");
   Sections.Report;
   Put ("samples at ");
   Put_Hex (Unsigned_32 (To_Integer (Samples'Address)));
   Put_Line ("");

   Setup_LED;
   DEMCR := (DEMCR with delta TRCENA => True);
   DWT_Ctrl := (DWT_Ctrl with delta CYCCNTENA => True);

   --  The first call of each fills the cache; the second does not.
   for Run in 1 .. 2 loop
      Measure (Flash);
      Measure (SRAM);
   end loop;

   Put ("stack: ");
   Put_Decimal (Unsigned_32 (Keel.Startup.Stack_Size
                             - Keel.Startup.Stack_Never_Used));
   Put (" of ");
   Put_Decimal (Unsigned_32 (Keel.Startup.Stack_Size));
   Put_Line (" bytes used");

   --  Bursts for the logic analyzer: flash, a gap, SRAM, a gap.
   loop
      Burst_In_Flash (Toggles);
      Spin (10_000);
      Burst_In_SRAM (Toggles);
      Spin (100_000);
   end loop;
end Memory_Cartographer;
