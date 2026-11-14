--  SPDX-License-Identifier: Apache-2.0
--  Keel.DAC on the STM32G474: DAC1 channel 1, 12 bits, buffered, on
--  PA4 (Arduino A2) and, inside the chip, to the comparators. Its
--  output is VREF+ * code / 4096. On the NUCLEO-G474RE, VREF+ comes
--  from the board's TL1431 reference, 3.25 V with the jumper JP8 on
--  [1-2], as shipped (UM2505 Rev 7, 7.6.3 and Tables 4 and 12).
--  With JP8 on [2-3] it is VDD, 3.3 V: change Reference to match.
--  A driver that takes a Keel.DAC.Output_Signature gets an instance
--  made from Output, Set and Reference.
with Keel.ADC;

package Keel.DAC.STM32G4
  with Preelaborate
is
   Reference : constant Volts := 3.25;

   subtype DAC_Code is Keel.ADC.Code range 0 .. 4_095;

   type Output is limited private;

   function Is_Claimed (O : Output) return Boolean;

   --  Clock DAC1, give it PA4 and turn channel 1 on, at 0 V. AHB is
   --  above 80 MHz, so the interface runs in its high-frequency mode
   --  (DAC_MCR.HFSEL). In_Use: PA4 has another owner.
   procedure Claim (O : in out Output; Stat : out Status)
     with Pre  => not Is_Claimed (O),
          Post => Is_Claimed (O) = (Stat = Ok);

   --  The code for V: V * 4096 / Reference, to the nearest code, and
   --  never above 4095
   function Code_For (V : Volts) return DAC_Code;

   --  The output from the next AHB clock on
   procedure Set_Code (O : in out Output; C : DAC_Code)
     with Pre => Is_Claimed (O);
   procedure Set (O : in out Output; V : Volts)
     with Pre => Is_Claimed (O);
private
   type Output is limited record
      Claimed : Boolean := False;
   end record;

   function Is_Claimed (O : Output) return Boolean is (O.Claimed);
end Keel.DAC.STM32G4;
