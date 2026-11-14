--  SPDX-License-Identifier: Apache-2.0
with System.Storage_Elements; use System.Storage_Elements;
with Interfaces; use type Interfaces.Unsigned_32;
with Keel.Cortex_M; use Keel.Cortex_M;

package body Keel.Startup is

   --  Symbols that ld/keel-sections.ld defines. Only their addresses
   --  mean anything; Import keeps Ada from touching the "objects".
   Stack_Start : Word
     with Import, External_Name => "__keel_stack_start";
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

   --  The HardFault handler, in Keel.Fault_Reporter
   procedure HardFault_Entry
     with Import, Convention => C,
          External_Name => "keel_hardfault_entry";

   --  The 52 interrupt handlers. ld/keel-sections.ld makes each one
   --  keel_default_handler unless the program exports its own.
   procedure ISR_0
     with Import, Convention => C, External_Name => "keel_isr_0";
   procedure ISR_1
     with Import, Convention => C, External_Name => "keel_isr_1";
   procedure ISR_2
     with Import, Convention => C, External_Name => "keel_isr_2";
   procedure ISR_3
     with Import, Convention => C, External_Name => "keel_isr_3";
   procedure ISR_4
     with Import, Convention => C, External_Name => "keel_isr_4";
   procedure ISR_5
     with Import, Convention => C, External_Name => "keel_isr_5";
   procedure ISR_6
     with Import, Convention => C, External_Name => "keel_isr_6";
   procedure ISR_7
     with Import, Convention => C, External_Name => "keel_isr_7";
   procedure ISR_8
     with Import, Convention => C, External_Name => "keel_isr_8";
   procedure ISR_9
     with Import, Convention => C, External_Name => "keel_isr_9";
   procedure ISR_10
     with Import, Convention => C, External_Name => "keel_isr_10";
   procedure ISR_11
     with Import, Convention => C, External_Name => "keel_isr_11";
   procedure ISR_12
     with Import, Convention => C, External_Name => "keel_isr_12";
   procedure ISR_13
     with Import, Convention => C, External_Name => "keel_isr_13";
   procedure ISR_14
     with Import, Convention => C, External_Name => "keel_isr_14";
   procedure ISR_15
     with Import, Convention => C, External_Name => "keel_isr_15";
   procedure ISR_16
     with Import, Convention => C, External_Name => "keel_isr_16";
   procedure ISR_17
     with Import, Convention => C, External_Name => "keel_isr_17";
   procedure ISR_18
     with Import, Convention => C, External_Name => "keel_isr_18";
   procedure ISR_19
     with Import, Convention => C, External_Name => "keel_isr_19";
   procedure ISR_20
     with Import, Convention => C, External_Name => "keel_isr_20";
   procedure ISR_21
     with Import, Convention => C, External_Name => "keel_isr_21";
   procedure ISR_22
     with Import, Convention => C, External_Name => "keel_isr_22";
   procedure ISR_23
     with Import, Convention => C, External_Name => "keel_isr_23";
   procedure ISR_24
     with Import, Convention => C, External_Name => "keel_isr_24";
   procedure ISR_25
     with Import, Convention => C, External_Name => "keel_isr_25";
   procedure ISR_26
     with Import, Convention => C, External_Name => "keel_isr_26";
   procedure ISR_27
     with Import, Convention => C, External_Name => "keel_isr_27";
   procedure ISR_28
     with Import, Convention => C, External_Name => "keel_isr_28";
   procedure ISR_29
     with Import, Convention => C, External_Name => "keel_isr_29";
   procedure ISR_30
     with Import, Convention => C, External_Name => "keel_isr_30";
   procedure ISR_31
     with Import, Convention => C, External_Name => "keel_isr_31";
   procedure ISR_32
     with Import, Convention => C, External_Name => "keel_isr_32";
   procedure ISR_33
     with Import, Convention => C, External_Name => "keel_isr_33";
   procedure ISR_34
     with Import, Convention => C, External_Name => "keel_isr_34";
   procedure ISR_35
     with Import, Convention => C, External_Name => "keel_isr_35";
   procedure ISR_36
     with Import, Convention => C, External_Name => "keel_isr_36";
   procedure ISR_37
     with Import, Convention => C, External_Name => "keel_isr_37";
   procedure ISR_38
     with Import, Convention => C, External_Name => "keel_isr_38";
   procedure ISR_39
     with Import, Convention => C, External_Name => "keel_isr_39";
   procedure ISR_40
     with Import, Convention => C, External_Name => "keel_isr_40";
   procedure ISR_41
     with Import, Convention => C, External_Name => "keel_isr_41";
   procedure ISR_42
     with Import, Convention => C, External_Name => "keel_isr_42";
   procedure ISR_43
     with Import, Convention => C, External_Name => "keel_isr_43";
   procedure ISR_44
     with Import, Convention => C, External_Name => "keel_isr_44";
   procedure ISR_45
     with Import, Convention => C, External_Name => "keel_isr_45";
   procedure ISR_46
     with Import, Convention => C, External_Name => "keel_isr_46";
   procedure ISR_47
     with Import, Convention => C, External_Name => "keel_isr_47";
   procedure ISR_48
     with Import, Convention => C, External_Name => "keel_isr_48";
   procedure ISR_49
     with Import, Convention => C, External_Name => "keel_isr_49";
   procedure ISR_50
     with Import, Convention => C, External_Name => "keel_isr_50";
   procedure ISR_51
     with Import, Convention => C, External_Name => "keel_isr_51";

   --  The Armv8-M exception vectors 0 .. 15 and the RP2350's 52
   --  interrupts, as a record: GNAT builds a constant record
   --  aggregate in flash at compile time, but an array aggregate
   --  with "others" would need elaboration code.
   type Exception_Vectors is record
      Initial_SP, Reset, NMI, HardFault, MemManage, BusFault,
      UsageFault, SecureFault, Reserved_8, Reserved_9, Reserved_10,
      SVCall, DebugMonitor, Reserved_13, PendSV, SysTick,
      IRQ_0, IRQ_1, IRQ_2, IRQ_3, IRQ_4, IRQ_5,
      IRQ_6, IRQ_7, IRQ_8, IRQ_9, IRQ_10, IRQ_11,
      IRQ_12, IRQ_13, IRQ_14, IRQ_15, IRQ_16, IRQ_17,
      IRQ_18, IRQ_19, IRQ_20, IRQ_21, IRQ_22, IRQ_23,
      IRQ_24, IRQ_25, IRQ_26, IRQ_27, IRQ_28, IRQ_29,
      IRQ_30, IRQ_31, IRQ_32, IRQ_33, IRQ_34, IRQ_35,
      IRQ_36, IRQ_37, IRQ_38, IRQ_39, IRQ_40, IRQ_41,
      IRQ_42, IRQ_43, IRQ_44, IRQ_45, IRQ_46, IRQ_47,
      IRQ_48, IRQ_49, IRQ_50, IRQ_51 :
        System.Address;
   end record;

   Vectors : constant Exception_Vectors :=
     (Initial_SP => Stack_End'Address,
      Reset => Reset_Handler'Address,
      HardFault => HardFault_Entry'Address,
      IRQ_0 => ISR_0'Address,
      IRQ_1 => ISR_1'Address,
      IRQ_2 => ISR_2'Address,
      IRQ_3 => ISR_3'Address,
      IRQ_4 => ISR_4'Address,
      IRQ_5 => ISR_5'Address,
      IRQ_6 => ISR_6'Address,
      IRQ_7 => ISR_7'Address,
      IRQ_8 => ISR_8'Address,
      IRQ_9 => ISR_9'Address,
      IRQ_10 => ISR_10'Address,
      IRQ_11 => ISR_11'Address,
      IRQ_12 => ISR_12'Address,
      IRQ_13 => ISR_13'Address,
      IRQ_14 => ISR_14'Address,
      IRQ_15 => ISR_15'Address,
      IRQ_16 => ISR_16'Address,
      IRQ_17 => ISR_17'Address,
      IRQ_18 => ISR_18'Address,
      IRQ_19 => ISR_19'Address,
      IRQ_20 => ISR_20'Address,
      IRQ_21 => ISR_21'Address,
      IRQ_22 => ISR_22'Address,
      IRQ_23 => ISR_23'Address,
      IRQ_24 => ISR_24'Address,
      IRQ_25 => ISR_25'Address,
      IRQ_26 => ISR_26'Address,
      IRQ_27 => ISR_27'Address,
      IRQ_28 => ISR_28'Address,
      IRQ_29 => ISR_29'Address,
      IRQ_30 => ISR_30'Address,
      IRQ_31 => ISR_31'Address,
      IRQ_32 => ISR_32'Address,
      IRQ_33 => ISR_33'Address,
      IRQ_34 => ISR_34'Address,
      IRQ_35 => ISR_35'Address,
      IRQ_36 => ISR_36'Address,
      IRQ_37 => ISR_37'Address,
      IRQ_38 => ISR_38'Address,
      IRQ_39 => ISR_39'Address,
      IRQ_40 => ISR_40'Address,
      IRQ_41 => ISR_41'Address,
      IRQ_42 => ISR_42'Address,
      IRQ_43 => ISR_43'Address,
      IRQ_44 => ISR_44'Address,
      IRQ_45 => ISR_45'Address,
      IRQ_46 => ISR_46'Address,
      IRQ_47 => ISR_47'Address,
      IRQ_48 => ISR_48'Address,
      IRQ_49 => ISR_49'Address,
      IRQ_50 => ISR_50'Address,
      IRQ_51 => ISR_51'Address,
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

      --  5. Paint the stack below this frame, for Stack_Never_Used.
      declare
         Free : constant Storage_Count :=
           (Stack_Pointer - Stack_Start'Address) / 4;
         Below : Word_Array (1 .. Free)
           with Import, Volatile, Address => Stack_Start'Address;
      begin
         for I in Below'Range loop
            Below (I) := Stack_Pattern;
         end loop;
      end;

      --  6. Elaborate, then run the main subprogram.
      Ada_Main;

      --  7. A main that returns leaves the core asleep.
      loop
         WFI;
      end loop;
   end Reset_Handler;

   function Stack_Size return Storage_Count is
     (Stack_End'Address - Stack_Start'Address);

   function Stack_Never_Used return Storage_Count is
      Stack : Word_Array (1 .. Stack_Size / 4)
        with Import, Volatile, Address => Stack_Start'Address;
   begin
      for I in Stack'Range loop
         if Stack (I) /= Stack_Pattern then
            return (I - 1) * 4;
         end if;
      end loop;
      return Stack_Size;
   end Stack_Never_Used;

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
