--  SPDX-License-Identifier: Apache-2.0
with STM32G4_SVD;           use STM32G4_SVD;
with STM32G4_SVD.GPIO;      use STM32G4_SVD.GPIO;
with STM32G4_SVD.Pin_Modes; use STM32G4_SVD.Pin_Modes;
with STM32G4_SVD.RCC;       use STM32G4_SVD.RCC;

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
end Keel.GPIO.STM32G4;
