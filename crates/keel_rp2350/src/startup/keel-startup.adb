--  SPDX-License-Identifier: Apache-2.0
with System.Storage_Elements; use System.Storage_Elements;
with Keel.Cortex_M; use Keel.Cortex_M;

package body Keel.Startup is

   --  Symbols that ld/keel-sections.ld defines. Only their addresses
   --  mean anything; Import keeps Ada from touching the "objects".
   Stack_End : Word with Import, External_Name => "__keel_stack_end";
   Data_Start : Word with Import, External_Name => "__keel_data_start";
   Data_End : Word with Import, External_Name => "__keel_data_end";
   Data_Load : constant Word
     with Import, External_Name => "__keel_data_load";
   BSS_Start : Word with Import, External_Name => "__keel_bss_start";
   BSS_End : Word with Import, External_Name => "__keel_bss_end";

   --  The binder's main: elaborates every unit, then calls yours.
   procedure Ada_Main
     with Import, Convention => C, External_Name => "main";

   type Word_Array is array (Storage_Count range <>) of Word;

   --  The minimum Arm IMAGE_DEF (RP2350 datasheet, 5.9.5.1): a block
   --  start marker, an IMAGE_TYPE item (executable, Secure, Arm,
   --  RP2350), a LAST item, a link to itself and an end marker.
   Image_Def : constant Word_Array (1 .. 5) :=
     [16#FFFF_DED3#, 16#1021_0142#, 16#0000_01FF#,
      16#0000_0000#, 16#AB12_3579#]
     with Export, External_Name => "keel_image_def",
          Linker_Section => ".keel.image_def";

   --  The Armv8-M exception vectors 0 .. 15, as a record: GNAT builds
   --  a constant record aggregate in flash at compile time, but an
   --  array aggregate with "others" would need elaboration code. No
   --  interrupt is enabled before Chapter 9, so the 52 interrupt
   --  vectors that follow entry 15 come later.
   type Exception_Vectors is record
      Initial_SP, Reset, NMI, HardFault, MemManage, BusFault,
      UsageFault, SecureFault, Reserved_8, Reserved_9, Reserved_10,
      SVCall, DebugMonitor, Reserved_13, PendSV, SysTick :
        System.Address;
   end record;

   Vectors : constant Exception_Vectors :=
     (Initial_SP => Stack_End'Address,
      Reset => Reset_Handler'Address,
      HardFault => HardFault_Handler'Address,
      others => Default_Handler'Address)
     with Export, External_Name => "keel_vectors",
          Linker_Section => ".keel.vectors";

   procedure Reset_Handler is
      Data_Words : constant Storage_Count :=
        (Data_End'Address - Data_Start'Address) / 4;
      BSS_Words : constant Storage_Count :=
        (BSS_End'Address - BSS_Start'Address) / 4;

      Data : Word_Array (1 .. Data_Words)
        with Import, Address => Data_Start'Address;
      Load : constant Word_Array (1 .. Data_Words)
        with Import, Address => Data_Load'Address;
      BSS : Word_Array (1 .. BSS_Words)
        with Import, Address => BSS_Start'Address;
   begin
      --  1. Let the FPU run: all Keel code is built for hard float.
      SCB.CPACR := (SCB.CPACR with delta CP10 => Full, CP11 => Full);
      DSB;
      ISB;

      --  2. Take exceptions and interrupts through this table.
      SCB.VTOR := Vectors'Address;

      --  3. Copy the initial values of .data from flash to SRAM.
      for I in Data'Range loop
         Data (I) := Load (I);
      end loop;

      --  4. Zero .bss.
      for I in BSS'Range loop
         BSS (I) := 0;
      end loop;

      --  5. Elaborate, then run the main subprogram.
      Ada_Main;

      --  6. A main that returns leaves the core asleep.
      loop
         WFI;
      end loop;
   end Reset_Handler;

   procedure HardFault_Handler is
   begin
      Last_Fault :=
        (CFSR => SCB.CFSR,
         HFSR => SCB.HFSR,
         MMFAR => SCB.MMFAR,
         BFAR => SCB.BFAR);
      loop
         WFI;
      end loop;
   end HardFault_Handler;

   procedure Default_Handler is
   begin
      loop
         WFI;
      end loop;
   end Default_Handler;

   procedure Last_Chance_Handler (File : System.Address; Line : Integer)
   is
   begin
      Last_Exception := (File => File, Line => Line);
      loop
         WFI;
      end loop;
   end Last_Chance_Handler;
end Keel.Startup;
