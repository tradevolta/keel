generic
   type Bus (<>) is limited private;
   --  The reset pulse; Present: a device answered it
   with procedure Reset
     (B : in out Bus; Present : out Boolean; Stat : out Status);
   --  One time slot. Writing a 1 lets the line go, so a device may
   --  pull it low: Got is the level sampled, which is a read. A 0
   --  holds it low, and Got is False.
   with procedure Touch
     (B : in out Bus; Bit : Boolean; Got : out Boolean;
      Stat : out Status);
package Bus_Signature is
   pragma Warnings (Off, Reset);
   pragma Warnings (Off, Touch);
end Bus_Signature;
