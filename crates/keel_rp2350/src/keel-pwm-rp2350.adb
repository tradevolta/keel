--  SPDX-License-Identifier: Apache-2.0
with RP2350_SVD;            use RP2350_SVD;
with RP2350_SVD.Atomic;
with RP2350_SVD.PWM;        use RP2350_SVD.PWM;
with RP2350_SVD.PWM_Slices; use RP2350_SVD.PWM_Slices;
with RP2350_SVD.RESETS;     use RP2350_SVD.RESETS;

package body Keel.PWM.RP2350 is

   package Reset_Bits is new RP2350_SVD.Atomic (RESET_Register);

   --  What each slice is doing: driving up to two outputs at one
   --  setting, or counting
   type Slice_State is record
      Users : Natural range 0 .. 2 := 0;
      Current : Setting;
      Counting : Boolean := False;
   end record;

   State : array (Slice_Id) of Slice_State;

   function Reg (Id : Slice_Id) return Slice is (Slice (Id));

   function Is_A (Pin : Pin_Id) return Boolean is (Pin mod 2 = 0);

   procedure Enable is
   begin
      Reset_Bits.Clear
        (RESETS_Periph.RESET,
         (Reset_Bits.No_Bits with delta PWM => True));
      loop
         exit when Is_Enabled;
      end loop;
   end Enable;

   function Is_Enabled return Boolean is
     (RESETS_Periph.RESET_DONE.PWM);

   --  DIV holds the divider in 8.4 bits; an INT of 0 means 256
   function Divider_Of (S : Setting) return CH0_DIV_Register is
     (INT => CH0_DIV_INT_Field (Div (S) / 16 mod 256),
      FRAC => CH0_DIV_FRAC_Field (Div (S) mod 16),
      others => <>);

   procedure Claim
     (O : in out Output; S : Setting; Stat : out Status;
      Inverted : Boolean := False)
   is
      Id : constant Slice_Id := Slice_Of (O.Pin);
      Slice_Now : Slice_State renames State (Id);
      CSR : CH0_CSR_Register;
   begin
      if Slice_Now.Counting
        or else (Slice_Now.Users > 0 and then Slice_Now.Current /= S)
      then
         Stat := In_Use;
         return;
      end if;
      Reserve (O.Pin, Stat);
      if Stat /= Ok then
         return;
      end if;

      if Slice_Now.Users = 0 then
         --  Stopped while it changes; both levels 0, so both low
         Slices (Reg (Id)).CSR := (EN => False, others => <>);
         Slices (Reg (Id)).DIV := Divider_Of (S);
         Slices (Reg (Id)).TOP := (CH0_TOP => UInt16 (Top (S)),
                                   others => <>);
         Slices (Reg (Id)).CC := (A => 0, B => 0);
         Slices (Reg (Id)).CTR := (CH0_CTR => 0, others => <>);
      end if;
      CSR := Slices (Reg (Id)).CSR;
      if Is_A (O.Pin) then
         CSR.A_INV := Inverted;
      else
         CSR.B_INV := Inverted;
      end if;
      CSR.PH_CORRECT := Mode (S) = Phase_Correct;
      CSR.DIVMODE := div;
      CSR.EN := True;
      Slices (Reg (Id)).CSR := CSR;
      Select_Function (O.Pin, PWM_Function);

      Slice_Now.Users := Slice_Now.Users + 1;
      Slice_Now.Current := S;
      O.S := S;
      O.Claimed := True;
   end Claim;

   procedure Set_Level (O : in out Output; Level : Count) is
      Id : constant Slice_Id := Slice_Of (O.Pin);
      CC : CH0_CC_Register := Slices (Reg (Id)).CC;
   begin
      if Is_A (O.Pin) then
         CC.A := UInt16 (Level);
      else
         CC.B := UInt16 (Level);
      end if;
      Slices (Reg (Id)).CC := CC;
   end Set_Level;

   procedure Claim (C : in out Counter; Stat : out Status) is
      Id : constant Slice_Id := Slice_Of (C.Pin);
   begin
      if State (Id).Counting or else State (Id).Users > 0 then
         Stat := In_Use;
         return;
      end if;
      Reserve (C.Pin, Stat);
      if Stat /= Ok then
         return;
      end if;
      --  One count per rising edge on B: divider 1.0, the full
      --  16-bit range
      Slices (Reg (Id)).CSR := (DIVMODE => rise, others => <>);
      Slices (Reg (Id)).DIV := (INT => 1, FRAC => 0, others => <>);
      Slices (Reg (Id)).TOP := (CH0_TOP => 16#FFFF#, others => <>);
      Select_Function (C.Pin, PWM_Function);
      State (Id).Counting := True;
      C.Claimed := True;
   end Claim;

   --  This slice's bit in INTR, set at each wrap; write 1 to clear
   function Only (Id : Slice_Id) return INTR_Register is
     (CH => (As_Array => True,
             Arr => [for I in INTR_CH_Field_Array'Range =>
                       I = Natural (Id)]),
      others => <>);

   procedure Start (C : in out Counter) is
      Id : constant Slice_Id := Slice_Of (C.Pin);
   begin
      Slices (Reg (Id)).CSR.EN := False;
      Slices (Reg (Id)).CTR := (CH0_CTR => 0, others => <>);
      PWM_Periph.INTR := Only (Id);
      Slices (Reg (Id)).CSR.EN := True;
   end Start;

   procedure Stop (C : in out Counter) is
   begin
      Slices (Reg (Slice_Of (C.Pin))).CSR.EN := False;
   end Stop;

   function Value (C : Counter) return Count is
     (Count (Slices (Reg (Slice_Of (C.Pin))).CTR.CH0_CTR));

   function Wrapped (C : Counter) return Boolean is
     (PWM_Periph.INTR.CH.Arr (Natural (Slice_Of (C.Pin))));
end Keel.PWM.RP2350;
