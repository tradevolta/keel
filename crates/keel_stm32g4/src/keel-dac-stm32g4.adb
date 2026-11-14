--  SPDX-License-Identifier: Apache-2.0
with STM32G4_SVD;     use STM32G4_SVD;
with STM32G4_SVD.DAC; use STM32G4_SVD.DAC;
with STM32G4_SVD.RCC; use STM32G4_SVD.RCC;
with Keel.GPIO.STM32G4;

package body Keel.DAC.STM32G4 is

   --  MCR.HFSEL: 1 for an AHB clock above 80 MHz
   Above_80_MHz : constant DAC_MCR_HFSEL_Field := 1;

   procedure Claim (O : in out Output; Stat : out Status) is
   begin
      Keel.GPIO.STM32G4.Reserve_Analog (Keel.GPIO.STM32G4.A, 4, Stat);
      if Stat /= Ok then
         return;
      end if;
      RCC_Periph.RCC_AHB2ENR.DAC1EN := B_0x1;
      --  MODE1 = 0: buffer on, output on the pin. MCR is written
      --  only while the channel is off.
      DAC1_Periph.DAC_MCR := (HFSEL => Above_80_MHz, others => <>);
      DAC1_Periph.DAC_DHR12R1 := (DACC1DHR => 0, others => <>);
      DAC1_Periph.DAC_CR := (EN1 => True, others => <>);
      O.Claimed := True;
   end Claim;

   function Code_For (V : Volts) return DAC_Code is
      Mv : constant Long_Long_Integer :=
        Long_Long_Integer (Volts'Max (V, 0.0) / Volts'(0.001));
      C  : constant Long_Long_Integer := (Mv * 4_096 + 1_650) / 3_300;
   begin
      return DAC_Code (Long_Long_Integer'Min (C, 4_095));
   end Code_For;

   procedure Set_Code (O : in out Output; C : DAC_Code) is
   begin
      DAC1_Periph.DAC_DHR12R1 :=
        (DACC1DHR => DAC_DHR12R1_DACC1DHR_Field (C), others => <>);
   end Set_Code;

   procedure Set (O : in out Output; V : Volts) is
   begin
      Set_Code (O, Code_For (V));
   end Set;
end Keel.DAC.STM32G4;
