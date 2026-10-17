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
