--  SPDX-License-Identifier: Apache-2.0
with STM32G4_SVD;           use STM32G4_SVD;
with STM32G4_SVD.GPIO;      use STM32G4_SVD.GPIO;
with STM32G4_SVD.Pin_Modes; use STM32G4_SVD.Pin_Modes;
with STM32G4_SVD.RCC;       use STM32G4_SVD.RCC;
with System;
with Interfaces;            use Interfaces;

package body Keel.GPIO.STM32G4 is

   type Port_Access is access all GPIO_Peripheral;

   --  Every port has the same layout: one record type serves all
   function Port (Id : Port_Id) return not null Port_Access is
     (case Id is
         when A => GPIOA_Periph'Access,
         when B => GPIOB_Periph'Access,
         when C => GPIOC_Periph'Access,
         when D => GPIOD_Periph'Access,
         when E => GPIOE_Periph'Access,
         when F => GPIOF_Periph'Access,
         when G => GPIOG_Periph'Access);

   --  The pins that have an owner
   Taken : array (Port_Id, Pin_Number) of Boolean :=
     [others => [others => False]];

   --  RM0440, GPIOx_PUPDR and GPIOx_OSPEEDR encodings
   Pull_Code : constant array (Pull) of UInt2 :=
     [Floating => 2#00#, Pull_Up => 2#01#, Pull_Down => 2#10#];
   Speed_Code : constant array (Slew_Rate) of UInt2 :=
     [Slow => 2#00#, Fast => 2#11#];

   procedure Clock_On (Id : Port_Id) is
      Enables : RCC_AHB2ENR_Register := RCC_Periph.RCC_AHB2ENR;
   begin
      case Id is
         when A => Enables.GPIOAEN := B_0x1;
         when B => Enables.GPIOBEN := B_0x1;
         when C => Enables.GPIOCEN := B_0x1;
         when D => Enables.GPIODEN := B_0x1;
         when E => Enables.GPIOEEN := B_0x1;
         when F => Enables.GPIOFEN := B_0x1;
         when G => Enables.GPIOGEN := B_0x1;
      end case;
      RCC_Periph.RCC_AHB2ENR := Enables;
   end Clock_On;

   --  One pin's bit in BSRR: set it (High) or reset it (Low)
   procedure Drive (Id : Port_Id; P : Pin_Number; To : Level) is
      Bit : constant BSRR_BS_Field_Array :=
        [for I in BSRR_BS_Field_Array'Range => I = Integer (P)];
      None : constant BSRR_BS_Field_Array := [others => False];
   begin
      if To = High then
         Port (Id).BSRR :=
           (BS => (As_Array => True, Arr => Bit),
            BR => (As_Array => True,
                   Arr => BSRR_BR_Field_Array (None)));
      else
         Port (Id).BSRR :=
           (BS => (As_Array => True, Arr => None),
            BR => (As_Array => True,
                   Arr => BSRR_BR_Field_Array (Bit)));
      end if;
   end Drive;

   procedure Set_Pull (Id : Port_Id; P : Pin_Number; To : Pull) is
      Pulls : PUPDR_Register := Port (Id).PUPDR;
   begin
      Pulls.Arr (Integer (P)) := Pull_Code (To);
      Port (Id).PUPDR := Pulls;
   end Set_Pull;

   function Driven (P : Output_Pin) return Level is
     (if Port (P.Port).ODR.ODR.Arr (Integer (P.Pin)) then High
      else Low);

   procedure Claim
     (P : in out Output_Pin; Config : Output_Config; Stat : out Status)
   is
      Speeds : OSPEEDR_Register;
   begin
      if Taken (P.Port, P.Pin) then
         Stat := In_Use;
         return;
      end if;

      Clock_On (P.Port);
      --  Level and pad settings first, mode last: the pin never
      --  drives anything but Config.Initial.
      Drive (P.Port, P.Pin, Config.Initial);
      Speeds := Port (P.Port).OSPEEDR;
      Speeds.Arr (Integer (P.Pin)) := Speed_Code (Config.Slew);
      Port (P.Port).OSPEEDR := Speeds;
      Set_Pull (P.Port, P.Pin, Floating);
      Set_Mode (Port (P.Port).all, Pin (P.Pin), Output);

      Taken (P.Port, P.Pin) := True;
      P.Claimed := True;
      Stat := Ok;
   end Claim;

   procedure Claim
     (P : in out Input_Pin; Config : Input_Config; Stat : out Status)
   is
   begin
      if Taken (P.Port, P.Pin) then
         Stat := In_Use;
         return;
      end if;

      Clock_On (P.Port);
      Set_Pull (P.Port, P.Pin, Config.Bias);
      Set_Mode (Port (P.Port).all, Pin (P.Pin), Input);

      Taken (P.Port, P.Pin) := True;
      P.Claimed := True;
      Stat := Ok;
   end Claim;

   procedure Reserve
     (Id : Port_Id; P : Pin_Number; AF : Alternate_Function;
      Stat : out Status)
   is
   begin
      if Taken (Id, P) then
         Stat := In_Use;
         return;
      end if;

      --  Read the port's registers only once its clock runs
      Clock_On (Id);
      declare
         Low_Half  : AFRL_Register := Port (Id).AFRL;
         High_Half : AFRH_Register := Port (Id).AFRH;
         Speeds    : OSPEEDR_Register := Port (Id).OSPEEDR;
      begin
         --  The function first, then the mode that connects it
         if P < 8 then
            Low_Half.Arr (Integer (P)) := UInt4 (AF);
            Port (Id).AFRL := Low_Half;
         else
            High_Half.Arr (Integer (P)) := UInt4 (AF);
            Port (Id).AFRH := High_Half;
         end if;
         Speeds.Arr (Integer (P)) := Speed_Code (Fast);
         Port (Id).OSPEEDR := Speeds;
      end;
      Set_Mode (Port (Id).all, Pin (P), Alternate);

      Taken (Id, P) := True;
      Stat := Ok;
   end Reserve;

   procedure Free (Id : Port_Id; P : Pin_Number) is
   begin
      Set_Mode (Port (Id).all, Pin (P), Analog);
      Set_Pull (Id, P, Floating);
      Taken (Id, P) := False;
   end Free;

   procedure Release (P : in out Output_Pin) is
   begin
      Free (P.Port, P.Pin);
      P.Claimed := False;
   end Release;

   procedure Release (P : in out Input_Pin) is
   begin
      Free (P.Port, P.Pin);
      P.Claimed := False;
   end Release;

   procedure Set (P : in out Output_Pin; To : Level) is
   begin
      Drive (P.Port, P.Pin, To);
   end Set;

   function Get (P : Input_Pin) return Level is
     (if Port (P.Port).IDR.IDR.Arr (Integer (P.Pin)) then High
      else Low);

   --  SYSCFG (0x4001_0000) EXTICR1 to 4: a 4-bit port code per line,
   --  4 lines a word. EXTI (0x4001_0400): IMR1, RTSR1, FTSR1, PR1,
   --  one bit per line. Words here, as on the RP2350.
   type Four_Words is array (0 .. 3) of Unsigned_32
     with Volatile_Components;
   EXTICR : Four_Words
     with Import, Address => System'To_Address (16#4001_0008#);

   IMR1 : Unsigned_32
     with Volatile, Import,
          Address => System'To_Address (16#4001_0400#);
   RTSR1 : Unsigned_32
     with Volatile, Import,
          Address => System'To_Address (16#4001_0408#);
   FTSR1 : Unsigned_32
     with Volatile, Import,
          Address => System'To_Address (16#4001_040C#);
   PR1 : Unsigned_32
     with Volatile, Import,
          Address => System'To_Address (16#4001_0414#);

   function Line (P : Input_Pin) return Unsigned_32 is
     (Shift_Left (1, Natural (P.Pin)));

   procedure Watch (P : Input_Pin; On : Edges) is
      Row   : constant Natural := Natural (P.Pin) / 4;
      Shift : constant Natural := 4 * (Natural (P.Pin) mod 4);
      Enables : RCC_APB2ENR_Register := RCC_Periph.RCC_APB2ENR;
   begin
      --  SYSCFG holds EXTICR: give it its clock first
      Enables.SYSCFGEN := B_0x1;
      RCC_Periph.RCC_APB2ENR := Enables;
      EXTICR (Row) :=
        (EXTICR (Row) and not Shift_Left (16#F#, Shift))
        or Shift_Left (Port_Id'Pos (P.Port), Shift);
      RTSR1 := (if On.Rising then RTSR1 or Line (P)
                else RTSR1 and not Line (P));
      FTSR1 := (if On.Falling then FTSR1 or Line (P)
                else FTSR1 and not Line (P));
      IMR1 := (if On.Rising or On.Falling then IMR1 or Line (P)
               else IMR1 and not Line (P));
   end Watch;

   function Pending (P : Input_Pin) return Boolean is
     ((PR1 and Line (P)) /= 0);

   procedure Acknowledge (P : Input_Pin) is
   begin
      PR1 := Line (P);
   end Acknowledge;
end Keel.GPIO.STM32G4;
