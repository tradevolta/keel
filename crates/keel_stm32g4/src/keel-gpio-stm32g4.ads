--  SPDX-License-Identifier: Apache-2.0
--  Keel.GPIO on the STM32G4: ports A to G, 16 pins each. Same shape
--  as Keel.GPIO.RP2350: limited pin objects, one owner per pin, and
--  Claim reports through Keel.Status. Claim also turns on the
--  port's clock, so there is no Enable.
package Keel.GPIO.STM32G4
  with Preelaborate
is
   type Port_Id is (A, B, C, D, E, F, G);
   type Pin_Number is range 0 .. 15;

   type Output_Pin (Port : Port_Id; Pin : Pin_Number) is
     limited private;
   type Input_Pin (Port : Port_Id; Pin : Pin_Number) is
     limited private;

   function Is_Claimed (P : Output_Pin) return Boolean;
   function Is_Claimed (P : Input_Pin) return Boolean;

   --  The level the port drives on the pin (ODR)
   function Driven (P : Output_Pin) return Level
     with Pre => Is_Claimed (P);

   --  Push-pull output at Config.Initial. Slow is the low speed
   --  setting, Fast the very high one. In_Use: another object owns
   --  the pin.
   procedure Claim
     (P : in out Output_Pin; Config : Output_Config; Stat : out Status)
     with Pre  => not Is_Claimed (P),
          Post => Is_Claimed (P) = (Stat = Ok)
                  and then (if Stat = Ok
                            then Driven (P) = Config.Initial);

   --  Input with Config.Bias. In_Use: another object owns the pin.
   procedure Claim
     (P : in out Input_Pin; Config : Input_Config; Stat : out Status)
     with Pre  => not Is_Claimed (P),
          Post => Is_Claimed (P) = (Stat = Ok);

   --  Back to analog mode with no pull: the reset state of most pins
   procedure Release (P : in out Output_Pin)
     with Pre => Is_Claimed (P), Post => not Is_Claimed (P);
   procedure Release (P : in out Input_Pin)
     with Pre => Is_Claimed (P), Post => not Is_Claimed (P);

   procedure Set (P : in out Output_Pin; To : Level)
     with Pre => Is_Claimed (P), Post => Driven (P) = To;

   --  The level on the pin (IDR)
   function Get (P : Input_Pin) return Level
     with Pre => Is_Claimed (P);

private
   type Output_Pin (Port : Port_Id; Pin : Pin_Number) is
     limited record
      Claimed : Boolean := False;
   end record;

   type Input_Pin (Port : Port_Id; Pin : Pin_Number) is
     limited record
      Claimed : Boolean := False;
   end record;

   function Is_Claimed (P : Output_Pin) return Boolean is (P.Claimed);
   function Is_Claimed (P : Input_Pin) return Boolean is (P.Claimed);
end Keel.GPIO.STM32G4;
