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
