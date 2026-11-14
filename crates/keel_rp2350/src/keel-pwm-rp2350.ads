--  SPDX-License-Identifier: Apache-2.0
--  Keel.PWM on the RP2350: the PWM block's slices. Each slice has
--  one counter and two pins, A and B, which share its setting. An
--  Output drives a pin from its slice; a Counter counts the rising
--  edges on a B pin, which makes a frequency meter.
with Keel.GPIO.RP2350; use Keel.GPIO.RP2350;
with Keel.PWM.Chip_Limits;

package Keel.PWM.RP2350
  with Preelaborate
is
   --  An 8.4 divider from 1.0 to 256.0, a 16-bit counter, and
   --  phase-correct mode
   Slice_Limits : Counter_Limits renames Chip_Limits.RP2350_Slice;

   --  GPIO0 to GPIO29 use slices 0 to 7: GPIO 2N and 2N + 1 are
   --  slice N's A and B, and GPIO16 starts again at slice 0
   --  (datasheet 12.5.2, Table 1183)
   type Slice_Id is range 0 .. 7;

   function Slice_Of (Pin : Pin_Id) return Slice_Id is
     (Slice_Id (Pin / 2 mod 8));

   --  Only a B pin can be a counter's input
   subtype B_Pin is Pin_Id
     with Static_Predicate =>
       B_Pin in 1 | 3 | 5 | 7 | 9 | 11 | 13 | 15 | 17 | 19 | 21 | 23
              | 25 | 27 | 29;

   --  Take the PWM block out of reset. Once, before the first Claim.
   procedure Enable
     with Post => Is_Enabled;
   function Is_Enabled return Boolean;

   type Output (Pin : Pin_Id) is limited private;

   function Is_Claimed (O : Output) return Boolean;
   function Setting_Of (O : Output) return Setting
     with Pre => Is_Claimed (O);

   --  Drive Pin from its slice at S, from level 0 (low). Inverted
   --  swaps high and low (CSR's A_INV or B_INV). In_Use: the pin has
   --  an owner, or its slice already runs another setting or counts.
   procedure Claim
     (O : in out Output; S : Setting; Stat : out Status;
      Inverted : Boolean := False)
     with Pre  => Keel.GPIO.RP2350.Is_Enabled and then Is_Enabled
                  and then not Is_Claimed (O)
                  and then Limits (S) = Slice_Limits,
          Post => Is_Claimed (O) = (Stat = Ok)
                  and then (if Stat = Ok then Setting_Of (O) = S);

   --  The output is high for Level counts of each period (of each
   --  half, in phase-correct mode). Takes effect at the next wrap.
   procedure Set_Level (O : in out Output; Level : Count)
     with Pre => Is_Claimed (O)
                 and then Level <= Top (Setting_Of (O)) + 1;

   type Counter (Pin : B_Pin) is limited private;

   function Is_Claimed (C : Counter) return Boolean;

   --  Count rising edges on Pin. In_Use: the pin has an owner, or
   --  its slice is in use. The input's high and low times must each
   --  be longer than a clk_sys cycle (datasheet 12.5.2.5).
   procedure Claim (C : in out Counter; Stat : out Status)
     with Pre  => Keel.GPIO.RP2350.Is_Enabled and then Is_Enabled
                  and then not Is_Claimed (C),
          Post => Is_Claimed (C) = (Stat = Ok);

   --  Clear the count and the wrap flag, then count
   procedure Start (C : in out Counter)
     with Pre => Is_Claimed (C);
   --  Stop counting; the count stays
   procedure Stop (C : in out Counter)
     with Pre => Is_Claimed (C);
   function Value (C : Counter) return Count
     with Pre => Is_Claimed (C);
   --  The count went past 65_535 since Start: Value has wrapped
   function Wrapped (C : Counter) return Boolean
     with Pre => Is_Claimed (C);
private
   type Output (Pin : Pin_Id) is limited record
      Claimed : Boolean := False;
      S : Setting;
   end record;

   type Counter (Pin : B_Pin) is limited record
      Claimed : Boolean := False;
   end record;

   function Is_Claimed (O : Output) return Boolean is (O.Claimed);
   function Setting_Of (O : Output) return Setting is (O.S);
   function Is_Claimed (C : Counter) return Boolean is (C.Claimed);
end Keel.PWM.RP2350;
