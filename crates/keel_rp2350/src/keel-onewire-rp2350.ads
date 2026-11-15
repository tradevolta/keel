--  SPDX-License-Identifier: Apache-2.0
--  Keel.OneWire on the RP2350: the bus run by a PIO state machine and
--  Keel.PIO.OneWire_Program, so each time slot's timing is the
--  machine's, not the processor's, and an interrupt cannot stretch
--  it. The pin needs an external pull-up (4.7 kohm to 3.3 V).
--  Reset and Touch provide Keel.OneWire.Bus_Signature.
with Keel.PIO.RP2350; use Keel.PIO.RP2350;
with Keel.Time;

package Keel.OneWire.RP2350 is
   type Bus (B : Block; M : Machine; Pin : Pin_Id) is limited private;

   function Is_Open (Wire : Bus) return Boolean;

   --  Load the program into block B, claim M and the pin, and start
   --  M at 1 MHz from a system clock of Clock_Hz. Not_Supported: no
   --  room in B. In_Use: M or the pin has an owner.
   procedure Open
     (Wire     : in out Bus;
      Clock_Hz : Positive;
      Stat     : out Keel.Status)
     with Pre  => Is_Enabled (Wire.B) and then not Is_Open (Wire)
                  and then Clock_Hz >= 1_000_000,
          Post => Is_Open (Wire) = (Stat = Keel.Ok);

   --  The reset pulse and the presence sample: 962 us.
   --  Timeout: the machine did not answer within 2 ms.
   procedure Reset
     (Wire : in out Bus; Present : out Boolean; Stat : out Status)
     with Pre => Is_Open (Wire);

   --  One 70 us slot. Timeout: no answer within 1 ms.
   procedure Touch
     (Wire : in out Bus; Bit : Boolean; Got : out Boolean;
      Stat : out Status)
     with Pre => Is_Open (Wire);

private
   type Bus (B : Block; M : Machine; Pin : Pin_Id) is limited record
      Open   : Boolean := False;
      Offset : Keel.PIO.Address := 0;
   end record;

   function Is_Open (Wire : Bus) return Boolean is (Wire.Open);

   Reset_Wait : constant Keel.Time.Time_Span :=
     Keel.Time.Milliseconds (2);
   Slot_Wait  : constant Keel.Time.Time_Span :=
     Keel.Time.Milliseconds (1);
end Keel.OneWire.RP2350;
