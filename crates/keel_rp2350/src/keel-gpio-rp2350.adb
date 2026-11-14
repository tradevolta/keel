--  SPDX-License-Identifier: Apache-2.0
with RP2350_SVD;            use RP2350_SVD;
with RP2350_SVD.Atomic;
with RP2350_SVD.IO_BANK0;   use RP2350_SVD.IO_BANK0;
with RP2350_SVD.PADS_BANK0; use RP2350_SVD.PADS_BANK0;
with RP2350_SVD.RESETS;     use RP2350_SVD.RESETS;
with RP2350_SVD.SIO_Pins;   use RP2350_SVD.SIO_Pins;
with RP2350_SVD.SYSINFO;    use RP2350_SVD.SYSINFO;
with System;
with Interfaces;            use Interfaces;

package body Keel.GPIO.RP2350 is

   --  Each GPIOn_CTRL has its own type in the generated code. The
   --  layouts are the same and function 5 is SIO on every pin, so
   --  GPIO0's types describe any pin, and an array of them puts
   --  the loop back. Each pin has STATUS, then CTRL: 8 bytes.
   type Pin_Registers is record
      Status  : GPIO0_STATUS_Register;
      Control : GPIO0_CTRL_Register;
   end record;

   for Pin_Registers use record
      Status  at 0 range 0 .. 31;
      Control at 4 range 0 .. 31;
   end record;

   type Pin_Array is array (Pin_Id) of Pin_Registers;
   IO : Pin_Array
     with Import, Address => IO_BANK0_Periph'Address;

   --  The pad registers already share one type
   type Pad_Array is array (Pin_Id) of GPIO_Register;
   Pads : Pad_Array
     with Import, Address => PADS_BANK0_Periph.GPIO0'Address;

   SIO_Function : constant GPIO0_CTRL_Register :=
     (FUNCSEL => sio_0, others => <>);

   --  The pins that have an owner
   Taken : Pin_Set := [others => False];

   --  Each pin's bit, built once at elaboration (120 bytes of RAM):
   --  every Set is then a lookup, not a loop over all 32 pins
   Bits : constant array (Pin_Id) of Pin_Set :=
     [for Id in Pin_Id => [for P in Pin => P = Pin (Id)]];

   function Only (Id : Pin_Id) return Pin_Set is (Bits (Id));

   package Reset_Bits is new RP2350_SVD.Atomic (RESET_Register);

   procedure Enable is
   begin
      Reset_Bits.Clear
        (RESETS_Periph.RESET,
         (Reset_Bits.No_Bits with delta
            IO_BANK0 => True, PADS_BANK0 => True));
      loop
         exit when Is_Enabled;
      end loop;
   end Enable;

   function Is_Enabled return Boolean is
      Done : constant RESET_DONE_Register := RESETS_Periph.RESET_DONE;
   begin
      return Done.IO_BANK0 and then Done.PADS_BANK0;
   end Is_Enabled;

   --  CHIP_ID.REVISION is 2 on stepping A2 (datasheet, Appendix C)
   function Is_A2 return Boolean is
     (SYSINFO_Periph.CHIP_ID.REVISION = 2);

   function Driven (P : Output_Pin) return Level is
     (if Output (Pin (P.Id)) then High else Low);

   procedure Claim
     (P      : in out Output_Pin;
      Config : Output_Config;
      Stat   : out Status;
      Drive  : Drive_Current := Drive_4mA)
   is
      Bit : constant Pin_Set := Only (P.Id);
   begin
      if Taken (Pin (P.Id)) then
         Stat := In_Use;
         return;
      end if;

      --  Level, then output enable, then function, then pad: the
      --  pin never drives anything but Config.Initial.
      if Config.Initial = High then
         Output_Set (Bit);
      else
         Output_Clear (Bit);
      end if;
      Enable_Output (Bit);
      IO (P.Id).Control := SIO_Function;
      Pads (P.Id) :=
        (SLEWFAST => Config.Slew = Fast,
         PDE      => False,
         DRIVE    => GPIO0_DRIVE_Field'Val (Drive_Current'Pos (Drive)),
         ISO      => False,
         others   => <>);

      Taken := Taken or Bit;
      P.Claimed := True;
      Stat := Ok;
   end Claim;

   procedure Claim
     (P : in out Input_Pin; Config : Input_Config; Stat : out Status)
   is
      Bit : constant Pin_Set := Only (P.Id);
   begin
      if Taken (Pin (P.Id)) then
         Stat := In_Use;
      elsif Config.Bias = Pull_Down and then Is_A2 then
         Stat := Not_Supported;
      else
         Disable_Output (Bit);
         IO (P.Id).Control := SIO_Function;
         Pads (P.Id) :=
           (PUE    => Config.Bias = Pull_Up,
            PDE    => Config.Bias = Pull_Down,
            IE     => True,
            ISO    => False,
            others => <>);

         Taken := Taken or Bit;
         P.Claimed := True;
         Stat := Ok;
      end if;
   end Claim;

   procedure Reserve (Id : Pin_Id; Stat : out Status) is
   begin
      if Taken (Pin (Id)) then
         Stat := In_Use;
      else
         Pads (Id) :=
           (SLEWFAST => True, PDE => False, IE => True, ISO => False,
            others => <>);
         Taken (Pin (Id)) := True;
         Stat := Ok;
      end if;
   end Reserve;

   procedure Select_Function (Id : Pin_Id; F : Function_Number) is
      Control : GPIO0_CTRL_Register := IO (Id).Control;
   begin
      --  FUNCSEL is an enumeration in the generated code; its
      --  values are the function numbers
      Control.FUNCSEL := GPIO0_CTRL_FUNCSEL_Field'Enum_Val (F);
      IO (Id).Control := Control;
   end Select_Function;

   --  Pad first: isolate the pin, then take its function away
   procedure Free (Id : Pin_Id) is
   begin
      Pads (Id) := (others => <>);
      IO (Id).Control := (others => <>);
      Disable_Output (Only (Id));
      Taken (Pin (Id)) := False;
   end Free;

   procedure Release (P : in out Output_Pin) is
   begin
      Free (P.Id);
      P.Claimed := False;
   end Release;

   procedure Release (P : in out Input_Pin) is
   begin
      Free (P.Id);
      P.Claimed := False;
   end Release;

   procedure Set (P : in out Output_Pin; To : Level) is
   begin
      if To = High then
         Output_Set (Only (P.Id));
      else
         Output_Clear (Only (P.Id));
      end if;
   end Set;

   function Get (P : Input_Pin) return Level is
     (if Input (Pin (P.Id)) then High else Low);

   --  The interrupt registers hold 4 bits per pin, 8 pins a word:
   --  LEVEL_LOW, LEVEL_HIGH, EDGE_LOW, EDGE_HIGH. The generated
   --  types name every pin's bits apart, so here they are words.
   --  IO_BANK0 is at 0x4002_8000; +0x2000 and +0x3000 are its
   --  atomic set and clear aliases (Chapter 6).
   type Word_Row is array (0 .. 5) of Unsigned_32
     with Volatile_Components;

   INTR : Word_Row
     with Import, Address => System'To_Address (16#4002_8230#);
   INTE_Set : Word_Row
     with Import, Address => System'To_Address (16#4002_A248#);
   INTE_Clear : Word_Row
     with Import, Address => System'To_Address (16#4002_B248#);
   INTS : Word_Row
     with Import, Address => System'To_Address (16#4002_8278#);

   function Row (Id : Pin_Id) return Natural is (Natural (Id) / 8);

   function Bits_Of (Id : Pin_Id; E : Edges) return Unsigned_32 is
     (Shift_Left
        ((if E.Falling then 4 else 0) + (if E.Rising then 8 else 0),
         4 * (Natural (Id) mod 8)));

   procedure Watch (P : Input_Pin; On : Edges) is
   begin
      INTE_Clear (Row (P.Id)) :=
        Bits_Of (P.Id, (Falling => True, Rising => True));
      INTE_Set (Row (P.Id)) := Bits_Of (P.Id, On);
   end Watch;

   function Seen (P : Input_Pin) return Edges is
      Now : constant Unsigned_32 := INTS (Row (P.Id));
   begin
      return
        (Falling =>
           (Now and Bits_Of (P.Id, (Falling => True, others => <>)))
             /= 0,
         Rising =>
           (Now and Bits_Of (P.Id, (Rising => True, others => <>)))
             /= 0);
   end Seen;

   procedure Acknowledge (P : Input_Pin; Which : Edges) is
   begin
      INTR (Row (P.Id)) := Bits_Of (P.Id, Which);
   end Acknowledge;
end Keel.GPIO.RP2350;
