--  SPDX-License-Identifier: Apache-2.0
--  Keel.GPIO on the RP2350: bank 0 pins driven by SIO. A pin object
--  is limited, so it cannot be copied, and Claim refuses a pin that
--  another object already owns: each pin has one owner.
package Keel.GPIO.RP2350
  with Preelaborate
is
   --  Bank 0 of the RP2350A (QFN-60): GPIO0 to GPIO29
   type Pin_Id is range 0 .. 29;

   --  Pad drive strength, an RP2350 extra (reset value: 4 mA)
   type Drive_Current is (Drive_2mA, Drive_4mA, Drive_8mA, Drive_12mA);

   type Output_Pin (Id : Pin_Id) is limited private;
   type Input_Pin (Id : Pin_Id) is limited private;

   --  Take IO_BANK0 and PADS_BANK0 out of reset. Call it once,
   --  before the first Claim.
   procedure Enable
     with Post => Is_Enabled;
   function Is_Enabled return Boolean;

   function Is_Claimed (P : Output_Pin) return Boolean;
   function Is_Claimed (P : Input_Pin) return Boolean;

   --  The level SIO drives on the pin (GPIO_OUT)
   function Driven (P : Output_Pin) return Level
     with Pre => Is_Claimed (P);

   --  Connect the pin to SIO as an output at Config.Initial.
   --  In_Use: another object owns the pin.
   procedure Claim
     (P      : in out Output_Pin;
      Config : Output_Config;
      Stat   : out Status;
      Drive  : Drive_Current := Drive_4mA)
     with Pre  => Is_Enabled and then not Is_Claimed (P),
          Post => Is_Claimed (P) = (Stat = Ok)
                  and then (if Stat = Ok
                            then Driven (P) = Config.Initial);

   --  Connect the pin to SIO as an input. In_Use: another object
   --  owns the pin. Not_Supported: Pull_Down on an A2 chip, whose
   --  pull-down cannot hold a pin low (erratum RP2350-E9).
   procedure Claim
     (P : in out Input_Pin; Config : Input_Config; Stat : out Status)
     with Pre  => Is_Enabled and then not Is_Claimed (P),
          Post => Is_Claimed (P) = (Stat = Ok);

   --  Give pin Id to a peripheral: mark it taken and connect its
   --  pad, input and output, so the peripheral's function can drive
   --  it, with Bias on the pad. The caller selects the function.
   --  In_Use: it has an owner.
   procedure Reserve
     (Id : Pin_Id; Stat : out Status; Bias : Pull := Floating)
     with Pre => Is_Enabled;

   --  Give pin Id to the ADC: mark it taken, and turn its pad's
   --  digital input off and its output off (IE low, OD high, no
   --  pulls), as datasheet 12.4 asks. In_Use: it has an owner.
   procedure Reserve_Analog (Id : Pin_Id; Stat : out Status)
     with Pre => Is_Enabled;

   --  IO_BANK0's function numbers (datasheet 9.4, Table 677) as
   --  the generated FUNCSEL type, GPIO0's, lists them: 0 to 10, and
   --  31 for none. F11, a UART on a few pins, isn't offered yet.
   type Function_Number is range 0 .. 31
     with Static_Predicate => Function_Number in 0 .. 10 | 31;
   PWM_Function : constant Function_Number := 4;

   --  Connect pin Id, reserved by the caller, to function F
   procedure Select_Function (Id : Pin_Id; F : Function_Number)
     with Pre => Is_Enabled;

   --  Return the pin to its reset state: isolated, no function
   procedure Release (P : in out Output_Pin)
     with Pre => Is_Claimed (P), Post => not Is_Claimed (P);
   procedure Release (P : in out Input_Pin)
     with Pre => Is_Claimed (P), Post => not Is_Claimed (P);

   procedure Set (P : in out Output_Pin; To : Level)
     with Pre => Is_Claimed (P), Post => Driven (P) = To;

   --  The level on the pad (GPIO_IN)
   function Get (P : Input_Pin) return Level
     with Pre => Is_Claimed (P);

   --  Edge interrupts, on IO_IRQ_BANK0 of processor 0 (datasheet
   --  9.5). The pad latches each edge until it is acknowledged.
   type Edges is record
      Falling, Rising : Boolean := False;
   end record;

   --  Raise IO_IRQ_BANK0 on these edges of P, and on no others
   procedure Watch (P : Input_Pin; On : Edges)
     with Pre => Is_Claimed (P);

   --  The watched edges latched on P (PROC0_INTS)
   function Seen (P : Input_Pin) return Edges
     with Pre => Is_Claimed (P);

   --  Clear the latched edges in Which (INTR, write 1 to clear)
   procedure Acknowledge (P : Input_Pin; Which : Edges)
     with Pre => Is_Claimed (P);

private
   type Output_Pin (Id : Pin_Id) is limited record
      Claimed : Boolean := False;
   end record;

   type Input_Pin (Id : Pin_Id) is limited record
      Claimed : Boolean := False;
   end record;

   function Is_Claimed (P : Output_Pin) return Boolean is (P.Claimed);
   function Is_Claimed (P : Input_Pin) return Boolean is (P.Claimed);
end Keel.GPIO.RP2350;
